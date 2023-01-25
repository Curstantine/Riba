// GENERATED CODE - DO NOT MODIFY BY HAND

part of "manga.dart";

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MangaAttributes _$MangaAttributesFromJson(Map<String, dynamic> json) =>
    MangaAttributes(
      title: Map<String, String>.from(json["title"] as Map),
      altTitles: (json["altTitles"] as List<dynamic>)
          .map((e) => Map<String, String>.from(e as Map))
          .toList(),
      description: Map<String, String>.from(json["description"] as Map),
      tags: TagAttributes.fromList(json["tags"] as List),
      originalLanguage: json["originalLanguage"] as String,
    );
