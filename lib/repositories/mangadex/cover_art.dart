import "dart:io";

import "package:http/http.dart";
import "package:isar/isar.dart";
import "package:riba/repositories/local/cover_art.dart";
import "package:riba/repositories/local/localization.dart";
import "package:riba/repositories/mangadex/error.dart";
import "package:riba/repositories/mangadex/relationship.dart";
import "package:riba/repositories/rate_limiter.dart";
import "package:riba/repositories/url.dart";

class MDCoverArtRepo {
  final Client client;
  final RateLimiter rateLimiter;
  final Isar database;
  final Directory directory;

  MDCoverArtRepo(this.client, this.rateLimiter, this.database, this.directory) {
    rateLimiter.rates["/covers:GET"] = const Rate(4, Duration(seconds: 1));
  }

  final url = URL(hostname: "uploads.mangadex.org", pathSegments: ["covers"]);

  Future<File> getCoverArt(
    String mangaId,
    String filename, {
    CoverSize size = CoverSize.original,
  }) async {
    final file = getFile(mangaId, filename, size);
    if (file.existsSync()) return file;

    await rateLimiter.wait("/covers:GET");
    final reqUrl = url.asRef().addPathSegments([mangaId, getFileName(filename, size)]);
    final response = await client.get(reqUrl.toUri());

    if (response.statusCode != 200) {
      throw MDException(
        MDError(status: response.statusCode, title: "Failed to retrieve the cover art"),
        url: reqUrl,
      );
    }

    await file.create(recursive: true);
    await file.writeAsBytes(response.bodyBytes);
    return file;
  }

  String getFileName(String fileName, CoverSize size) {
    final sizeSuffix = size.size == null ? "" : ".${size.size}.jpg";
    return "$fileName$sizeSuffix";
  }

  File getFile(String mangaId, String filename, [CoverSize size = CoverSize.original]) {
    return File("${directory.path}/$mangaId/${getFileName(filename, size)}");
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

extension ToRelCoverArt on Relationship<CoverArtAttributes> {
  CoverArt toCoverArt() {
    if (attributes == null) throw Exception("Attributes are null");

    return CoverArt(
      id: id,
      volume: attributes!.volume,
      fileName: attributes!.fileName,
      description: attributes!.description,
      locale: attributes!.locale != null ? Locale.fromJsonValue(attributes!.locale!) : null,
      createdAt: attributes!.createdAt,
      updatedAt: attributes!.updatedAt,
      version: attributes!.version,
    );
  }
}

enum CoverSize {
  original(null),
  medium(512),
  small(256);

  final int? size;
  const CoverSize(this.size);
}
