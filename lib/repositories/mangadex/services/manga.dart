// ignore_for_file: public_member_api_docs, sort_constructors_first
import "dart:convert";
import "dart:io";

import "package:copy_with_extension/copy_with_extension.dart";
import "package:isar/isar.dart";
import "package:logging/logging.dart";
import "package:riba/repositories/local/models/author.dart";
import "package:riba/repositories/local/models/cover_art.dart";
import "package:riba/repositories/local/models/localization.dart";
import "package:riba/repositories/local/models/manga.dart";
import "package:riba/repositories/local/models/statistics.dart";
import "package:riba/repositories/local/models/tag.dart";
import "package:riba/repositories/mangadex/models/general.dart";
import "package:riba/repositories/mangadex/models/manga.dart";
import "package:riba/repositories/mangadex/models/statistics.dart";
import "package:riba/repositories/mangadex/models/tag.dart";
import "package:riba/repositories/mangadex/utils/service.dart";
import "package:riba/repositories/runtime/collection.dart";
import "package:riba/repositories/runtime/manga.dart";
import "package:riba/repositories/utils/enumerate.dart";
import "package:riba/repositories/utils/exception.dart";
import "package:riba/repositories/utils/rate_limiter.dart";
import "package:riba/repositories/utils/url.dart";
import "package:riba/utils/hash.dart";

part "manga.g.dart";

