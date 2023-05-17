import "package:json_annotation/json_annotation.dart";
import "package:riba/repositories/mangadex/models/relationship.dart";
import "package:riba/repositories/mangadex/utils/enum.dart";
import "package:riba/repositories/mangadex/utils/transformer.dart";
import "package:riba/repositories/utils/exception.dart";
import "package:riba/repositories/utils/url.dart";

import "error.dart";

part "general.g.dart";

abstract class MDResponse {
  final String result;
  final String response;

  const MDResponse({required this.result, required this.response});
}

class MDEntityResponse<T> extends MDResponse {
  final MDResponseData<T> data;

  const MDEntityResponse({
    required super.result,
    required super.response,
    required this.data,
  });

  factory MDEntityResponse.fromMap(Map<String, dynamic> json, {URL? url}) {
    final result = json["result"] as String;

    if (result == "error") {
      final errors = MDError.fromJson((json["errors"] as List<dynamic>)[0]);
      throw MDException(errors, url: url);
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
}

class MDCollectionResponse<T> extends MDResponse {
  final List<MDResponseData<T>> data;
  final int limit;
  final int offset;
  final int total;

  const MDCollectionResponse({
    required super.result,
    required super.response,
    required this.data,
    required this.limit,
    required this.offset,
    required this.total,
  });

  factory MDCollectionResponse.fromMap(Map<String, dynamic> json, {URL? url}) {
    final result = json["result"] as String;

    if (result == "error") {
      final errors = MDError.fromJson((json["errors"] as List<dynamic>)[0]);
      throw MDException(errors, url: url);
    }

    final responseType = json["response"] as String;
    if (responseType != "collection") {
      throw Exception("Response type is not collection.");
    }

    return MDCollectionResponse(
      result: result,
      response: responseType,
      data: (json["data"] as List<dynamic>).map((e) => MDResponseData<T>.fromJson(e)).toList(),
      limit: json["limit"] as int,
      offset: json["offset"] as int,
      total: json["total"] as int,
    );
  }
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

  factory MDResponseData.fromJson(Map<String, dynamic> map) {
    final type = EntityType.fromJson(map["type"] as String);
    final attributes = transformToEntity<T>(map["attributes"], type);

    return MDResponseData(
      id: map["id"] as String,
      type: type,
      attributes: attributes,
      relationships: (map["relationships"] as List<dynamic>)
          .map((e) => Relationship.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

// CAUTION: DO NOT CHANGE THE ORDER OF THE ENUM
@JsonEnum(fieldRename: FieldRename.snake, alwaysCreate: true)
enum EntityType implements TwoWayEnumSerde {
	manga,
	chapter,
	customList,
	author,
	artist,
	user,
	tag,
	coverArt,
	scanlationGroup,

	/// Special entity type for group relationships, stored here for convenience.
	leader,

	/// Special entity type for group relationships, stored here for convenience.
	member,
	
	@Deprecated("DO NOT USE THIS. This is a stub used for legacy purposes.")
	creator;

	@override
	factory EntityType.fromJson(String source) => $enumDecode(_$EntityTypeEnumMap, source);

	@override
	String toJson() => _$EntityTypeEnumMap[this]!;

	@override
	@Deprecated("Will not be implemented, used as a stub for the interface.")
	String asHumanReadable() => throw UnimplementedError();
}
