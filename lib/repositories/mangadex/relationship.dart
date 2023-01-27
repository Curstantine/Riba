import "general.dart";

class Relationship<T> {
  final String id;
  final EntityType type;

  /// Only for [type] == [EntityType.manga]
  final MangaRelationType? related;

  /// Only populated if includes for this [type] is requested.
  final T? attributes;

  const Relationship({
    required this.id,
    required this.type,
    this.related,
    this.attributes,
  });

  factory Relationship.fromJson(Map<String, dynamic> json) {
    final type = EntityType.fromJsonValue(json["type"] as String);
    final jsonAttr = json["attributes"];
    final related =
        json["related"] == null ? null : MangaRelationType.fromJsonValue(json["related"] as String);

    T? attributes = jsonAttr == null ? null : mapToEntity(jsonAttr, type);

    return Relationship(
      id: json["id"] as String,
      type: type,
      related: related,
      attributes: attributes,
    );
  }
}

enum MangaRelationType {
  monochrome,
  colored,
  preserialization,
  serialization,
  prequel,
  sequel,
  doujinshi,
  mainStory,
  sideStory,
  adoptedFrom,
  spinOff,
  basedOn,
  sameFranchise,
  sharedUniverse,
  alternateStory,
  alternateVersion;

  static Map<MangaRelationType, String> get jsonValues => {
        monochrome: "monochrome",
        colored: "colored",
        preserialization: "preserialization",
        serialization: "serialization",
        prequel: "prequel",
        sequel: "sequel",
        doujinshi: "doujinshi",
        mainStory: "main_story",
        sideStory: "side_story",
        adoptedFrom: "adopted_from",
        spinOff: "spin_off",
        basedOn: "based_on",
        sameFranchise: "same_franchise",
        sharedUniverse: "shared_universe",
        alternateStory: "alternate_story",
        alternateVersion: "alternate_version",
      };

  factory MangaRelationType.fromJsonValue(String str) {
    return jsonValues.entries.firstWhere((element) => element.value == str).key;
  }

  String toJsonValue() => jsonValues[this]!;
}

extension RelationshipList on List<Relationship> {
  List<Relationship> ofType(EntityType type) {
    return where((element) => element.type == type).toList();
  }
}
