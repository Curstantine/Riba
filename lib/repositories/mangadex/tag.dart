// ignore_for_file: public_member_api_docs, sort_constructors_first

import "package:riba/repositories/local/localization.dart";
import "package:riba/repositories/local/tag.dart";

import "general.dart";

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

  factory TagAttributes.fromMap(Map<String, dynamic> map) {
    return TagAttributes(
      name: (map["name"] as Map<String, dynamic>).cast(),
      group: TagGroup.fromJsonValue(map["group"]),
      description: (map["description"] as Map<String, dynamic>).cast(),
      version: map["version"] as int,
    );
  }
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
enum TagGroup {
  content,
  format,
  genre,
  theme;

  static Map<String, TagGroup> get jsonValues => {
        "content": TagGroup.content,
        "format": TagGroup.format,
        "genre": TagGroup.genre,
        "theme": TagGroup.theme,
      };

  static TagGroup fromJsonValue(String str) {
    return jsonValues[str]!;
  }
}
