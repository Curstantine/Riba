import "package:json_annotation/json_annotation.dart";
import "package:riba/repositories/local/localization.dart";
import "package:riba/repositories/local/tag.dart";
import "package:riba/repositories/mangadex/utils/enum.dart";

import "general.dart";

part "tag.g.dart";

@JsonSerializable(createToJson: false)
class TagAttributes {
  final Map<String, String> name;
  final TagGroup group;
  final Map<String, String> description;
  final int version;

  const TagAttributes({
    required this.name,
    required this.group,
    required this.description,
    required this.version,
  });

  factory TagAttributes.fromJson(Map<String, dynamic> source) => _$TagAttributesFromJson(source);
}

extension ToTag on MDResponseData<TagAttributes> {
  Tag toTag() => Tag(
        id: id,
        name: Localizations.fromMap(attributes.name),
        description: Localizations.fromMap(attributes.description),
        group: attributes.group,
        version: attributes.version,
      );
}

// CAUTION: DO NOT CHANGE THE ORDER OF THE ENUM
@JsonEnum(alwaysCreate: true)
enum TagGroup implements TwoWayEnumSerde {
  content,
  format,
  genre,
  theme;

  @override
  factory TagGroup.fromJson(String source) => $enumDecode(_$TagGroupEnumMap, source);

  @override
  String toJson() => _$TagGroupEnumMap[this]!;

  @override
  String asHumanReadable() {
    switch (this) {
      case TagGroup.content:
        return "Content";
      case TagGroup.format:
        return "Format";
      case TagGroup.genre:
        return "Genre";
      case TagGroup.theme:
        return "Theme";
    }
  }
}
