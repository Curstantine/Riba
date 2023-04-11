// ignore_for_file: public_member_api_docs, sort_constructors_first
import "dart:convert";
import "dart:io";

import "package:isar/isar.dart";
import "package:logging/logging.dart";
import "package:riba/repositories/local/chapter.dart";
import "package:riba/repositories/local/group.dart";
import "package:riba/repositories/local/localization.dart";
import "package:riba/repositories/local/user.dart";
import "package:riba/repositories/mangadex/models/chapter.dart";
import "package:riba/repositories/mangadex/models/general.dart";
import "package:riba/repositories/mangadex/utils/service.dart";
import "package:riba/repositories/runtime/chapter.dart";
import "package:riba/repositories/runtime/collection.dart";
import "package:riba/repositories/utils/exception.dart";
import "package:riba/repositories/utils/rate_limiter.dart";
import "package:riba/repositories/utils/url.dart";
import "package:riba/utils/hash.dart";

class MangaDexChapterService extends MangaDexService<ChapterAttributes, Chapter, ChapterData,
    ChapterData, MangaDexChapterQueryFilter> {
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
  final defaultFilters = MangaDexChapterQueryFilter(
    includes: [
      EntityType.user,
      EntityType.scanlationGroup,
    ],
    orderByChapterDesc: true,
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
    logger.info("withFilters($overrides)");

    final filters = defaultFilters.copyWithSelf(overrides);
    await rateLimiter.wait("/chapter:GET");

    final reqUrl = filters.addFiltersToUrl(baseUrl.copy());
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
  Future<CollectionData<ChapterData>> getFeed({
    required MangaDexChapterQueryFilter overrides,
    bool checkDB = true,
  }) async {
    logger.info("getFeed($overrides, $checkDB)");
    assert(overrides.mangaId != null, "Manga ID must be specified");

    // Manga ID in the filter should be ignored, since id is part of the path segments.
    final filters = defaultFilters.copyWithSelf(overrides)..mangaId = null;
    final mangaId = overrides.mangaId!;
    final excludedGroups = filters.excludedGroups ?? [];
    final translatedLangs = filters.translatedLanguages ?? [];
    final orderByChapterDesc = filters.orderByChapterDesc;

    if (checkDB) {
      final inDB = await database
          .where()
          .mangaIdEqualTo(mangaId)
          .filter()
          .group((q) => q.anyOf(excludedGroups, (q, e) => q.not().groupIdsElementContains(e)))
          .anyOf(translatedLangs, (q, e) => q.translatedLanguageEqualTo(e))
          .optional(orderByChapterDesc == true, (q) => q.sortByChapterDesc().thenByVolumeDesc())
          .findAll();

      if (inDB.isNotEmpty) {
        final chapterFuture = database.isar.txn(() => Future.wait(inDB.map((e) => collectMeta(e))));

        return CollectionData(
          data: await chapterFuture,
          offset: filters.offset,
          limit: filters.limit,
          total: -1,
        );
      }
    }

    await rateLimiter.wait("/manga/feed:GET");
    final tempBaseUrl = mangaUrl.copy().addPathSegments([mangaId, "feed"]);
    final reqUrl = filters.addFiltersToUrl(tempBaseUrl);
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

class MangaDexChapterQueryFilter extends MangaDexQueryFilter {
  final List<String>? ids;
  final List<EntityType>? includes;
  final int limit;
  final int offset;

  String? mangaId;
  final bool? orderByChapterDesc;
  final List<Language>? translatedLanguages;
  final List<String>? excludedGroups;

  MangaDexChapterQueryFilter({
    this.ids,
    this.includes,
    this.offset = 0,
    this.limit = 100,
    this.mangaId,
    this.orderByChapterDesc,
    this.translatedLanguages,
    this.excludedGroups,
  });

  @override
  URL addFiltersToUrl(URL url) {
    if (orderByChapterDesc == true) {
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
      offset: offset,
    );

    return generic.addFiltersToUrl(url);
  }

  MangaDexChapterQueryFilter copyWith({
    List<String>? ids,
    List<EntityType>? includes,
    int? limit,
    int? offset,
    String? mangaId,
    bool? orderByChapterDesc,
    List<Language>? translatedLanguages,
    List<String>? excludedGroups,
  }) {
    return MangaDexChapterQueryFilter(
      ids: ids ?? this.ids,
      includes: includes ?? this.includes,
      limit: limit ?? this.limit,
      offset: offset ?? this.offset,
      mangaId: mangaId ?? this.mangaId,
      orderByChapterDesc: orderByChapterDesc ?? this.orderByChapterDesc,
      translatedLanguages: translatedLanguages ?? this.translatedLanguages,
      excludedGroups: excludedGroups ?? this.excludedGroups,
    );
  }

  MangaDexChapterQueryFilter copyWithSelf(MangaDexChapterQueryFilter other) {
    return MangaDexChapterQueryFilter(
      ids: other.ids ?? ids,
      includes: other.includes ?? includes,
      limit: other.limit,
      offset: other.offset,
      mangaId: other.mangaId ?? mangaId,
      orderByChapterDesc: other.orderByChapterDesc ?? orderByChapterDesc,
      translatedLanguages: other.translatedLanguages ?? translatedLanguages,
      excludedGroups: other.excludedGroups ?? excludedGroups,
    );
  }

  @override
  String toString() {
    return "MangaDexChapterQueryFilter(ids: $ids, includes: $includes, limit: $limit, offset: $offset, mangaId: $mangaId, orderByChapterDesc: $orderByChapterDesc, translatedLanguages: $translatedLanguages, excludedGroups: $excludedGroups)";
  }
}
