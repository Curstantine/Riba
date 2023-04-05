// ignore_for_file: public_member_api_docs, sort_constructors_first
import "dart:convert";

import "package:logging/logging.dart";
import "package:riba/repositories/local/author.dart";
import "package:riba/repositories/local/cover_art.dart";
import "package:riba/repositories/local/localization.dart";
import "package:riba/repositories/local/manga.dart";
import "package:riba/repositories/local/statistics.dart";
import "package:riba/repositories/local/tag.dart";
import "package:riba/repositories/mangadex.dart";
import "package:riba/repositories/mangadex/models/general.dart";
import "package:riba/repositories/mangadex/models/manga.dart";
import "package:riba/repositories/mangadex/models/statistics.dart";
import "package:riba/repositories/mangadex/utils/service.dart";
import "package:riba/repositories/runtime/manga.dart";
import "package:riba/repositories/utils/enumerate.dart";
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
    includes: [
      EntityType.artist,
      EntityType.author,
      EntityType.coverArt,
    ],
    limit: 100,
  );

  @override
  MangaDexMangaService get instance => MangaDex.instance.manga;

  @override
  Future<MangaData> get(String id, {bool checkDB = true}) async {
    logger.info("get($id, $checkDB)");

    if (checkDB) {
      final inDB = await database.manga.get(fastHash(id));
      if (inDB != null) return collectMeta(inDB);
    }

    await rateLimiter.wait("/manga:GET");
    final reqUrl =
        baseUrl.copy().addPathSegment(id).setParameter("includes[]", defaultFilters.includes);
    final request = await client.get(reqUrl.toUri());

    final response = MangaEntity.fromMap(jsonDecode(request.body), url: reqUrl);
    final internalMangaData = response.data.toInternalMangaData();
    insertMeta(internalMangaData);

    return internalMangaData.toMangaData();
  }

  @override
  Future<Map<String, MangaData>> getMany({
    required MangaDexMangaQueryFilter overrides,
    bool checkDB = true,
  }) async {
    logger.info("getMany($overrides, $checkDB)");

    final ids = overrides.ids ?? [];
    final filters = defaultFilters.copyWith(overrides);
    final Map<String, MangaData?> mapped = {for (final e in ids) e: null};

    if (checkDB) {
      final inDB = await database.manga.getAll(ids.map((e) => fastHash(e)).toList());
      for (final manga in inDB) {
        if (manga == null) continue;
        mapped[manga.id] = await collectMeta(manga);
      }
    }

    final missing = mapped.entries.where((e) => e.value == null).map((e) => e.key).toList();
    if (missing.isEmpty) return mapped.cast();

    final block = Enumerate<String, MangaData>(
      perStep: 100,
      items: missing,
      onStep: (resolved) async {
        await rateLimiter.wait("/manga:GET");
        final reqUrl = filters.addFiltersToUrl(baseUrl.copy());
        final request = await client.get(reqUrl.toUri());
        final response = MangaCollection.fromMap(jsonDecode(request.body), url: reqUrl);

        for (final data in response.data) {
          final internalMangaData = data.toInternalMangaData();
          insertMeta(internalMangaData);
          resolved[data.id] = internalMangaData.toMangaData();
        }
      },
      onMismatch: (missedIds) {
        logger.warning("Some entries were not in the response, ignoring them: $missedIds");
      },
    );

    mapped.addAll(await block.run());
    return mapped.cast();
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

    final response = MDStatistics.fromMap(
      jsonDecode(request.body),
      type: EntityType.manga,
      url: reqUrl,
    );

    final statistic = response.statistics[id]!.toStatistics();
    database.writeTxn(() async => await database.statistics.put(statistic));

    return statistic;
  }

  @override
  Future<void> insertMeta(InternalMangaData data) async {
    await database.writeTxn(() async {
      await Future.wait([
        database.authors.putAll(data.authors + data.artists),
        database.covers.putAll(data.covers),
        database.tags.putAll(data.tags),
        database.manga.put(data.manga),
      ]);
    });
  }

  @override
  Future<MangaData> collectMeta(Manga single) async {
    final data = await Future.wait([
      database.authors.getAll(single.artistIds.map((e) => fastHash(e)).toList()),
      database.authors.getAll(single.authorIds.map((e) => fastHash(e)).toList()),
      database.tags.getAll(single.tagsIds.map((e) => fastHash(e)).toList()),
      single.usedCoverId != null
          ? database.covers.get(fastHash(single.usedCoverId!))
          : Future.value(null),
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
  final int? limit;
  final int? offset;

  final String? title;
  final List<String>? authorIds;
  final List<String>? artistIds;

  final List<MangaStatus>? statuses;
  final List<MangaContentRating>? contentRatings;
  final List<MangaPublicationDemographic>? publicationDemographics;

  final List<Language>? originalLanguages;
  final List<Language>? excludedOriginalLanguages;
  final List<Language>? availableTranslatedLanguages;

  MangaDexMangaQueryFilter({
    this.ids,
    this.includes,
    this.limit,
    this.offset,
    this.title,
    this.authorIds,
    this.artistIds,
    this.statuses,
    this.contentRatings,
    this.publicationDemographics,
    this.originalLanguages,
    this.excludedOriginalLanguages,
    this.availableTranslatedLanguages,
  });

  @override
  URL addFiltersToUrl(URL url) {
    if (title != null) url.setParameter("title", title);
    if (authorIds != null) url.setParameter("authors[]", authorIds);
    if (artistIds != null) url.setParameter("artists[]", artistIds);
    if (statuses != null) url.setParameter("status[]", statuses);
    if (contentRatings != null) url.setParameter("contentRating[]", contentRatings);

    if (publicationDemographics != null) {
      url.setParameter("publicationDemographic[]", publicationDemographics);
    }

    if (originalLanguages != null) {
      url.setParameter("originalLanguage[]", originalLanguages);
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

  MangaDexMangaQueryFilter copyWith(MangaDexMangaQueryFilter other) {
    return MangaDexMangaQueryFilter(
      ids: other.ids ?? ids,
      includes: other.includes ?? includes,
      limit: other.limit ?? limit,
      offset: other.offset ?? offset,
      title: other.title ?? title,
      authorIds: other.authorIds ?? authorIds,
      artistIds: other.artistIds ?? artistIds,
      statuses: other.statuses ?? statuses,
      contentRatings: other.contentRatings ?? contentRatings,
      publicationDemographics: other.publicationDemographics ?? publicationDemographics,
      originalLanguages: other.originalLanguages ?? originalLanguages,
      excludedOriginalLanguages: other.excludedOriginalLanguages ?? excludedOriginalLanguages,
      availableTranslatedLanguages:
          other.availableTranslatedLanguages ?? availableTranslatedLanguages,
    );
  }
}
