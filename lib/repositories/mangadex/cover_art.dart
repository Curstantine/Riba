// ignore_for_file: public_member_api_docs, sort_constructors_first
import "dart:convert";
import "dart:io";

import "package:isar/isar.dart";
import "package:logging/logging.dart";
import "package:riba/repositories/local/cover_art.dart";
import "package:riba/repositories/local/localization.dart";
import "package:riba/repositories/local/user.dart";
import "package:riba/repositories/mangadex.dart";
import "package:riba/repositories/mangadex/models/cover_art.dart";
import "package:riba/repositories/mangadex/models/error.dart";
import "package:riba/repositories/mangadex/models/general.dart";
import "package:riba/repositories/mangadex/utils/service.dart";
import "package:riba/repositories/runtime/cover_art.dart";
import "package:riba/repositories/utils/enumerate.dart";
import "package:riba/repositories/utils/exception.dart";
import "package:riba/repositories/utils/rate_limiter.dart";
import "package:riba/repositories/utils/url.dart";
import "package:riba/utils/hash.dart";

class MangaDexCoverService extends MangaDexService<CoverArtAttributes, CoverArt, CoverArtData,
    CoverArtData, MangaDexCoverQueryFilter> {
  MangaDexCoverService({
    required super.client,
    required super.rateLimiter,
    required super.database,
    required super.rootUrl,
    required super.cache,
  }) : assert(cache != null, "Cache directory must be set for the cover art service.");

  @override
  final logger = Logger("MangaDexCoverService");

  @override
  final rates = {
    "/cover:GET": const Rate(4, Duration(seconds: 1)),
    "/cover/image:GET": const Rate(4, Duration(seconds: 1)),
  };

  @override
  late final baseUrl = rootUrl.copyWith(pathSegments: ["cover"]);
  final cdnUrl = URL(hostname: "uploads.mangadex.org", pathSegments: ["covers"]);

  late Directory persistentCoverDir = Directory("${cache!.path}/persistent");
  late Directory temporaryCoverDir = Directory("${cache!.path}/temporary");

  @override
  final defaultFilters = MangaDexCoverQueryFilter(
    includes: [
      EntityType.user,
    ],
    orderByVolumeDesc: true,
    limit: 100,
  );

  @override
  MangaDexCoverService get instance => MangaDex.instance.cover;

  @override
  @Deprecated("Will not be implemented, used as a stub for the interface.")
  Future<CoverArtData> get(String id, {bool checkDB = true}) {
    throw UnimplementedError();
  }

  @override
  Future<Map<String, CoverArtData>> getMany({
    required MangaDexCoverQueryFilter overrides,
    bool checkDB = true,
  }) async {
    logger.info("getMany($overrides, $checkDB)");

    final ids = overrides.ids ?? [];
    final filters = defaultFilters.copyWith(overrides);
    final Map<String, CoverArtData?> mapped = {for (final e in ids) e: null};

    if (checkDB && filters.ids != null) {
      final inDB = await database.covers.getAll(ids.map((e) => fastHash(e)).toList());

      for (final cover in inDB) {
        if (cover == null) continue;
        mapped[cover.id] = await collectMeta(cover);
      }
    }

    if (checkDB && filters.mangaId != null) {
      final statement = database.covers
          .where()
          .mangaIdEqualTo(filters.mangaId!)
          .filter()
          .locale((q) => q.anyOf(filters.locales ?? <Locale>[], (q, e) => q.codeEqualTo(e.code)));

      final inDB = filters.orderByVolumeDesc == false
          ? await statement.findAll()
          : await statement.sortByVolumeDesc().findAll();

      for (final cover in inDB) {
        mapped[cover.id] = await collectMeta(cover);
      }
    }

    final missing = mapped.entries.where((e) => e.value == null).map((e) => e.key).toList();
    if (missing.isEmpty && mapped.isNotEmpty) return mapped.cast();

    final block = Enumerate<String, CoverArtData>(
      perStep: filters.limit ?? 100,
      items: missing,
      onStep: (resolved) async {
        await rateLimiter.wait("/cover:GET");

        final reqUrl = filters.addFiltersToUrl(baseUrl.copy());
        final request = await client.get(reqUrl.toUri());
        final response = CoverArtCollection.fromMap(jsonDecode(request.body), url: reqUrl);

        for (final data in response.data) {
          try {
            final cover = data.asCoverArtData();
            insertMeta(cover);
            resolved[data.id] = cover;
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

  @override
  Future<void> insertMeta(CoverArtData data) async {
    await database.writeTxn(() async {
      await Future.wait([
        database.covers.put(data.cover),
        if (data.user != null) database.users.put(data.user!),
      ]);
    });
  }

  @override
  Future<CoverArtData> collectMeta(CoverArt single) async {
    final user = single.userId != null ? await database.users.get(fastHash(single.userId!)) : null;
    return CoverArtData(cover: single, user: user);
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

  /// Deletes the [persistentCoverDir] directory that contains all the persistent cover art files.
  Future<void> deleteAllPersistent() async {
    if (await persistentCoverDir.exists()) await persistentCoverDir.delete(recursive: true);
  }

  /// Deletes the [temporaryCoverDir] directory that contains all the temporary cover art files.
  Future<void> deleteAllTemp() async {
    if (await temporaryCoverDir.exists()) await temporaryCoverDir.delete(recursive: true);
  }
}

class MangaDexCoverQueryFilter extends MangaDexQueryFilter {
  final List<String>? ids;
  final List<EntityType>? includes;
  final int? limit;

  /// I don't want to do list filtering though the api supports it.
  final String? mangaId;
  final List<Locale>? locales;
  final bool? orderByVolumeDesc;

  MangaDexCoverQueryFilter({
    this.ids,
    this.includes,
    this.limit,
    this.mangaId,
    this.locales,
    this.orderByVolumeDesc,
  })  : assert(
            (ids == null && mangaId != null) || (ids != null && mangaId == null),
            "Either mangaId or ids must be specified."
            "And only one of them at a time."),
        assert(ids != null && orderByVolumeDesc != null,
            "orderByVolumeDesc should not be specified when ids are populated.");

  @override
  URL addFiltersToUrl(URL url) {
    if (mangaId != null) {
      url.setParameter("manga[]", mangaId!);
    }

    if (locales != null) {
      url.setParameter("locales[]", locales!.map((e) => e.code).toList());
    }

    if (orderByVolumeDesc != null && orderByVolumeDesc!) {
      url.setParameter("order[volume]", "desc");
    }

    final generic = MangaDexGenericQueryFilter(
      ids: ids,
      includes: includes,
      limit: limit,
    );

    return generic.addFiltersToUrl(url);
  }

  MangaDexCoverQueryFilter copyWith(MangaDexCoverQueryFilter other) {
    return MangaDexCoverQueryFilter(
      ids: other.ids ?? ids,
      includes: other.includes ?? includes,
      limit: other.limit ?? limit,
      mangaId: other.mangaId ?? mangaId,
      locales: other.locales ?? locales,
      orderByVolumeDesc: other.orderByVolumeDesc ?? orderByVolumeDesc,
    );
  }

  @override
  String toString() {
    return "MangaDexCoverQueryFilter(ids: $ids, includes: $includes, limit: $limit,"
        " mangaId: $mangaId, locales: $locales, orderByVolumeDesc: $orderByVolumeDesc)";
  }
}
