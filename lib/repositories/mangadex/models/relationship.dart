import "package:json_annotation/json_annotation.dart";
import "package:riba/repositories/mangadex/utils/enum.dart";
import "package:riba/repositories/mangadex/utils/transformer.dart";

import "general.dart";

part "relationship.g.dart";

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
    final type = EntityType.fromJson(json["type"] as String);
    final jsonAttr = json["attributes"];
    final related =
        json["related"] == null ? null : MangaRelationType.fromJson(json["related"] as String);

    T? attributes = jsonAttr == null ? null : transformToEntity(jsonAttr, type);

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
@JsonEnum(alwaysCreate: true, fieldRename: FieldRename.snake)
enum MangaRelationType implements TwoWayEnumSerde {
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

  @override
  factory MangaRelationType.fromJson(String source) =>
      $enumDecode(_$MangaRelationTypeEnumMap, source);

  @override
  String toJson() => _$MangaRelationTypeEnumMap[this]!;

  @override
  String asHumanReadable() {
    switch (this) {
      case MangaRelationType.monochrome:
        return "Monochrome";
      case MangaRelationType.colored:
        return "Colored";
      case MangaRelationType.preserialization:
        return "Preserialization";
      case MangaRelationType.serialization:
        return "Serialization";
      case MangaRelationType.prequel:
        return "Prequel";
      case MangaRelationType.sequel:
        return "Sequel";
      case MangaRelationType.doujinshi:
        return "Doujinshi";
      case MangaRelationType.mainStory:
        return "Main Story";
      case MangaRelationType.sideStory:
        return "Side Story";
      case MangaRelationType.adaptedFrom:
        return "Adapted From";
      case MangaRelationType.spinOff:
        return "Spin Off";
      case MangaRelationType.basedOn:
        return "Based On";
      case MangaRelationType.sameFranchise:
        return "Same Franchise";
      case MangaRelationType.sharedUniverse:
        return "Shared Universe";
      case MangaRelationType.alternateStory:
        return "Alternate Story";
      case MangaRelationType.alternateVersion:
        return "Alternate Version";
    }
  }
}

extension RelationshipList on List<Relationship> {
  List<Relationship<T>> ofType<T>(EntityType type) {
    return where((e) => e.type == type).map((e) => e.cast<T>()).toList();
  }
}
