import 'package:json_annotation/json_annotation.dart';

part 'general.g.dart';

class MDResponse<T> {
  final String result;
  final String response;
  final T data;

  MDResponse({
    required this.result,
    required this.response,
    required this.data,
  });
  factory MDResponse.fromJson(Map<String, dynamic> json) {
    final isEntity = json["response"] == "entity";

    return MDResponse(
      result: json["result"] as String,
      response: json["response"] as String,
      data: (isEntity ? EntityData.fromJson(json["data"]) : json["data"]) as T,
    );
  }
}

class EntityData<T> {
  final String id;
  final EntityType type;
  final T attributes;
  final List<Relationship> relationships;

  EntityData({
    required this.id,
    required this.type,
    required this.attributes,
    required this.relationships,
  });

  factory EntityData.fromJson(Map<String, dynamic> json) {
    return EntityData(
      id: json["id"] as String,
      type: $enumDecode(_$EntityTypeEnumMap, json["type"]),
      attributes: json["attributes"] as T,
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
