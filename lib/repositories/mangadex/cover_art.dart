import "dart:convert";
import "dart:io";

import "package:http/http.dart";
import "package:isar/isar.dart";
import "package:logging/logging.dart";
import "package:riba/repositories/local/cover_art.dart";
import "package:riba/repositories/local/user.dart";
import "package:riba/repositories/mangadex.dart";
import "package:riba/repositories/mangadex/models/error.dart";
import "package:riba/repositories/mangadex/models/general.dart";
import "package:riba/repositories/runtime/cover_art.dart";
import "package:riba/repositories/utils/enumerate.dart";
import "package:riba/repositories/utils/exception.dart";
import "package:riba/repositories/utils/rate_limiter.dart";
import "package:riba/repositories/utils/url.dart";
import "package:riba/utils/hash.dart";

/// Handles retrieving cover art data and images from MangaDex.
///
/// This derives two types of base directories based on their persistence relative to the passed [root] directory.
///
/// - [persistentCoverDir]
///   - is the directory where all cover arts are stored when [cache] is true.
///   - cleared when [deleteAll] is called.
///
/// - [temporaryCoverDir]
///   - is the directory where all cover arts are stored when [cache] is false.
///   - cleared when [deleteAllTemp] is called, which is called on initialization of this class.
///
/// [getFile] will resolve the correct directory based on the passed [persistent] parameter.
class MDCoverArtRepo {
  final Client client;
  final RateLimiter rateLimiter;
  final Isar database;
  final Directory root;
  final logger = Logger("MDCoverArtRepo");

  MDCoverArtRepo._internal(this.client, this.rateLimiter, this.database, this.root) {
    rateLimiter.rates["/covers:GET"] = const Rate(4, Duration(seconds: 1));
    rateLimiter.rates["/covers/image:GET"] = const Rate(2, Duration(seconds: 1));
  }

  static Future<MDCoverArtRepo> init({
    required Client client,
    required RateLimiter rateLimiter,
    required Isar database,
    required Directory root,
  }) async {
    final instance = MDCoverArtRepo._internal(client, rateLimiter, database, root);
    await instance.deleteAllTemp();
    return instance;
  }

  final url = MangaDex.url.copyWith(pathSegments: ["cover"]);
  final cdnUrl = URL(hostname: "uploads.mangadex.org", pathSegments: ["covers"]);
  final includes = [
    EntityType.user.toJsonValue(),
  ];

  late Directory persistentCoverDir = Directory("${root.path}/persistent");
  late Directory temporaryCoverDir = Directory("${root.path}/temporary");

  Future<Map<String, CoverArtData>> getMany(List<String> ids, {bool checkDb = true}) async {
    logger.info("getMany($ids, $checkDb)");

    final Map<String, CoverArtData?> mapped = {for (var e in ids) e: null};

    if (checkDb) {
      final inDB = await database.covers.getAll(ids.map((e) => fastHash(e)).toList());
      for (final cover in inDB) {
        if (cover == null) continue;
        mapped[cover.id] = await _collectMeta(cover);
      }
    }

    final missing = mapped.entries.where((e) => e.value == null).map((e) => e.key).toList();
    if (missing.isEmpty) return mapped.cast();

    final block = Enumerate<String, CoverArtData>(
      perStep: 100,
      items: missing,
      onStep: (resolved) async {
        await rateLimiter.wait("/covers:GET");
        final reqUrl = url
            .copy()
            .setParameter("ids[]", resolved.keys.toList())
            .setParameter("includes[]", includes)
            .setParameter("limit", 100);
        final request = await client.get(reqUrl.toUri());
        final response = MDCoverArtCollection.fromMap(jsonDecode(request.body), url: reqUrl);

        for (final data in response.data) {
          final coverArtData = data.toCoverArtData();
          if (coverArtData == null) continue;

          _insertMeta(coverArtData);
          resolved[data.id] = coverArtData;
        }
      },
      onMismatch: (missedIds) {
        logger.warning("Some entries were not in the response, ignoring them: $missedIds");
      },
    );

    mapped.addAll(await block.run());
    return mapped.cast();
  }

  Future<List<CoverArtData>> getForManga(String id) async {
    logger.info("getForManga($id)");

    await rateLimiter.wait("/covers:GET");
    final reqUrl = url
        .copy()
        .setParameter("manga[]", id)
        .setParameter("includes[]", includes)
        .setParameter("order[volume]", "desc")
        .setParameter("limit", 100);
    final request = await client.get(reqUrl.toUri());

    final response = MDCoverArtCollection.fromMap(jsonDecode(request.body), url: reqUrl);
    final coverArtData =
        response.data.map((e) => e.toCoverArtData()).whereType<CoverArtData>().toList();

    _insertManyMeta(coverArtData);
    return coverArtData;
  }

