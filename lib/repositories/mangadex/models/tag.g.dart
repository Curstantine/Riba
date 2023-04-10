// GENERATED CODE - DO NOT MODIFY BY HAND

part of "tag.dart";

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TagAttributes _$TagAttributesFromJson(Map<String, dynamic> json) =>
    TagAttributes(
      name: Map<String, String>.from(json["name"] as Map),
      group: TagGroup.fromJson(json["group"] as String),
      description: Map<String, String>.from(json["description"] as Map),
      version: json["version"] as int,
    );

const _$TagGroupEnumMap = {
  TagGroup.content: "content",
  TagGroup.format: "format",
  TagGroup.genre: "genre",
  TagGroup.theme: "theme",
};
