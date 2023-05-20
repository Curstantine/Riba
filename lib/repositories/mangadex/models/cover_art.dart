import "package:json_annotation/json_annotation.dart";
import "package:riba/repositories/local/models/cover_art.dart";
import "package:riba/repositories/local/models/localization.dart";
import "package:riba/repositories/runtime/cover_art.dart";
import "package:riba/repositories/utils/exception.dart";

import "general.dart";
import "relationship.dart";
import "user.dart";

part "cover_art.g.dart";

typedef CoverArtEntity = MDEntityResponse<CoverArtAttributes>;
typedef CoverArtCollection = MDCollectionResponse<CoverArtAttributes>;

@JsonSerializable(createToJson: false)
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

  factory CoverArtAttributes.fromJson(Map<String, dynamic> json) =>
      _$CoverArtAttributesFromJson(json);
}

extension ToCoverArt on MDResponseData<CoverArtAttributes> {
  /// Converts self to a [CoverArt] object.
  ///
  /// Might throw a [LanguageNotSupportedException] if the locale is not supported.
  CoverArt asCoverArt(String mangaId, {bool inRelationship = false}) {
    final file = attributes.fileName.split(".");

    return CoverArt(
      id: id,
      volume: attributes.volume,
      fileId: file.first,
      fileType: ImageFileType.fromExtension(file.last),
      description: attributes.description,
      locale: attributes.locale == null ? null : Locale.fromJson(attributes.locale!),
      createdAt: attributes.createdAt,
      updatedAt: attributes.updatedAt,
      version: attributes.version,
      mangaId: mangaId,
      userId: inRelationship ? null : relationships.ofType(EntityType.user).first.id,
    );
  }

  /// Converts self to a [CoverArtData] object.
  ///
  /// Unlike [asCoverArt], this method requires [relationships] to be populated.
  ///
  /// Throws:
  ///   - [IncompleteDataException] if [relationships] are null.
  ///   - [LanguageNotSupportedException] if the locale is not supported.
  CoverArtData asCoverArtData() {
    return CoverArtData(
      cover: asCoverArt(relationships.ofType(EntityType.manga).first.id),
      user: relationships.ofType<UserAttributes>(EntityType.user).first.asUser(),
    );
  }
}

extension ToRelCoverArt on Relationship<CoverArtAttributes> {
  /// Converts self to a [CoverArt] object.
  ///
  /// [CoverArt.userId] will be null, as relationships are not populated.
  ///
  /// Throws:
  ///   - [IncompleteDataException] if [attributes] is null.
  ///   - [LanguageNotSupportedException] if the locale is not supported.
  CoverArt toCoverArt(String mangaId) {
    if (attributes == null) throw const IncompleteDataException("Attributes are null");

    final tempResp = MDResponseData<CoverArtAttributes>(
      id: id,
      type: type,
      attributes: attributes!,
      relationships: const [],
    );

    return tempResp.asCoverArt(mangaId, inRelationship: true);
  }
}