  Future<void> _insertMeta(CoverArtData coverData) async {
    await database.writeTxn(() async {
      await Future.wait([
        database.covers.put(coverData.cover),
        if (coverData.user != null) database.users.put(coverData.user!),
      ]);
    });
  }

  Future<void> _insertManyMeta(List<CoverArtData> coverData) async {
    await database.writeTxn(() async {
      await Future.wait([
        database.covers.putAll(coverData.map((e) => e.cover).toList()),
        database.users.putAll(coverData.map((e) => e.user).whereType<User>().toList()),
      ]);
    });
  }

  Future<CoverArtData> _collectMeta(CoverArt coverArt) async {
    final user =
        coverArt.userId != null ? await database.users.get(fastHash(coverArt.userId!)) : null;
    return CoverArtData(cover: coverArt, user: user);
  }

  /// Downloads a cover art based on the passed [mangaId], [coverArt] and [size].
  ///
  /// When [cache] is true, the cover art will be stored in [persistentCoverDir],
  /// else the cover art will be stored in [temporaryCoverDir].
  ///
  /// Returns the handle to the downloaded cover art.
  Future<File> getImage(
    String mangaId,
    CoverArt coverArt, {
    CoverSize size = CoverSize.original,
    bool cache = true,
  }) async {
    logger.info("getImage($mangaId, ${coverArt.id}, $size, $cache)");

    final file = getFile(mangaId, coverArt.fileId, coverArt.fileType, size, cache);
    if (await file.exists()) return file;

    await rateLimiter.wait("/covers/image:GET");
    final fileName = getFileName(coverArt.fileId, size, coverArt.fileType);
    final reqUrl = cdnUrl.copy().addPathSegments([mangaId, fileName]);

    final response = await client.get(reqUrl.toUri());
    final contentType = response.headers["content-type"];

    if (response.statusCode != 200 || contentType == null) {
      throw MDException(
        MDError(status: response.statusCode, title: "Failed to retrieve the cover art"),
        url: reqUrl,
      );
    }

    await file.create(recursive: true);
    return await file.writeAsBytes(response.bodyBytes);
  }

  /// Returns the local file name for the given [fileId], [type] and [size].
  ///
  /// If [size] is anything other than [CoverSize.original], the file type will
  /// always be [ImageFileType.jpeg]. Reason being that the server only serves
  /// JPEG images for smaller sizes.
  ///
  /// e.g.:
  /// ```
  ///   CoverSize.original, ImageFileType.png -> "filename.png"
  ///   CoverSize.medium, ImageFileType.png -> "filename.png.256.jpg"
  ///   CoverSize.small, ImageFileType.png -> "filename.png.256.jpg"
  /// ```
  ///
  /// ### How and why does this differ from the usual way?
  ///
  /// Since we need to store the file type in the database,
  /// we derive the `fileName` (e.g. `be86d5f4-8bbf-43eb-9d7b-bce8a2f09926.jpg`) into two parts:
  /// 1. `fileId`
  /// 2. `fileType`
  ///
  /// Which we then append together to get both local and server file names.
  String getFileName(String fileId, CoverSize size, ImageFileType type) {
    final sizeSuffix = size.size != null ? ".${size.size}" : "";
    final typeSuffix = size.size != null ? ".jpg" : "";

    return "$fileId.${type.extension}$sizeSuffix$typeSuffix";
  }

  /// Returns the file for the given [mangaId], [fileId], [type], [size] and persistence type.
  ///
  /// This method does not check whether the file exists or not.
  ///
  /// If [size] is anything other than [CoverSize.original], the file type will
  /// always be [ImageFileType.jpeg]. Check [getFileName] for more info.
  File getFile(String mangaId, String fileId, ImageFileType type, CoverSize size, bool persist) {
    final name = getFileName(fileId, size, type);
    final base = persist ? persistentCoverDir : temporaryCoverDir;

    return File("${base.path}/$mangaId/$name");
  }

  /// Deletes the [root] directory that contains all the cover art files.
  Future<void> deleteAll() async {
    if (await root.exists()) await root.delete(recursive: true);
  }

  /// Deletes the [persistentCoverDir] directory that contains all the temporary cover art files.
  Future<void> deleteAllTemp() async {
    if (await temporaryCoverDir.exists()) await temporaryCoverDir.delete(recursive: true);
  }
}
