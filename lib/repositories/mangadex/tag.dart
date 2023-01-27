// ignore_for_file: public_member_api_docs, sort_constructors_first

import "package:riba/repositories/local/localization.dart";
import "package:riba/repositories/local/tag.dart";

import "general.dart";

class TagAttributes {
  final Map<String, String> name;
  final TagGroup group;
  final Map<String, String> description;

  const TagAttributes({
    required this.name,
    required this.group,
    required this.description,
  });

  factory TagAttributes.fromMap(Map<String, dynamic> map) {
    return TagAttributes(
      name: map["name"] as Map<String, String>,
      group: TagGroup.fromJsonValue(map["group"]),
      description: map["description"] as Map<String, String>,
    );
  }
}

extension ToTag on MDResponseData<TagAttributes> {
  Tag toTag() => Tag(
        id: id,
        name: Localizations.fromMap(attributes.name),
        description: Localizations.fromMap(attributes.description),
        group: attributes.group,
      );
}

enum TagGroup {
  content,
  format,
  genre,
  theme;

  static Map<TagGroup, String> get jsonValues => {
        content: "content",
        format: "format",
        genre: "genre",
        theme: "theme",
      };

  static TagGroup fromJsonValue(String str) {
    return jsonValues.entries.firstWhere((e) => e.value == str).key;
  }

  String toJsonValue() => jsonValues[this]!;
}
