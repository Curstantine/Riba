import "package:json_annotation/json_annotation.dart";
import "package:riba/repositories/mangadex/manga.dart";

import "error.dart";

part "general.g.dart";

class MDResponse<T extends MDResponseData, A extends Object> {
  final String result;
  final String response;
  final T data;

  const MDResponse({required this.result, required this.response, required this.data});

  factory MDResponse.fromJson(Map<String, dynamic> json) {
    final result = json["result"] as String;

    if (result != "ok" || result != "ko") {
      final errors = MDError.fromJson((json["errors"] as List<dynamic>)[0]);
      throw MDException(errors);
    }

    final isEntity = json["response"] == "entity";
    if (!isEntity) throw UnimplementedError();

    return MDResponse(
      result: result,
      response: json["response"] as String,
      data: (isEntity ? EntityData<A>.fromJson(json["data"]) : json["data"]),
    );
  }
}

abstract class MDResponseData {
  final String id;
  final EntityType type;

  const MDResponseData({required this.id, required this.type});
}

class EntityData<T> extends MDResponseData {
  final T attributes;
  final List<Relationship> relationships;

  const EntityData({
    required super.id,
    required super.type,
    required this.attributes,
    required this.relationships,
  });

  factory EntityData.fromJson(Map<String, dynamic> json) {
    final type = $enumDecode(_$EntityTypeEnumMap, json["type"]);
    late T attributes;

    if (T == MangaAttributes && type == EntityType.manga) {
      attributes = MangaAttributes.fromJson(json["attributes"]) as T;
    } else {
      throw UnimplementedError("Entity: $type, on T: $T is not implemented yet.");
    }

    return EntityData(
      id: json["id"] as String,
      type: type,
      attributes: attributes,
      relationships: (json["relationships"] as List<dynamic>)
          .map((e) => Relationship.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

@JsonEnum()
enum EntityType {
  manga,
  chapter,
  author,
  artist,
  user,
  @JsonValue("cover_art")
  coverArt,
  @JsonValue("scanlation_group")
  scanlationGroup,
  @JsonValue("based_on")
  basedOn,
}

@JsonSerializable()
class Relationship {
  final String id;
  final EntityType type;

  Relationship({
    required this.id,
    required this.type,
  });

  factory Relationship.fromJson(Map<String, dynamic> json) => _$RelationshipFromJson(json);
}

extension RelationshipList on List<Relationship> {
  List<Relationship> ofType(EntityType type) {
    return where((element) => element.type == type).toList();
  }
}
