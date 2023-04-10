import "package:json_annotation/json_annotation.dart";
import "package:riba/repositories/local/chapter.dart";
import "package:riba/repositories/local/localization.dart";
import "package:riba/repositories/mangadex/models/relationship.dart";
import "package:riba/repositories/runtime/chapter.dart";

import "general.dart";
import "group.dart";
import "user.dart";

part "chapter.g.dart";

typedef ChapterEntity = MDEntityResponse<ChapterAttributes>;
typedef ChapterCollection = MDCollectionResponse<ChapterAttributes>;

@JsonSerializable(createToJson: false)
class ChapterAttributes {
  final String? title;
  final String? volume;
  final String? chapter;
  final int pages;
  final String translatedLanguage;
  final String? externalUrl;
  final int version;

  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime publishAt;
  final DateTime readableAt;

  const ChapterAttributes({
    this.title,
    this.volume,
    this.chapter,
    required this.pages,
    required this.translatedLanguage,
    this.externalUrl,
    required this.version,
    required this.createdAt,
    required this.updatedAt,
    required this.publishAt,
    required this.readableAt,
  });

  factory ChapterAttributes.fromJson(Map<String, dynamic> json) =>
      _$ChapterAttributesFromJson(json);
}

extension ToChapter on MDResponseData<ChapterAttributes> {
  /// Converts the response data to a [Chapter] object.
  ///
  /// Will throw an [LanguageNotSupportedError] if the language is not supported.
  Chapter toChapter() {
    return Chapter(
      id: id,
      mangaId: relationships.ofType(EntityType.manga).first.id,
      uploaderId: relationships.ofType(EntityType.user).map((e) => e.id).first,
      groupIds: relationships.ofType(EntityType.scanlationGroup).map((e) => e.id).toList(),
      title: attributes.title,
      volume: attributes.volume,
      chapter: attributes.chapter,
      pages: attributes.pages,
      translatedLanguage: Language.fromIsoCode(attributes.translatedLanguage),
      externalUrl: attributes.externalUrl,
      createdAt: attributes.createdAt,
      updatedAt: attributes.updatedAt,
      publishAt: attributes.publishAt,
      readableAt: attributes.readableAt,
      version: attributes.version,
    );
  }

  /// Converts the response data to a [ChapterData] object.
  ///
  /// Will throw an [LanguageNotSupportedError] if the language is not supported.
  ChapterData toChapterData() {
    return ChapterData(
      chapter: toChapter(),
      uploader: relationships.ofType<UserAttributes>(EntityType.user).first.asUser(),
      groups: relationships
          .ofType<GroupAttributes>(EntityType.scanlationGroup)
          .map((e) => e.toGroup())
          .toList(),
    );
  }
}
