import "dart:convert";

import "package:riba/repositories/local/chapter.dart";
import "package:riba/repositories/local/localization.dart";
import "package:riba/repositories/mangadex/models/relationship.dart";
import "package:riba/repositories/runtime/chapter.dart";

import "general.dart";
import "group.dart";
import "user.dart";

typedef ChapterEntity = MDEntityResponse<ChapterAttributes>;
typedef ChapterCollection = MDCollectionResponse<ChapterAttributes>;

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

  factory ChapterAttributes.fromMap(Map<String, dynamic> map) {
    final title = map["title"] as String?;
    final volume = map["volume"] as String?;
    final chapter = map["chapter"] as String?;

    return ChapterAttributes(
      title: title?.isNotEmpty == true ? title : null,
      volume: volume?.isNotEmpty == true ? volume : null,
      chapter: chapter,
      pages: map["pages"] as int,
      translatedLanguage: map["translatedLanguage"] as String,
      externalUrl: map["externalUrl"] as String?,
      version: map["version"] as int,
      createdAt: DateTime.parse(map["createdAt"] as String),
      updatedAt: DateTime.parse(map["updatedAt"] as String),
      publishAt: DateTime.parse(map["publishAt"] as String),
      readableAt: DateTime.parse(map["readableAt"] as String),
    );
  }

  factory ChapterAttributes.fromJson(String source) =>
      ChapterAttributes.fromMap(json.decode(source) as Map<String, dynamic>);
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
      translatedLanguage: Locale.fromJsonValue(attributes.translatedLanguage),
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
      uploader: relationships.ofType<UserAttributes>(EntityType.user).first.toUser(),
      groups: relationships
          .ofType<GroupAttributes>(EntityType.scanlationGroup)
          .map((e) => e.toGroup())
          .toList(),
    );
  }
}
