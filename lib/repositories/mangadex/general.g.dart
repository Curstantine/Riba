// GENERATED CODE - DO NOT MODIFY BY HAND

part of "general.dart";

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Relationship _$RelationshipFromJson(Map<String, dynamic> json) => Relationship(
      id: json["id"] as String,
      type: $enumDecode(_$EntityTypeEnumMap, json["type"]),
    );

Map<String, dynamic> _$RelationshipToJson(Relationship instance) => <String, dynamic>{
      "id": instance.id,
      "type": _$EntityTypeEnumMap[instance.type]!,
    };

const _$EntityTypeEnumMap = {
  EntityType.manga: "manga",
  EntityType.chapter: "chapter",
  EntityType.author: "author",
  EntityType.artist: "artist",
  EntityType.user: "user",
  EntityType.coverArt: "cover_art",
  EntityType.scanlationGroup: "scanlation_group",
  EntityType.basedOn: "based_on",
};
