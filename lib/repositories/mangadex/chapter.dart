import "dart:convert";

import "package:isar/isar.dart";
import "package:logging/logging.dart";
import "package:riba/repositories/local/chapter.dart";
import "package:riba/repositories/local/group.dart";
import "package:riba/repositories/local/localization.dart";
import "package:riba/repositories/local/user.dart";
import "package:riba/repositories/mangadex.dart";
import "package:riba/repositories/mangadex/models/chapter.dart";
import "package:riba/repositories/mangadex/models/general.dart";
import "package:riba/repositories/mangadex/utils/service.dart";
import "package:riba/repositories/runtime/chapter.dart";
import "package:riba/repositories/utils/enumerate.dart";
import "package:riba/repositories/utils/exception.dart";
import "package:riba/repositories/utils/rate_limiter.dart";
import "package:riba/repositories/utils/url.dart";
import "package:riba/utils/hash.dart";

class MangaDexChapterService
    extends MangaDexService<ChapterAttributes, Chapter, ChapterData, MangaDexChapterQueryFilter> {
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
  };

  @override
  late final baseUrl = rootUrl.copyWith(pathSegments: ["chapter"]);
  late final mangaUrl = rootUrl.copyWith(pathSegments: ["manga"]);

  @override
  final defaultFilters = MangaDexChapterQueryFilter(
    includes: [
      EntityType.user,
      EntityType.scanlationGroup,
    ],
    orderByChapterDesc: true,
    limit: 100,
  );

  @override
  MangaDexChapterService get instance => MangaDex.instance.chapter;

  @override
  Future<Chapter> get(String id, {bool checkDB = true}) {
    throw UnimplementedError();
  }

  /// Gets a list of chapters from MangaDex.
  @override
  Future<Map<String, Chapter>> getMany({
    required MangaDexChapterQueryFilter overrides,
    bool checkDB = true,
  }) async {
    logger.info("getMany($overrides, $checkDB)");

    final ids = overrides.ids!;
    final filters = defaultFilters.copyWith(overrides);
    final Map<String, ChapterData?> mapped = {for (final e in ids) e: null};

    if (checkDB) {
      final inDB = await database.chapters.getAll(ids.map((e) => fastHash(e)).toList());
      for (final chapter in inDB) {
        if (chapter == null) continue;
        mapped[chapter.id] = await collectMeta(chapter);
      }
    }

    final missing = mapped.entries.where((e) => e.value == null).map((e) => e.key).toList();
    if (missing.isEmpty) return mapped.cast();

    final block = Enumerate<String, ChapterData>(
      perStep: 100,
      items: missing,
      onStep: (resolved) async {
        await rateLimiter.wait("/chapter:GET");

        final reqUrl = filters.addFiltersToUrl(baseUrl.copy());
        final request = await client.get(reqUrl.toUri());
        final response = ChapterCollection.fromMap(jsonDecode(request.body), url: reqUrl);

        for (final data in response.data) {
          try {
            final chapter = data.toChapterData();
            insertMeta(chapter);
            resolved[data.id] = chapter;
          } on LanguageNotSupportedException catch (e) {
            logger.warning(e.toString());
          }
        }
      },
      onMismatch: (missedIds) {
        logger.warning("Some entries were not in the response, ignoring them: $missedIds");
      },
    );

    mapped.addAll(await block.run());
    return mapped.cast();
  }

  Future<List<ChapterData>> getFeed({
    required MangaDexChapterQueryFilter overrides,
    bool checkDB = true,
  }) async {
    logger.info("getFeed($overrides, $checkDB)");
    assert(overrides.mangaId != null, "Manga ID must be specified");
    assert(overrides.ids == null, "IDs cannot be specified");

    final filters = defaultFilters.copyWith(overrides);
    final mangaId = filters.mangaId!;
    final excludedGroups = filters.excludedGroups ?? [];
    final translatedLanguages = filters.translatedLanguages ?? [];

    if (checkDB) {
      final inDB = await database.chapters
          .where()
          .mangaIdEqualTo(mangaId)
          .filter()
          .group((q) => q.anyOf(excludedGroups, (q, e) => q.not().groupIdsElementContains(e)))
          .translatedLanguage(
              (q) => q.anyOf(translatedLanguages, (q, e) => q.codeEqualTo(e.isoCode)))
          .findAll();

      inDB.sortAsDescending();

      if (inDB.isNotEmpty) {
        final chapterFuture = <Future<ChapterData>>[];
        for (final chapter in inDB) {
          chapterFuture.add(collectMeta(chapter));
        }

        return await Future.wait(chapterFuture);
      }
    }

    await rateLimiter.wait("/manga:GET");
    final reqUrl = filters.addFiltersToUrl(mangaUrl.copy().addPathSegments([mangaId, "feed"]));
    final request = await client.get(reqUrl.toUri());
    final response = ChapterCollection.fromMap(jsonDecode(request.body), url: reqUrl);

    final chapters = <ChapterData>[];
    for (final data in response.data) {
      try {
        final chapterData = data.toChapterData();
        insertMeta(chapterData);
        chapters.add(chapterData);
      } on LanguageNotSupportedException catch (e) {
        logger.warning(e.toString());
      }
    }

    return chapters;
  }

  @override
  Future<void> insertMeta(ChapterData data) async {
    await database.writeTxn(() async {
      await Future.wait([
        database.chapters.put(data.chapter),
        database.groups.putAll(data.groups),
        database.users.put(data.uploader),
      ]);
    });
  }

  @override
  Future<ChapterData> collectMeta(Chapter single) async {
    final data = await Future.wait([
      database.groups.getAll(single.groupIds.map((e) => fastHash(e)).toList()),
      database.users.get(fastHash(single.uploaderId)),
    ]);

    return ChapterData(
      chapter: single,
      groups: (data[0] as List<Group?>).cast(),
      uploader: data[1] as User,
    );
  }
}

