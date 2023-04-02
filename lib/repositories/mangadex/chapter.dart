import "dart:convert";

import "package:http/http.dart";
import "package:isar/isar.dart";
import "package:logging/logging.dart";
import "package:riba/repositories/local/chapter.dart";
import "package:riba/repositories/local/group.dart";
import "package:riba/repositories/local/localization.dart";
import "package:riba/repositories/local/user.dart";
import "package:riba/repositories/mangadex/models/general.dart";
import "package:riba/repositories/runtime/chapter.dart";
import "package:riba/repositories/utils/enumerate.dart";
import "package:riba/repositories/utils/exception.dart";
import "package:riba/repositories/utils/rate_limiter.dart";
import "package:riba/utils/hash.dart";

class MDChapterRepo {
  final Client client;
  final RateLimiter rateLimiter;
  final Isar database;
  final logger = Logger("MDChapterRepo");

  MDChapterRepo(this.client, this.rateLimiter, this.database) {
    rateLimiter.rates["/chapter:GET"] = const Rate(4, Duration(seconds: 1));
  }

  final url = MangaDex.url.copyWith(pathSegments: ["chapter"]);
  final mangaUrl = MangaDex.url.copyWith(pathSegments: ["manga"]);

  final includes = [
    EntityType.user.toJsonValue(),
    EntityType.scanlationGroup.toJsonValue(),
  ];

  Future<Map<String, ChapterData>> getMany(List<String> ids, {bool checkDB = true}) async {
    logger.info("getMany($ids, $checkDB)");

    final Map<String, ChapterData?> mapped = {for (var e in ids) e: null};

    if (checkDB) {
      final inDB = await database.chapters.getAll(ids.map((e) => fastHash(e)).toList());
      for (final chapter in inDB) {
        if (chapter == null) continue;
        mapped[chapter.id] = await _collectMeta(chapter);
      }
    }

    final missing = mapped.entries.where((e) => e.value == null).map((e) => e.key).toList();
    if (missing.isEmpty) return mapped.cast();

    final block = Enumerate<String, ChapterData>(
      perStep: 100,
      items: missing,
      onStep: (resolved) async {
        await rateLimiter.wait("/chapter:GET");
        final reqUrl = url
            .copy()
            .setParameter("ids[]", resolved.keys.toList())
            .setParameter("includes[]", includes)
            .setParameter("limit", 100);
        final request = await client.get(reqUrl.toUri());
        final response = MDChapterCollection.fromMap(jsonDecode(request.body), url: reqUrl);

        for (final data in response.data) {
          try {
            final chapter = data.toChapterData();
            _insertMeta(chapter);
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

  Future<List<ChapterData>> getFeed(
    String id, {
    bool checkDB = true,
    List<Locale> langs = const [],
    List<String> excludedGroups = const [],
  }) async {
    logger.info("getFeed($id, $checkDB)");

    if (checkDB) {
      final inDB = await database.chapters
          .filter()
          .mangaIdEqualTo(id)
          .translatedLanguage((q) => q.anyOf(langs, (q, e) => q.codeEqualTo(e.code)))
          .group((q) => q.anyOf(excludedGroups, (q, e) => q.not().groupIdsElementContains(e)))
          .findAll();
      inDB.sortAsDescending();

      if (inDB.isNotEmpty) {
        final chapterFuture = <Future<ChapterData>>[];
        for (final chapter in inDB) {
          chapterFuture.add(_collectMeta(chapter));
        }

        return await Future.wait(chapterFuture);
      }
    }

    await rateLimiter.wait("/manga:GET");
    final reqUrl = mangaUrl
        .copy()
        .addPathSegment(id)
        .addPathSegment("feed")
        .setParameter("order[chapter]", "desc")
        .setParameter("translatedLanguage[]", langs.map((e) => e.code).toList())
        .setParameter("excludedGroups[]", excludedGroups)
        .setParameter("includes[]", includes);
    final request = await client.get(reqUrl.toUri());
    final response = MDChapterCollection.fromMap(jsonDecode(request.body), url: reqUrl);

    final chapters = <ChapterData>[];
    for (final data in response.data) {
      try {
        final chapterData = data.toChapterData();
        _insertMeta(chapterData);
        chapters.add(chapterData);
      } on LanguageNotSupportedException catch (e) {
        logger.warning(e.toString());
      }
    }

    return chapters;
  }

  Future<void> _insertMeta(ChapterData chapterData) async {
    await database.writeTxn(() async {
      await Future.wait([
        database.chapters.put(chapterData.chapter),
        database.groups.putAll(chapterData.groups),
        database.users.put(chapterData.uploader),
      ]);
    });
  }

  Future<ChapterData> _collectMeta(Chapter chapter) async {
    final data = await Future.wait([
      database.groups.getAll(chapter.groupIds.map((e) => fastHash(e)).toList()),
      database.users.get(fastHash(chapter.uploaderId)),
    ]);

    return ChapterData(
      chapter: chapter,
      groups: (data[0] as List<Group?>).cast(),
      uploader: data[1] as User,
    );
  }
}
