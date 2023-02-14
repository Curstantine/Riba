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

  Relationship<N> cast<N>() {
    return Relationship<N>(
      id: id,
      type: type,
      related: related,
      attributes: attributes as N,
    );
  }
}

// CAUTION: DO NOT CHANGE THE ORDER OF THE ENUM
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
  adaptedFrom,
  spinOff,
  basedOn,
  sameFranchise,
  sharedUniverse,
  alternateStory,
  alternateVersion;

  static Map<String, MangaRelationType> get jsonValues => {
        "monochrome": MangaRelationType.monochrome,
        "colored": MangaRelationType.colored,
        "preserialization": MangaRelationType.preserialization,
        "serialization": MangaRelationType.serialization,
        "prequel": MangaRelationType.prequel,
        "sequel": MangaRelationType.sequel,
        "doujinshi": MangaRelationType.doujinshi,
        "main_story": MangaRelationType.mainStory,
        "side_story": MangaRelationType.sideStory,
        "adapted_from": MangaRelationType.adaptedFrom,
        "spin_off": MangaRelationType.spinOff,
        "based_on": MangaRelationType.basedOn,
        "same_franchise": MangaRelationType.sameFranchise,
        "shared_universe": MangaRelationType.sharedUniverse,
        "alternate_story": MangaRelationType.alternateStory,
        "alternate_version": MangaRelationType.alternateVersion,
      };

  factory MangaRelationType.fromJsonValue(String str) {
    return jsonValues[str]!;
  }
}

extension RelationshipList on List<Relationship> {
  List<Relationship<T>> ofType<T>(EntityType type) {
    return where((e) => e.type == type).map((e) => e.cast<T>()).toList();
  }
}
