import "package:json_annotation/json_annotation.dart";

import "general.dart";

part "tag.g.dart";

@JsonSerializable()
class TagAttributes {
  final Map<String, String> name;

  const TagAttributes({
    required this.name,
  });

  factory TagAttributes.fromJson(Map<String, dynamic> json) => _$TagAttributesFromJson(json);

  static List<MDResponseData<TagAttributes>> fromList(List<dynamic> list) {
    return list
        .map((e) => MDResponseData<TagAttributes>.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
