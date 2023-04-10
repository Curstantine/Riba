// GENERATED CODE - DO NOT MODIFY BY HAND

part of "custom_list.dart";

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomListAttributes _$CustomListAttributesFromJson(
        Map<String, dynamic> json) =>
    CustomListAttributes(
      name: json["name"] as String,
      visibility:
          $enumDecode(_$CustomListVisibilityEnumMap, json["visibility"]),
      version: json["version"] as int,
    );

const _$CustomListVisibilityEnumMap = {
  CustomListVisibility.public: "public",
  CustomListVisibility.private: "private",
};
