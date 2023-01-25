import "package:json_annotation/json_annotation.dart";
import "package:riba/repositories/mangadex/manga.dart";
import "package:riba/repositories/mangadex/tag.dart";

import "error.dart";

part "general.g.dart";

class MDResponse {
  final String result;
  final String response;

  const MDResponse({required this.result, required this.response});
}

class MDEntityResponse<T> extends MDResponse {
  final MDResponseData<T> data;

  factory MDEntityResponse.fromJson(Map<String, dynamic> json) {
    final result = json["result"] as String;

    if (result == "error") {
      final errors = MDError.fromJson((json["errors"] as List<dynamic>)[0]);
      throw MDException(errors);
    }

    final responseType = json["response"] as String;

    if (responseType != "entity") {
      throw Exception("Response type is not entity.");
    }

    return MDEntityResponse(
      result: result,
      response: responseType,
      data: MDResponseData<T>.fromJson(json["data"]),
    );
  }

  const MDEntityResponse({required super.result, required super.response, required this.data});
}

class MDCollectionResponse<T> extends MDResponse {
  final List<MDResponseData<T>> data;

  factory MDCollectionResponse.fromJson(Map<String, dynamic> json) {
    final result = json["result"] as String;

    if (result == "error") {
      final errors = MDError.fromJson((json["errors"] as List<dynamic>)[0]);
      throw MDException(errors);
    }

    final responseType = json["response"] as String;

    if (responseType != "collection") {
      throw Exception("Response type is not collection.");
    }

    return MDCollectionResponse(
      result: result,
      response: responseType,
      data: (json["data"] as List<Map<String, dynamic>>)
          .map((e) => MDResponseData<T>.fromJson(e))
          .toList(),
    );
  }

  const MDCollectionResponse({required super.result, required super.response, required this.data});
}

class MDResponseData<T> {
  final String id;
  final EntityType type;
  final T attributes;
  final List<Relationship> relationships;

  const MDResponseData({
    required this.id,
    required this.type,
    required this.attributes,
    required this.relationships,
  });

  factory MDResponseData.fromJson(Map<String, dynamic> json) {
    final type = $enumDecode(_$EntityTypeEnumMap, json["type"]);
    late T attributes;

    if (type == EntityType.manga) {
      attributes = MangaAttributes.fromJson(json["attributes"]) as T;
    } else if (type == EntityType.tag) {
      attributes = TagAttributes.fromJson(json["attributes"]) as T;
    } else {
      throw UnimplementedError("Entity: $type, on T: $T is not implemented yet.");
    }

    return MDResponseData(
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
  tag,
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
