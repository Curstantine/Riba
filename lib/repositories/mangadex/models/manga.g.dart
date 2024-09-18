// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manga.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MangaAttributes _$MangaAttributesFromJson(Map<String, dynamic> json) =>
    MangaAttributes(
      title: Map<String, String>.from(json['title'] as Map),
      altTitles: (json['altTitles'] as List<dynamic>)
          .map((e) => Map<String, String>.from(e as Map))
          .toList(),
      description: Map<String, String>.from(json['description'] as Map),
      tags: (json['tags'] as List<dynamic>)
          .map((e) =>
              MDResponseData<TagAttributes>.fromJson(e as Map<String, dynamic>))
          .toList(),
      originalLanguage: json['originalLanguage'] as String,
      publicationDemographic: $enumDecodeNullable(
          _$MangaPublicationDemographicEnumMap, json['publicationDemographic']),
      status: $enumDecode(_$MangaPublicationStatusEnumMap, json['status']),
      contentRating: $enumDecode(_$ContentRatingEnumMap, json['contentRating']),
      version: (json['version'] as num).toInt(),
    );

const _$MangaPublicationDemographicEnumMap = {
  MangaPublicationDemographic.unknown: 'unknown',
  MangaPublicationDemographic.shounen: 'shounen',
  MangaPublicationDemographic.shoujo: 'shoujo',
  MangaPublicationDemographic.josei: 'josei',
  MangaPublicationDemographic.seinen: 'seinen',
};

const _$MangaPublicationStatusEnumMap = {
  MangaPublicationStatus.ongoing: 'ongoing',
  MangaPublicationStatus.completed: 'completed',
  MangaPublicationStatus.hiatus: 'hiatus',
  MangaPublicationStatus.cancelled: 'cancelled',
};

const _$ContentRatingEnumMap = {
  ContentRating.safe: 'safe',
  ContentRating.suggestive: 'suggestive',
  ContentRating.erotica: 'erotica',
  ContentRating.pornographic: 'pornographic',
};
