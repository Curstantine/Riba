// GENERATED CODE - DO NOT MODIFY BY HAND

part of "cover_art.dart";

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CoverArtAttributes _$CoverArtAttributesFromJson(Map<String, dynamic> json) =>
    CoverArtAttributes(
      volume: json["volume"] as String?,
      fileName: json["fileName"] as String,
      description: json["description"] as String?,
      locale: json["locale"] as String?,
      createdAt: DateTime.parse(json["createdAt"] as String),
      updatedAt: DateTime.parse(json["updatedAt"] as String),
      version: json["version"] as int,
    );