class MangaDexMangaService extends MangaDexService<MangaAttributes, Manga, MangaData,
	InternalMangaData, MangaDexMangaQueryFilter> {
	MangaDexMangaService({
		required super.client,
		required super.rateLimiter,
		required super.database,
		required super.rootUrl,
	});

	@override
	final logger = Logger("MangaDexMangaService");

	@override
	final Map<String, Rate> rates = {
		"/manga:GET": const Rate(4, Duration(seconds: 1)),
		"/statistics/manga:GET": const Rate(4, Duration(seconds: 1)),
	};

	@override
	Directory get cacheDir => throw UnimplementedError();

	@override
	Directory get dataDir => throw UnimplementedError();

	@override
	late final baseUrl = rootUrl.copyWith(pathSegments: ["manga"]);
	late final statisticUrl = rootUrl.copyWith(pathSegments: ["statistics", "manga"]);

	@override
	final defaultFilters = const MangaDexMangaQueryFilter(
		includes: [
			EntityType.artist,
			EntityType.author,
			EntityType.coverArt,
		],
		limit: 100,
	);

	@override
	Future<MangaData> get(String id, {bool checkDB = true}) async {
		logger.info("get($id, $checkDB)");

		if (checkDB) {
			final inDB = await database.get(fastHash(id));
			if (inDB != null) return collectMeta(inDB);
		}

		await rateLimiter.wait("/manga:GET");
		final reqUrl = defaultFilters.addFiltersToUrl(baseUrl.copy().addPathSegment(id));
		final request = await client.get(reqUrl.toUri());
		final response = MangaEntity.fromMap(jsonDecode(request.body), url: reqUrl);

		final internalMangaData = response.data.toInternalMangaData();
		await database.isar.writeTxn(() => insertMeta(internalMangaData));

		return internalMangaData.toMangaData();
	}

	@override
	Future<Map<String, MangaData>> getMany({required overrides, checkDB = true}) async {
		logger.info("getMany($overrides, $checkDB)");

		assert(
			overrides.ids != null,
			"This method requires ids to be populated",
		);

		final filters = defaultFilters.copyWith(
			ids: overrides.ids,
			contentRatings: overrides.contentRatings,
			originalLanguages: overrides.originalLanguages,
			statuses: overrides.statuses,
		);

		final mapped = <String, MangaData?>{for (final e in filters.ids!) e: null};

		if (checkDB) {
			final contentRatings = filters.contentRatings ?? [];
			final originalLangs = filters.originalLanguages ?? [];
			final statuses = filters.statuses ?? [];

			final inDB = await database
				.where()
				.anyOf(filters.ids!, (q, e) => q.isarIdEqualTo(fastHash(e)))
				.filter()
				.anyOf(contentRatings, (q, e) => q.contentRatingEqualTo(e))
				.anyOf(originalLangs, (q, e) => q.originalLanguageEqualTo(e))
				.anyOf(statuses, (q, element) => q.statusEqualTo(element))
				.findAll();

			for (final manga in inDB) {
				mapped[manga.id] = await collectMeta(manga);
			}
		}

		final missing = mapped.entries.where((e) => e.value == null).map((e) => e.key).toList();
		if (missing.isEmpty) return mapped.cast<String, MangaData>();

		final block = Enumerate<String, InternalMangaData>(
			items: missing,
			perStep: defaultFilters.limit,
			onStep: (resolved) async {
				final tempFilter = filters.copyWith(ids: resolved.keys.toList());
				final reqUrl = tempFilter.addFiltersToUrl(baseUrl.copy());
				final request = await client.get(reqUrl.toUri());
				final response = MangaCollection.fromMap(jsonDecode(request.body), url: reqUrl);

				for (final manga in response.data) {
					resolved[manga.id] = manga.toInternalMangaData();
				}
			},
			onMismatch: (missedIds) {
				logger.warning("Some entries were not in the response, ignoring them: $missedIds");
				for (final id in missedIds) {
					mapped.remove(id);
				}
			},
		);

		final res = await block.run();
		await database.isar.writeTxn(() => Future.wait(res.values.map(insertMeta)));

		return mapped.cast<String, MangaData>()
			..addAll(res.map((k, v) => MapEntry(k, v.toMangaData())));
  }

	Future<List<MangaData>> getByAuthorOrArtistId({
		bool checkDB = true,
		required MangaDexMangaQueryFilter overrides,
	}) async {
		logger.info("getByArtistOrAuthorId($overrides, $checkDB)");

		assert(
			overrides.authorOrArtist != null,
			"This method requires artistOrAuthorId to be populated",
		);

		final filters = defaultFilters.copyWith(
			authorOrArtist: overrides.authorOrArtist,
			contentRatings: overrides.contentRatings,
			originalLanguages: overrides.originalLanguages,
			statuses: overrides.statuses,
		);

		if (checkDB) {
			final authorOrArtistId = filters.authorOrArtist!;
			final contentRatings = filters.contentRatings ?? [];
			final originalLangs = filters.originalLanguages ?? [];
			final statuses = filters.statuses ?? [];

			final inDB = await database
				.where()
				.artistIdsElementEqualTo(authorOrArtistId)
				.or()
				.authorIdsElementEqualTo(authorOrArtistId)
				.filter()
				.anyOf(contentRatings, (q, e) => q.contentRatingEqualTo(e))
				.anyOf(originalLangs, (q, e) => q.originalLanguageEqualTo(e))
				.anyOf(statuses, (q, element) => q.statusEqualTo(element))
				.findAll();

			if (inDB.isNotEmpty) {
				final mangaFuture = inDB.map((e) => collectMeta(e));
				return await Future.wait(mangaFuture);
			}
		}

		int offset = 0;
		final mango = <InternalMangaData>[];

		while (true) {
			await rateLimiter.wait("/manga:GET");
			final tempFilters = filters.copyWith(offset: offset);
			final reqUrl = tempFilters.addFiltersToUrl(baseUrl.copy());
			final request = await client.get(reqUrl.toUri());
			final response = MangaCollection.fromMap(jsonDecode(request.body), url: reqUrl);

			for (final manga in response.data) {
				try {
					mango.add(manga.toInternalMangaData());
				} on LanguageNotSupportedException catch (e) {
					logger.warning(e);
				}
			}

			if ((response.offset + response.limit) >= response.total) break;
			offset += response.limit;
		}

		await database.isar.writeTxn(() => Future.wait(mango.map(insertMeta)));
		return mango.map((e) => e.toMangaData()).toList();
	}

	@override
	Future<CollectionData<MangaData>> withFilters({required overrides}) async {
		logger.info("withFilters($overrides)");

		final filters = defaultFilters.copyWith(
			artistId: overrides.artistId,
			authorId: overrides.authorId,
			contentRatings: overrides.contentRatings,
			originalLanguages: overrides.originalLanguages,
			statuses: overrides.statuses,
			excludedTagIds: overrides.excludedTagIds,
			includedTagIds: overrides.includedTagIds,
			excludedTagJoinMode: overrides.excludedTagJoinMode,
			includedTagJoinMode: overrides.includedTagJoinMode,
			availableTranslatedLanguages: overrides.availableTranslatedLanguages,
			publicationDemographics: overrides.publicationDemographics,
			title: overrides.title,
			authorOrArtist: overrides.authorOrArtist,
			limit: overrides.limit,
			offset: overrides.offset,
			
		);

		final reqUrl = filters.addFiltersToUrl(baseUrl.copy());

		final request = await client.get(reqUrl.toUri());
		final response = MangaCollection.fromMap(jsonDecode(request.body), url: reqUrl);

		final data = response.data.map((e) => e.toInternalMangaData()).toList();
		await database.isar.writeTxn(() => Future.wait(data.map(insertMeta)));

		return CollectionData(
			data: data.map((e) => e.toMangaData()).toList(),
			limit: response.limit,
			offset: response.offset,
			total: response.total,
		);
	}

	Future<Statistics> getStatistics(String id, {bool checkDB = true}) async {
		logger.info("getStatistics($id, $checkDB)");

		if (checkDB) {
			final inDB = await database.isar.statistics.get(fastHash(id));
			if (inDB != null) return inDB;
		}

		await rateLimiter.wait("/statistics/manga:GET");
		final reqUrl = statisticUrl.copy().addPathSegment(id);
		final request = await client.get(reqUrl.toUri());

		final response = MDStatistics.fromJson(
			jsonDecode(request.body),
			type: EntityType.manga,
			url: reqUrl,
		);

		final statistic = response.statistics[id]!.toStatistics();
		await database.isar.writeTxn(() => database.isar.statistics.put(statistic));

		return statistic;
	}

	@override
	Future<void> insertMeta(InternalMangaData data) async {
		await Future.wait([
			database.isar.authors.putAll(data.authors + data.artists),
			database.isar.covers.putAll(data.covers),
			database.isar.tags.putAll(data.tags),
			database.put(data.manga),
		]);
	}

	@override
	Future<MangaData> collectMeta(Manga single) async {
		final usableCoverId = single.preferredCoverId ?? single.defaultCoverId;
		final data = await Future.wait([
			database.isar.authors.getAll(single.artistIds.map((e) => fastHash(e)).toList()),
			database.isar.authors.getAll(single.authorIds.map((e) => fastHash(e)).toList()),
			database.isar.tags.getAll(single.tagsIds.map((e) => fastHash(e)).toList()),
			usableCoverId == null
				? Future.value(null)
				: database.isar.covers.get(fastHash(usableCoverId)),
		]);

		return MangaData(
			manga: single,
			authors: (data[0] as List<Author?>).cast(),
			artists: (data[1] as List<Author?>).cast(),
			tags: (data[2] as List<Tag?>).cast(),
			cover: data[3] as CoverArt?,
		);
	}

	Future<List<Tag>> getAllTags({bool checkDB = true}) async {
		logger.info("getAllTags($checkDB)");

		if (checkDB) {
			final inDB = await database.isar.tags
				.where()
				.sortByGroup()
				.findAll();
			if (inDB.isNotEmpty) return inDB;
		} 

		await rateLimiter.wait("/manga:GET");
		final reqUrl = baseUrl.copy().addPathSegment("tag");
		final request = await client.get(reqUrl.toUri());

		final response = TagCollection.fromMap(jsonDecode(request.body), url: reqUrl);
		final tags = response.data.map((e) => e.toTag()).toList();

		await database.isar.writeTxn(() => database.isar.tags.putAll(tags));
		return tags;
	}
}

