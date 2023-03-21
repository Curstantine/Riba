import "package:riba/repositories/exception.dart";
import "package:riba/repositories/mangadex/group.dart";
import "package:riba/repositories/url.dart";

import "author.dart";
import "chapter.dart";
import "cover_art.dart";
import "custom_list.dart";
import "error.dart";
import "manga.dart";
import "relationship.dart";
import "tag.dart";
import "user.dart";

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
      final errors = MDError.fromMap((json["errors"] as List<dynamic>)[0]);
      throw MDException(errors, url: url);
    }

    final responseType = json["response"] as String;

    if (responseType != "entity") {
      throw Exception("Response type is not entity.");
    }

    return MDEntityResponse(
      result: result,
      response: responseType,
      data: MDResponseData<T>.fromMap(json["data"]),
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
      final errors = MDError.fromMap((json["errors"] as List<dynamic>)[0]);
      throw MDException(errors, url: url);
    }

    final responseType = json["response"] as String;

    if (responseType != "collection") {
      throw Exception("Response type is not collection.");
    }

    return MDCollectionResponse(
      result: result,
      response: responseType,
      data: (json["data"] as List<dynamic>).map((e) => MDResponseData<T>.fromMap(e)).toList(),
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

  factory MDResponseData.fromMap(Map<String, dynamic> map) {
    final type = EntityType.fromJsonValue(map["type"] as String);
    final attributes = mapToEntity<T>(map["attributes"], type);

    return MDResponseData(
      id: map["id"] as String,
      type: type,
      attributes: attributes,
      relationships: (map["relationships"] as List<dynamic>)
          .map((e) => Relationship.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

// CAUTION: DO NOT CHANGE THE ORDER OF THE ENUM
enum EntityType {
  manga,
  chapter,
  customList,
  author,
  artist,
  user,
  tag,
  coverArt,
  scanlationGroup;

  static Map<String, EntityType> get jsonValues => {
        "manga": manga,
        "chapter": chapter,
        "custom_list": customList,
        "author": author,
        "artist": artist,
        "user": user,
        "tag": tag,
        "cover_art": coverArt,
        "scanlation_group": scanlationGroup,
      };

  factory EntityType.fromJsonValue(String str) {
    return jsonValues[str]!;
  }

  String toJsonValue() => jsonValues.entries.firstWhere((e) => e.value == this).key;
}

T mapToEntity<T>(Map<String, dynamic> map, EntityType type) {
  late T attributes;

  switch (type) {
    case EntityType.manga:
      attributes = MangaAttributes.fromMap(map) as T;
      break;

    case EntityType.chapter:
      attributes = ChapterAttributes.fromMap(map) as T;
      break;

    case EntityType.customList:
      attributes = CustomListAttributes.fromMap(map) as T;
      break;

    case EntityType.author:
    case EntityType.artist:
      attributes = AuthorAttributes.fromMap(map) as T;
      break;

    case EntityType.tag:
      attributes = TagAttributes.fromMap(map) as T;
      break;

    case EntityType.coverArt:
      attributes = CoverArtAttributes.fromMap(map) as T;
      break;

    case EntityType.user:
      attributes = UserAttributes.fromMap(map) as T;
      break;

    case EntityType.scanlationGroup:
      attributes = GroupAttributes.fromMap(map) as T;
      break;

    default:
      throw UnimplementedError("Entity: $type, on T: $T is not implemented yet.");
  }

  return attributes;
}
