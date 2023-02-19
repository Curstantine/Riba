import "dart:convert";
import "dart:developer";
import "dart:io";

import "package:http/http.dart";
import "package:isar/isar.dart";
import "package:riba/repositories/local/cover_art.dart";
import "package:riba/repositories/local/localization.dart";
import "package:riba/repositories/local/user.dart";
import "package:riba/repositories/mangadex/general.dart";
import "package:riba/repositories/mangadex/user.dart";
import "package:riba/repositories/rate_limiter.dart";
import "package:riba/repositories/runtime/cover_art.dart";
import "package:riba/repositories/url.dart";
import "package:riba/utils/hash.dart";

import "error.dart";
import "mangadex.dart";
import "relationship.dart";

typedef MDCoverArtEntity = MDEntityResponse<CoverArtAttributes>;
typedef MDCoverArtCollection = MDCollectionResponse<CoverArtAttributes>;

class MDCoverArtRepo {
  final Client client;
  final RateLimiter rateLimiter;
  final Isar database;
  final Directory directory;

  MDCoverArtRepo(this.client, this.rateLimiter, this.database, this.directory) {
    rateLimiter.rates["/covers:GET"] = const Rate(4, Duration(seconds: 1));
    rateLimiter.rates["/covers/image:GET"] = const Rate(2, Duration(seconds: 1));
  }

  final url = MangaDex.url.copyWith(pathSegments: ["cover"]);
  final cdnUrl = URL(hostname: "uploads.mangadex.org", pathSegments: ["covers"]);
  final includes = [
    EntityType.user.toJsonValue(),
  ];

  Future<CoverArtData> get(String id) async {
    log("get($id)", name: "MDCoverArtRepo");

    final inDB = await database.covers.get(fastHash(id));
    if (inDB != null) return _collectMeta(inDB);

    await rateLimiter.wait("/covers:GET");
    final reqUrl = url.copy().addPathSegment(id).setParameter("includes[]", includes);
    final request = await client.get(reqUrl.toUri());

    final response = MDCoverArtEntity.fromMap(jsonDecode(request.body), url: reqUrl);
    final coverArtData = response.data.toCoverArtData();

    await _insertMeta(coverArtData);
    return coverArtData;
  }

  Future<Map<String, CoverArtData>> getMany(List<String> ids) async {
    log("getMany($ids)", name: "MDMangaRepo");

    final Map<String, CoverArtData?> mapped = {for (var e in ids) e: null};
    final inDB = await database.covers.getAll(ids.map((e) => fastHash(e)).toList());
    for (final cover in inDB) {
      if (cover == null) continue;
      mapped[cover.id] = await _collectMeta(cover);
    }

    final missing = mapped.entries.where((e) => e.value == null).map((e) => e.key).toList();
    if (missing.isEmpty) return mapped.cast();

    // To go around the 100 limit, we split the request into multiple ones.
    while (missing.isNotEmpty) {
      await rateLimiter.wait("/covers:GET");
      final reqUrl = url
          .copy()
          .setParameter("ids[]", missing.take(100).toList())
          .setParameter("includes[]", includes)
          .setParameter("limit", 100);
      final request = await client.get(reqUrl.toUri());

      final response = MDCoverArtCollection.fromMap(jsonDecode(request.body), url: reqUrl);
      for (final data in response.data) {
        final coverArtData = data.toCoverArtData();
        await _insertMeta(coverArtData);
        mapped[data.id] = coverArtData;
      }

      missing.removeWhere((e) => mapped[e] != null);
    }

    return mapped.cast();
  }

  Future<void> _insertMeta(CoverArtData coverData) async {
    await database.writeTxn(() async {
      await Future.wait([
        database.covers.put(coverData.cover),
        if (coverData.user != null) database.users.put(coverData.user!),
      ]);
    });
  }

  Future<CoverArtData> _collectMeta(CoverArt coverArt) async {
    final user = coverArt.user != null ? await database.users.get(fastHash(coverArt.user!)) : null;
    return CoverArtData(cover: coverArt, user: user);
  }

  Future<File> getImage(
    String mangaId,
    CoverArt coverArt, {
    CoverSize size = CoverSize.original,
  }) async {
    log("getImage($mangaId, ${coverArt.id}, $size)", name: "MDCoverArtRepo");

    final file = getFile(mangaId, coverArt.fileId, coverArt.fileType, size);
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

  /// Returns the file for the given [mangaId], [fileId], [type] and [size].
  ///
  /// This method does not check whether the file exists or not.
  ///
  /// If [size] is anything other than [CoverSize.original], the file type will
  /// always be [ImageFileType.jpeg]. Check [getFileName] for more info.
  File getFile(String mangaId, String fileId, ImageFileType type, CoverSize size) =>
      File("${directory.path}/$mangaId/${getFileName(fileId, size, type)}");

  Future<void> delete(String mangaId, CoverArt coverArt, CoverSize size) async {
    final file = getFile(mangaId, coverArt.fileId, coverArt.fileType, size);
    if (await file.exists()) await file.delete();
  }

  Future<void> deleteAll() async {
    if (await directory.exists()) await directory.delete(recursive: true);
  }
}

class CoverArtAttributes {
  final String? volume;
  final String fileName;
  final String? description;
  final String? locale;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int version;

  const CoverArtAttributes({
    required this.volume,
    required this.fileName,
    required this.description,
    required this.locale,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
  });

  factory CoverArtAttributes.fromMap(Map<String, dynamic> map) {
    return CoverArtAttributes(
      volume: map["volume"] as String?,
      fileName: map["fileName"] as String,
      description: map["description"] as String?,
      locale: map["locale"] as String?,
      createdAt: DateTime.parse(map["createdAt"] as String),
      updatedAt: DateTime.parse(map["updatedAt"] as String),
      version: map["version"] as int,
    );
  }
}

extension ToCoverArt on MDResponseData<CoverArtAttributes> {
  CoverArt toCoverArt(String mangaId) {
    final file = attributes.fileName.split(".");

    return CoverArt(
      id: id,
      volume: attributes.volume,
      fileId: file.first,
      fileType: ImageFileType.fromExtension(file.last),
      description: attributes.description,
      locale: attributes.locale != null ? Locale.fromJsonValue(attributes.locale!) : null,
      createdAt: attributes.createdAt,
      updatedAt: attributes.updatedAt,
      version: attributes.version,
      manga: mangaId,
      user: relationships.ofType(EntityType.user).first.id,
    );
  }

  CoverArtData toCoverArtData() {
    return CoverArtData(
      cover: toCoverArt(relationships.ofType(EntityType.manga).first.id),
      user: relationships.ofType<UserAttributes>(EntityType.user).first.toUser(),
    );
  }
}

extension ToRelCoverArt on Relationship<CoverArtAttributes> {
  CoverArt toCoverArt(String mangaId) {
    if (attributes == null) throw Exception("Attributes are null");
    final file = attributes!.fileName.split(".");

    return CoverArt(
      id: id,
      volume: attributes!.volume,
      fileId: file.first,
      fileType: ImageFileType.fromExtension(file.last),
      description: attributes!.description,
      locale: attributes!.locale != null ? Locale.fromJsonValue(attributes!.locale!) : null,
      createdAt: attributes!.createdAt,
      updatedAt: attributes!.updatedAt,
      version: attributes!.version,
      manga: mangaId,
    );
  }
}
