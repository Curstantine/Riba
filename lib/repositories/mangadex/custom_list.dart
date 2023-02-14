import "dart:convert";

import "package:http/http.dart";
import "package:isar/isar.dart";
import "package:riba/repositories/local/custom_list.dart";
import "package:riba/repositories/rate_limiter.dart";

import "general.dart";
import "mangadex.dart";
import "relationship.dart";

typedef MDCustomListEntity = MDEntityResponse<CustomListAttributes>;
typedef MDCustomListCollection = MDCollectionResponse<CustomListAttributes>;

class MDCustomListRepo {
  final Client client;
  final RateLimiter rateLimiter;
  final Isar database;

  MDCustomListRepo(this.client, this.rateLimiter, this.database) {
    rateLimiter.rates["/list:GET"] = const Rate(4, Duration(seconds: 1));
  }

  final url = MangaDex.url.copyWith(pathSegments: ["list"]);
  final includes = [
    EntityType.user.toJsonValue(),
  ];

  static const String seasonalListId = "4be9338a-3402-4f98-b467-43fb56663927";

  Future<CustomList> get(String id) async {
    await rateLimiter.wait("/list:GET");
    final reqUrl = url.asRef().addPathSegment(id).setParameter("includes[]", includes);
    final request = await client.get(reqUrl.toUri());

    final response = MDCustomListEntity.fromJson(jsonDecode(request.body), url: reqUrl);
    final list = response.data.toCustomList();

    database.writeTxn(() async {
      await database.customLists.put(list);
    });

    return list;
  }

  Future<CustomList> getSeasonal() => get(seasonalListId);
}

class CustomListAttributes {
  final String name;
  final CustomListVisibility visibility;
  final int version;

  const CustomListAttributes({
    required this.name,
    required this.visibility,
    required this.version,
  });

  factory CustomListAttributes.fromMap(Map<String, dynamic> map) {
    return CustomListAttributes(
      name: map["name"] as String,
      visibility: CustomListVisibility.fromJsonValue(map["visibility"] as String),
      version: map["version"] as int,
    );
  }
}

// CAUTION: DO NOT CHANGE THE ORDER OF THE ENUMS
enum CustomListVisibility {
  public,
  private;

  static Map<CustomListVisibility, String> get jsonValues => const {
        CustomListVisibility.public: "public",
        CustomListVisibility.private: "private",
      };

  factory CustomListVisibility.fromJsonValue(String str) {
    return jsonValues.entries.firstWhere((element) => element.value == str).key;
  }
}

extension ToCustomList on MDResponseData<CustomListAttributes> {
  CustomList toCustomList() {
    return CustomList(
      id: id,
      name: attributes.name,
      visibility: attributes.visibility,
      version: attributes.version,
      manga: relationships.ofType(EntityType.manga).map((e) => e.id).toList(),
      user: relationships.ofType(EntityType.user).first.id,
    );
  }
}
