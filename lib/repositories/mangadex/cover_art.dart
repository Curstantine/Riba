// ignore_for_file: public_member_api_docs, sort_constructors_first

import "package:riba/repositories/local/cover_art.dart";
import "package:riba/repositories/local/localization.dart";
import "package:riba/repositories/mangadex/relationship.dart";

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
