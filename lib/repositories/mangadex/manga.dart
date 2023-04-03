import "dart:convert";
import "dart:developer";

import "package:http/http.dart";
import "package:isar/isar.dart";
import "package:logging/logging.dart";
import "package:riba/repositories/utils/enumerate.dart";
import "package:riba/repositories/local/author.dart";
import "package:riba/repositories/local/cover_art.dart";
import "package:riba/repositories/local/manga.dart";
import "package:riba/repositories/local/statistics.dart";
import "package:riba/repositories/local/tag.dart";
import "package:riba/repositories/utils/rate_limiter.dart";
import "package:riba/repositories/runtime/manga.dart";
import "package:riba/utils/hash.dart";

import "../mangadex.dart";

class MDMangaRepo {
  final Client client;
  final RateLimiter rateLimiter;
  final Isar database;
  final logger = Logger("MDMangaRepo");

  MDMangaRepo(this.client, this.rateLimiter, this.database) {
    rateLimiter.rates["/manga:GET"] = const Rate(4, Duration(seconds: 1));
    rateLimiter.rates["/statistics/manga:GET"] = const Rate(4, Duration(seconds: 1));
  }

  final url = MangaDex.url.copyWith(pathSegments: ["manga"]);
  final statisticUrl = MangaDex.url.copyWith(pathSegments: ["statistics", "manga"]);

  final includes = [
    EntityType.artist.toJsonValue(),
    EntityType.author.toJsonValue(),
    EntityType.coverArt.toJsonValue(),
  ];

  Future<MangaData> get(String id, {bool checkDB = true}) async {
    logger.info("get($id, $checkDB)");

    if (checkDB) {
      final inDB = await database.manga.get(fastHash(id));
      if (inDB != null) return _collectMeta(inDB);
    }

    await rateLimiter.wait("/manga:GET");
    final reqUrl = url.copy().addPathSegment(id).setParameter("includes[]", includes);
    final request = await client.get(reqUrl.toUri());

    final response = MDMangaEntity.fromMap(jsonDecode(request.body), url: reqUrl);
    final internalMangaData = response.data.toInternalMangaData();
    _insertMeta(internalMangaData);

    return internalMangaData.toMangaData();
  }

  /// Get multiple manga at once.
  Future<Map<String, MangaData>> getMany(List<String> ids, {bool checkDB = true}) async {
    logger.info("getMany($ids, $checkDB)");

    final Map<String, MangaData?> mapped = {for (final e in ids) e: null};

    if (checkDB) {
      final inDB = await database.manga.getAll(ids.map((e) => fastHash(e)).toList());
      for (final manga in inDB) {
        if (manga == null) continue;
        mapped[manga.id] = await _collectMeta(manga);
      }
    }

    final missing = mapped.entries.where((e) => e.value == null).map((e) => e.key).toList();
    if (missing.isEmpty) return mapped.cast();

    final block = Enumerate<String, MangaData>(
      perStep: 100,
      items: missing,
      onStep: (resolved) async {
        await rateLimiter.wait("/manga:GET");
        final reqUrl = url
            .copy()
            .setParameter("ids[]", resolved.keys.toList())
            .setParameter("includes[]", includes)
            .setParameter("limit", 100);
        final request = await client.get(reqUrl.toUri());
        final response = MDMangaCollection.fromMap(jsonDecode(request.body), url: reqUrl);

        for (final data in response.data) {
          final internalMangaData = data.toInternalMangaData();
          _insertMeta(internalMangaData);
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

  Future<void> _insertMeta(InternalMangaData internalMangaData) async {
    await database.writeTxn(() async {
      await Future.wait([
        database.authors.putAll(internalMangaData.authors + internalMangaData.artists),
        database.covers.putAll(internalMangaData.covers),
        database.tags.putAll(internalMangaData.tags),
        database.manga.put(internalMangaData.manga),
      ]);
    });
  }

  Future<MangaData> _collectMeta(Manga manga) async {
    final data = await Future.wait([
      database.authors.getAll(manga.artistIds.map((e) => fastHash(e)).toList()),
      database.authors.getAll(manga.authorIds.map((e) => fastHash(e)).toList()),
      database.tags.getAll(manga.tagsIds.map((e) => fastHash(e)).toList()),
      manga.usedCoverId != null
          ? database.covers.get(fastHash(manga.usedCoverId!))
          : Future.value(null),
    ]);

    return MangaData(
      manga: manga,
      authors: (data[0] as List<Author?>).cast(),
      artists: (data[1] as List<Author?>).cast(),
      tags: (data[2] as List<Tag?>).cast(),
      cover: data[3] as CoverArt?,
    );
  }

  Future<Statistics> getStatistics(String id, {bool checkDB = true}) async {
    log("getStatistics($id)", name: "MDMangaRepo");

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
}
