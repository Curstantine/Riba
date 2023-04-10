// GENERATED CODE - DO NOT MODIFY BY HAND

part of "chapter.dart";

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChapterAttributes _$ChapterAttributesFromJson(Map<String, dynamic> json) =>
    ChapterAttributes(
      title: json["title"] as String?,
      volume: json["volume"] as String?,
      chapter: json["chapter"] as String?,
      pages: json["pages"] as int,
      translatedLanguage: json["translatedLanguage"] as String,
      externalUrl: json["externalUrl"] as String?,
      version: json["version"] as int,
      createdAt: DateTime.parse(json["createdAt"] as String),
      updatedAt: DateTime.parse(json["updatedAt"] as String),
      publishAt: DateTime.parse(json["publishAt"] as String),
      readableAt: DateTime.parse(json["readableAt"] as String),
    );
