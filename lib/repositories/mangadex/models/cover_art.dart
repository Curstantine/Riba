import "package:logging/logging.dart";
import "package:riba/repositories/local/cover_art.dart";
import "package:riba/repositories/local/localization.dart";
import "package:riba/repositories/runtime/cover_art.dart";
import "package:riba/repositories/utils/exception.dart";

import "general.dart";
import "relationship.dart";
import "user.dart";

typedef CoverArtCollection = MDCollectionResponse<CoverArtAttributes>;

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
  CoverArt? toCoverArt(String mangaId, {required Logger logger}) {
    final file = attributes.fileName.split(".");
    Locale? locale;

    if (attributes.locale != null) {
      try {
        locale = Locale.fromJsonValue(attributes.locale!);
      } on LanguageNotSupportedException {
        logger.warning("${attributes.locale} of $mangaId is not supported, returning null.");
        return null;
      }
    }

    return CoverArt(
      id: id,
      volume: attributes.volume,
      fileId: file.first,
      fileType: ImageFileType.fromExtension(file.last),
      description: attributes.description,
      locale: locale,
      createdAt: attributes.createdAt,
      updatedAt: attributes.updatedAt,
      version: attributes.version,
      mangaId: mangaId,
      userId: relationships.ofType(EntityType.user).first.id,
    );
  }

  CoverArtData? toCoverArtData({required Logger logger}) {
    final cover = toCoverArt(relationships.ofType(EntityType.manga).first.id, logger: logger);
    if (cover == null) return null;

    return CoverArtData(
      cover: cover,
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
      mangaId: mangaId,
    );
  }
}
