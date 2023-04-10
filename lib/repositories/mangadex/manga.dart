// ignore_for_file: public_member_api_docs, sort_constructors_first
import "dart:convert";

import "package:isar/isar.dart";
import "package:logging/logging.dart";
import "package:riba/repositories/local/author.dart";
import "package:riba/repositories/local/cover_art.dart";
import "package:riba/repositories/local/localization.dart";
import "package:riba/repositories/local/manga.dart";
import "package:riba/repositories/local/statistics.dart";
import "package:riba/repositories/local/tag.dart";
import "package:riba/repositories/mangadex/models/general.dart";
import "package:riba/repositories/mangadex/models/manga.dart";
import "package:riba/repositories/mangadex/models/statistics.dart";
import "package:riba/repositories/mangadex/utils/service.dart";
import "package:riba/repositories/runtime/collection.dart";
import "package:riba/repositories/runtime/manga.dart";
import "package:riba/repositories/utils/enumerate.dart";
import "package:riba/repositories/utils/exception.dart";
import "package:riba/repositories/utils/rate_limiter.dart";
import "package:riba/repositories/utils/url.dart";
import "package:riba/utils/hash.dart";

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
  late final baseUrl = rootUrl.copyWith(pathSegments: ["manga"]);
  late final statisticUrl = rootUrl.copyWith(pathSegments: ["statistics", "manga"]);

  @override
  final defaultFilters = MangaDexMangaQueryFilter(
    contentRatings: [
      MangaContentRating.safe,
      MangaContentRating.suggestive,
      MangaContentRating.erotica,
    ],
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
      final inDB = await database.manga.get(fastHash(id));
      if (inDB != null) return collectMeta(inDB);
    }

    await rateLimiter.wait("/manga:GET");
    final reqUrl = defaultFilters.addFiltersToUrl(baseUrl.copy().addPathSegment(id));
    final request = await client.get(reqUrl.toUri());
    final response = MangaEntity.fromMap(jsonDecode(request.body), url: reqUrl);

    final internalMangaData = response.data.toInternalMangaData();
    await database.writeTxn(() => insertMeta(internalMangaData));

    return internalMangaData.toMangaData();
  }

  @override
  Future<Map<String, MangaData>> getMany({required overrides, checkDB = true}) async {
    logger.info("getMany($overrides, $checkDB)");

    assert(
      overrides.ids != null,
      "This method requires ids to be populated",
    );

    final filters = defaultFilters.copyWithSelf(overrides);
    final ids = filters.ids!;
    final contentRatings = filters.contentRatings!;
    final excludedOriginalLangs = filters.excludedOriginalLanguages ?? [];

    final mapped = <String, MangaData?>{for (final e in ids) e: null};

    if (checkDB) {
      final inDB = await database.manga
          .where()
          .anyOf(ids, (q, e) => q.isarIdEqualTo(fastHash(e)))
          .filter()
          .anyOf(contentRatings, (q, e) => q.contentRatingEqualTo(e))
          .anyOf(excludedOriginalLangs, (q, e) => q.not().originalLanguageEqualTo(e))
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
    await database.writeTxn(() => Future.wait(res.values.map(insertMeta)));

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

    final filters = defaultFilters.copyWithSelf(overrides);

    if (checkDB) {
      final authorOrArtistId = filters.authorOrArtist!;
      final excludedOriginalLangs = filters.excludedOriginalLanguages ?? [];
      final contentRatings = filters.contentRatings ?? [];

      final inDB = await database.manga
          .where()
          .artistIdsElementEqualTo(authorOrArtistId)
          .or()
          .authorIdsElementEqualTo(authorOrArtistId)
          .filter()
          .anyOf(excludedOriginalLangs, (q, e) => q.not().originalLanguageEqualTo(e))
          .anyOf(contentRatings, (q, e) => q.contentRatingEqualTo(e))
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

    await database.writeTxn(() => Future.wait(mango.map(insertMeta)));
    return mango.map((e) => e.toMangaData()).toList();
  }

  @override
  @Deprecated(
      "Will not be implemented, used as a stub for the interface. Use the respective sub methods instead.")
  Future<CollectionData<MangaData>> withFilters({required overrides}) {
    throw UnimplementedError();
  }

  Future<Statistics> getStatistics(String id, {bool checkDB = true}) async {
    logger.info("getStatistics($id, $checkDB)");

    if (checkDB) {
      final inDB = await database.statistics.get(fastHash(id));
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
    await database.writeTxn(() => database.statistics.put(statistic));

    return statistic;
  }

  @override
  Future<void> insertMeta(InternalMangaData data) async {
    await Future.wait([
      database.authors.putAll(data.authors + data.artists),
      database.covers.putAll(data.covers),
      database.tags.putAll(data.tags),
      database.manga.put(data.manga),
    ]);
  }

  @override
  Future<MangaData> collectMeta(Manga single) async {
    final usableCoverId = single.preferredCoverId ?? single.defaultCoverId;
    final data = await Future.wait([
      database.authors.getAll(single.artistIds.map((e) => fastHash(e)).toList()),
      database.authors.getAll(single.authorIds.map((e) => fastHash(e)).toList()),
      database.tags.getAll(single.tagsIds.map((e) => fastHash(e)).toList()),
      usableCoverId == null ? Future.value(null) : database.covers.get(fastHash(usableCoverId)),
    ]);

    return MangaData(
      manga: single,
      authors: (data[0] as List<Author?>).cast(),
      artists: (data[1] as List<Author?>).cast(),
      tags: (data[2] as List<Tag?>).cast(),
      cover: data[3] as CoverArt?,
    );
  }
}

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
  final List<MangaContentRating>? contentRatings;
  final List<MangaPublicationDemographic>? publicationDemographics;

  final List<Language>? excludedOriginalLanguages;
  final List<Language>? availableTranslatedLanguages;

  MangaDexMangaQueryFilter({
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
    this.excludedOriginalLanguages,
    this.availableTranslatedLanguages,
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

    if (excludedOriginalLanguages != null) {
      url.setParameter("excludedOriginalLanguage[]", excludedOriginalLanguages);
    }

    if (availableTranslatedLanguages != null) {
      url.setParameter("availableTranslatedLanguage[]", availableTranslatedLanguages);
    }

    final generic = MangaDexGenericQueryFilter(
      ids: ids,
      includes: includes,
      limit: limit,
      offset: offset,
    );

    return generic.addFiltersToUrl(url);
  }

  MangaDexMangaQueryFilter copyWith({
    List<String>? ids,
    List<EntityType>? includes,
    int? limit,
    int? offset,
    String? title,
    String? authorId,
    String? artistId,
    String? artistOrAuthorId,
    List<MangaStatus>? statuses,
    List<MangaContentRating>? contentRatings,
    List<MangaPublicationDemographic>? publicationDemographics,
    List<Language>? excludedOriginalLanguages,
    List<Language>? availableTranslatedLanguages,
  }) {
    return MangaDexMangaQueryFilter(
      ids: ids ?? this.ids,
      includes: includes ?? this.includes,
      limit: limit ?? this.limit,
      offset: offset ?? this.offset,
      title: title ?? this.title,
      authorId: authorId ?? this.authorId,
      artistId: artistId ?? this.artistId,
      authorOrArtist: artistOrAuthorId ?? authorOrArtist,
      statuses: statuses ?? this.statuses,
      contentRatings: contentRatings ?? this.contentRatings,
      publicationDemographics: publicationDemographics ?? this.publicationDemographics,
      excludedOriginalLanguages: excludedOriginalLanguages ?? this.excludedOriginalLanguages,
      availableTranslatedLanguages:
          availableTranslatedLanguages ?? this.availableTranslatedLanguages,
    );
  }

  MangaDexMangaQueryFilter copyWithSelf(MangaDexMangaQueryFilter other) {
    return MangaDexMangaQueryFilter(
      ids: other.ids ?? ids,
      includes: other.includes ?? includes,
      limit: other.limit,
      offset: other.offset,
      title: other.title ?? title,
      authorId: other.authorId ?? authorId,
      artistId: other.artistId ?? artistId,
      authorOrArtist: other.authorOrArtist ?? authorOrArtist,
      statuses: other.statuses ?? statuses,
      contentRatings: other.contentRatings ?? contentRatings,
      publicationDemographics: other.publicationDemographics ?? publicationDemographics,
      excludedOriginalLanguages: other.excludedOriginalLanguages ?? excludedOriginalLanguages,
      availableTranslatedLanguages:
          other.availableTranslatedLanguages ?? availableTranslatedLanguages,
    );
  }
}
