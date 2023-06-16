// ignore_for_file: public_member_api_docs, sort_constructors_first
import "dart:convert";
import "dart:io";

import "package:copy_with_extension/copy_with_extension.dart";
import "package:isar/isar.dart";
import "package:logging/logging.dart";
import "package:riba/repositories/local/models/chapter.dart";
import "package:riba/repositories/local/models/group.dart";
import "package:riba/repositories/local/models/localization.dart";
import "package:riba/repositories/local/models/user.dart";
import "package:riba/repositories/mangadex/models/chapter.dart";
import "package:riba/repositories/mangadex/models/general.dart";
import "package:riba/repositories/mangadex/models/manga.dart";
import "package:riba/repositories/mangadex/utils/service.dart";
import "package:riba/repositories/runtime/chapter.dart";
import "package:riba/repositories/runtime/collection.dart";
import "package:riba/repositories/utils/exception.dart";
import "package:riba/repositories/utils/rate_limiter.dart";
import "package:riba/repositories/utils/url.dart";
import "package:riba/utils/hash.dart";

part "chapter.g.dart";

class MangaDexChapterService extends MangaDexService<
	ChapterAttributes, Chapter, ChapterData, ChapterData,
	MangaDexGenericQueryFilter,
	MangaDexGenericQueryFilter,
	MangaDexChapterWithFiltersQueryFilter
> {
	MangaDexChapterService({
		required super.client,
		required super.rateLimiter,
		required super.database,
		required super.rootUrl,
	});

	@override
	final logger = Logger("MangaDexChapterService");

	@override
	final rates = {
		"/chapter:GET": const Rate(4, Duration(seconds: 1)),
		"/manga/feed:GET": const Rate(2, Duration(seconds: 1)),
	};

	@override
	Directory get cacheDir => throw UnimplementedError();

	@override
	Directory get dataDir => throw UnimplementedError();

	@override
	late final baseUrl = rootUrl.copyWith(pathSegments: ["chapter"]);
	late final mangaUrl = rootUrl.copyWith(pathSegments: ["manga"]);

	@override
	final defaultFilters = 	const MangaDexGenericQueryFilter(
		includes: [
			EntityType.user,
			EntityType.scanlationGroup,
		],
	);

	@override
	Future<ChapterData> get(String id, {checkDB = true}) {
		// TODO: implement get
		throw UnimplementedError();
	}

	@override
	@Deprecated("Will not be implemented, used as a stub for the interface.")
	Future<Map<String, ChapterData>> getMany({required overrides, checkDB = true}) async {
		throw UnimplementedError();
	}

	/// Returns a list of chapters that match the given filters.
	///
	/// These results are not read from the database, but are always fetched from the MangaDex API.
	@override
	Future<CollectionData<ChapterData>> withFilters({required overrides}) async {
		logger.info("withFilters(${overrides.toString()})");

		await rateLimiter.wait("/chapter:GET");

		final reqUrl = baseUrl.clone().addFilters(defaultFilters).addFilters(overrides);
		final request = await client.get(reqUrl.toUri());
		final response = ChapterCollection.fromMap(jsonDecode(request.body), url: reqUrl);

		final chapters = <ChapterData>[];
		for (final data in response.data) {
			try {
				final chapter = data.toChapterData();
				chapters.add(chapter);
			} on LanguageNotSupportedException catch (e) {
				logger.warning(e.toString());
			}
		}

		await database.isar.writeTxn(() => Future.wait(chapters.map(insertMeta)));
		return CollectionData(
			data: chapters,
			offset: response.offset,
			limit: response.limit,
			total: response.total,
		);
	}

	/// Returns a list of chapters related to the given manga.
	///
	/// This method does not handle pagination internally,
	/// instead provide the offset (lastRequest.data.length) and limit (lastRequest.limit)
	/// when calling this method.
	/// 
	/// Local fetches does not handle limit and offset internally as it is
	/// impossible to do so with sorts and filters.
	Future<CollectionData<ChapterData>> getFeed({
		required MangaDexChapterGetFeedQueryFilter overrides,
		bool checkDB = true,
	}) async {
		logger.info("getFeed(${overrides.toString()}, $checkDB)");

		if (checkDB) {
			final excludedGroups = overrides.excludedGroups ?? const [];
			final translatedLangs = overrides.translatedLanguages ?? const [];

			final inDB = await database
				.where()
				.mangaIdEqualTo(overrides.mangaId)
				.filter()
				.not()
				.group((q) => q.anyOf(excludedGroups, (q, e) => q.groupIdsElementContains(e)))
				.and()
				.anyOf(translatedLangs, (q, e) => q.translatedLanguageEqualTo(e))
				.findAll();
			
			if (inDB.isNotEmpty) {
				if (overrides.orderByChapterDesc) inDB.sortInDesc();
				final data = await database.isar.txn(() => Future.wait(inDB.map((e) => collectMeta(e))));

				return CollectionData(
					data: data,
					offset: -1,
					limit: -1,
					total: data.length,
				);
			}
		}

		await rateLimiter.wait("/manga/feed:GET");
		final reqUrl = mangaUrl.clone().addFilters(defaultFilters).addFilters(overrides);
		final request = await client.get(reqUrl.toUri());
		final response = ChapterCollection.fromMap(jsonDecode(request.body), url: reqUrl);

		final chapters = <ChapterData>[];
		for (final data in response.data) {
			try {
				final chapterData = data.toChapterData();
				chapters.add(chapterData);
			} on LanguageNotSupportedException catch (e) {
				logger.warning(e.toString());
			}
		}

		await database.isar.writeTxn(() => Future.wait(chapters.map(insertMeta)));
		return CollectionData(
			data: chapters,
			offset: response.offset,
			limit: response.limit,
			total: response.total,
		);
	}

	@override
	Future<void> insertMeta(ChapterData data) async {
		await Future.wait([
			database.put(data.chapter),
			database.isar.groups.putAll(data.groups),
			database.isar.users.put(data.uploader),
		]);
	}

	@override
	Future<ChapterData> collectMeta(Chapter single) async {
		final data = await Future.wait([
			database.isar.groups.getAll(single.groupIds.map((e) => fastHash(e)).toList()),
			database.isar.users.get(fastHash(single.uploaderId)),
		]);

		return ChapterData(
			chapter: single,
			groups: (data[0] as List<Group?>).cast(),
			uploader: data[1] as User,
		);
	}
}

