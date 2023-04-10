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
      tags: (json["tags"] as List<dynamic>)
          .map((e) =>
              MDResponseData<TagAttributes>.fromJson(e as Map<String, dynamic>))
          .toList(),
      originalLanguage: json["originalLanguage"] as String,
      publicationDemographic: $enumDecodeNullable(
          _$MangaPublicationDemographicEnumMap, json["publicationDemographic"]),
      status: $enumDecode(_$MangaStatusEnumMap, json["status"]),
      contentRating:
          $enumDecode(_$MangaContentRatingEnumMap, json["contentRating"]),
      version: json["version"] as int,
    );

const _$MangaPublicationDemographicEnumMap = {
  MangaPublicationDemographic.unknown: "unknown",
  MangaPublicationDemographic.shounen: "shounen",
  MangaPublicationDemographic.shoujo: "shoujo",
  MangaPublicationDemographic.josei: "josei",
  MangaPublicationDemographic.seinen: "seinen",
};

const _$MangaStatusEnumMap = {
  MangaStatus.ongoing: "ongoing",
  MangaStatus.completed: "completed",
  MangaStatus.hiatus: "hiatus",
  MangaStatus.cancelled: "cancelled",
};

const _$MangaContentRatingEnumMap = {
  MangaContentRating.safe: "safe",
  MangaContentRating.suggestive: "suggestive",
  MangaContentRating.erotica: "erotica",
  MangaContentRating.pornographic: "pornographic",
};