class MangaDexChapterQueryFilter extends MangaDexQueryFilter {
  final List<String>? ids;
  final List<EntityType>? includes;
  final int? limit;

  final String? mangaId;
  final bool? orderByChapterDesc;
  final List<Language>? translatedLanguages;
  final List<String>? excludedGroups;

  MangaDexChapterQueryFilter({
    this.ids,
    this.includes,
    this.limit,
    this.mangaId,
    this.orderByChapterDesc,
    this.translatedLanguages,
    this.excludedGroups,
  });

  @override
  URL addFiltersToUrl(URL url) {
    if (orderByChapterDesc != null && orderByChapterDesc!) {
      url.setParameter("order[chapter]", "desc");
    }

    if (mangaId != null) {
      url.setParameter("manga", mangaId);
    }

    if (translatedLanguages != null) {
      url.setParameter("translatedLanguage[]", translatedLanguages!.map((e) => e.isoCode).toList());
    }

    if (excludedGroups != null) {
      url.setParameter("excludedGroups[]", excludedGroups);
    }

    final generic = MangaDexGenericQueryFilter(
      ids: ids,
      includes: includes,
      limit: limit,
    );

    return generic.addFiltersToUrl(url);
  }

  MangaDexChapterQueryFilter copyWith(MangaDexChapterQueryFilter other) {
    return MangaDexChapterQueryFilter(
      ids: other.ids ?? ids,
      includes: other.includes ?? includes,
      limit: other.limit ?? limit,
      mangaId: other.mangaId ?? mangaId,
      orderByChapterDesc: other.orderByChapterDesc ?? orderByChapterDesc,
    );
  }

  @override
  String toString() {
    return "MangaDexChapterQueryFilter("
        "ids: $ids, includes: $includes, limit: $limit,"
        "orderByChapterDesc: $orderByChapterDesc, mangaId: $mangaId)";
  }
}