@CopyWith()
class MangaDexChapterGetFeedQueryFilter implements MangaDexQueryFilter {
	final int limit;
	final int offset;

	/// Get feed method uses the /manga/{id}/feed endpoint, so the manga id is applied as a path segment.
	final String mangaId;

	final bool orderByChapterDesc;
	final List<Language>? translatedLanguages;
	final List<String>? excludedGroups;

	const MangaDexChapterGetFeedQueryFilter({
		this.limit = 100,
		this.offset = 0,
		required this.mangaId,
		this.orderByChapterDesc = true,
		this.translatedLanguages,
		this.excludedGroups,
	});
	
	@override
	URL addFiltersToUrl(URL sourceUrl) {
		sourceUrl.addPathSegments([mangaId, "feed"]);

		if (orderByChapterDesc) sourceUrl.setParameter("order[chapter]", "desc");
		if (translatedLanguages != null) sourceUrl.setParameter("translatedLanguage[]", translatedLanguages);
		if (excludedGroups != null) sourceUrl.setParameter("excludedGroups[]", excludedGroups);

		return MangaDexGenericQueryFilter(limit: limit, offset: offset).addFiltersToUrl(sourceUrl);
	}

	@override
	String toString() {
		return "MangaDexChapterGetFeedQueryFilter(limit: $limit, offset: $offset, mangaId: $mangaId, orderByChapterDesc: $orderByChapterDesc, translatedLanguages: $translatedLanguages, excludedGroups: $excludedGroups)";
	}
}

@CopyWith()
class MangaDexChapterWithFiltersQueryFilter implements MangaDexQueryFilter {
	final int limit;
	final int offset;
	final bool orderByChapterDesc;

	final List<String>? ids;
	final List<Language>? translatedLanguages;
	final List<String>? excludedGroups;
	final List<ContentRating>? contentRatings;

	const MangaDexChapterWithFiltersQueryFilter({
		this.limit = 100,
		this.offset = 0,
		this.orderByChapterDesc = true,
		this.ids,
		this.translatedLanguages,
		this.excludedGroups,
		this.contentRatings,
	});
	
	@override
	URL addFiltersToUrl(URL sourceUrl) {
		if (orderByChapterDesc) sourceUrl.setParameter("order[chapter]", "desc");
		if (ids != null) sourceUrl.setParameter("ids[]", ids);
		if (translatedLanguages != null) sourceUrl.setParameter("translatedLanguage[]", translatedLanguages);
		if (excludedGroups != null) sourceUrl.setParameter("excludedGroups[]", excludedGroups);
		if (contentRatings != null) sourceUrl.setParameter("contentRating[]", contentRatings);

		return MangaDexGenericQueryFilter(limit: limit, offset: offset).addFiltersToUrl(sourceUrl);
	}

	@override
	String toString() {
		return "MangaDexChapterWithFiltersQueryFilter(limit: $limit, offset: $offset, orderByChapterDesc: $orderByChapterDesc, ids: $ids, translatedLanguages: $translatedLanguages, excludedGroups: $excludedGroups, contentRatings: $contentRatings)";
	}
}
