// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manga.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MangaAttributes _$MangaAttributesFromJson(Map<String, dynamic> json) =>
    MangaAttributes(
      titles: Map<String, String?>.from(json['titles'] as Map),
      description: Map<String, String?>.from(json['description'] as Map),
      authors: (json['authors'] as List<dynamic>)
          .map((e) => Map<String, String?>.from(e as Map))
          .toList(),
      originalLanguage: json['originalLanguage'] as String,
    );

Map<String, dynamic> _$MangaAttributesToJson(MangaAttributes instance) =>
    <String, dynamic>{
      'titles': instance.titles,
      'description': instance.description,
      'authors': instance.authors,
      'originalLanguage': instance.originalLanguage,
    };