@CopyWith()
class MangaDexMangaQueryFilter extends MangaDexQueryFilter {
	final List<String>? ids;
	final List<EntityType>? includes;
	final int limit;
	final int offset;

	final String? title;
	final String? authorId;
	final String? artistId;
	final String? authorOrArtist;

	final List<MangaStatus>? statuses;
	final List<ContentRating>? contentRatings;
	final List<MangaPublicationDemographic>? publicationDemographics;

	final List<Language>? originalLanguages;
	final List<Language>? availableTranslatedLanguages;

	final List<String>? excludedTagIds;
	final TagJoinMode? excludedTagJoinMode;

	final List<String>? includedTagIds;
	final TagJoinMode? includedTagJoinMode;

	const MangaDexMangaQueryFilter({
		this.ids,
		this.includes,
		this.limit = 100,
		this.offset = 0,
		this.title,
		this.authorId,
		this.artistId,
		this.authorOrArtist,
		this.statuses,
		this.contentRatings,
		this.publicationDemographics,
		this.originalLanguages,
		this.availableTranslatedLanguages,
		this.excludedTagIds,
		this.excludedTagJoinMode,
		this.includedTagIds,
		this.includedTagJoinMode,
	});

	@override
	URL addFiltersToUrl(URL url) {
		if (title != null) url.setParameter("title", title);
		if (authorId != null) url.setParameter("authors[]", authorId);
		if (artistId != null) url.setParameter("artists[]", artistId);
		if (authorOrArtist != null) url.setParameter("authorOrArtist", authorOrArtist);
		if (statuses != null) url.setParameter("status[]", statuses);
		if (contentRatings != null) url.setParameter("contentRating[]", contentRatings);

		if (publicationDemographics != null) {
			url.setParameter("publicationDemographic[]", publicationDemographics);
		}

		if (originalLanguages != null) {
			url.setParameter("originalLanguage[]", originalLanguages);
		}

		if (availableTranslatedLanguages != null) {
			url.setParameter("availableTranslatedLanguage[]", availableTranslatedLanguages);
		}

		if (excludedTagIds != null) {
			url.setParameter("excludedTags[]", excludedTagIds);
			url.setParameter("excludedTagsMode", excludedTagJoinMode);
		}

		if (includedTagIds != null) {
			url.setParameter("includedTags[]", includedTagIds);
			url.setParameter("includedTagsMode", includedTagJoinMode);
		}

		final generic = MangaDexGenericQueryFilter(
			ids: ids,
			includes: includes,
			limit: limit,
			offset: offset,
		);

		return generic.addFiltersToUrl(url);
	}
}
