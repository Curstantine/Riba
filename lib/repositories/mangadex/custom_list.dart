import "dart:convert";
import "dart:developer";

import "package:http/http.dart";
import "package:isar/isar.dart";
import "package:riba/repositories/local/custom_list.dart";
import "package:riba/repositories/local/user.dart";
import "package:riba/repositories/mangadex/user.dart";
import "package:riba/repositories/rate_limiter.dart";
import "package:riba/repositories/runtime/custom_list.dart";
import "package:riba/utils/hash.dart";

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

  static const String seasonalListId = "44224004-1fad-425e-b416-45b46b74d3d1";

  Future<CustomListData> get(String id) async {
    log("get($id)", name: "MDCustomListRepo");

    final inDB = await database.customLists.get(fastHash(id));
    if (inDB != null) return _collectMeta(inDB);

    await rateLimiter.wait("/list:GET");
    final reqUrl = url.copy().addPathSegment(id).setParameter("includes[]", includes);
    final request = await client.get(reqUrl.toUri());

    final response = MDCustomListEntity.fromMap(jsonDecode(request.body), url: reqUrl);
    final listData = response.data.toCustomListData();
    await _insertMeta(listData);

    return listData;
  }

  Future<CustomListData> getSeasonal() => get(seasonalListId);

  Future<void> _insertMeta(CustomListData customListData) async {
    await database.writeTxn(() async {
      await database.customLists.put(customListData.list);
      await database.users.put(customListData.user);
    });
  }

  Future<CustomListData> _collectMeta(CustomList customList) async {
    return CustomListData(
      list: customList,
      user: (await database.users.get(fastHash(customList.userId)))!,
    );
  }
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
      mangaIds: relationships.ofType(EntityType.manga).map((e) => e.id).toList(),
      userId: relationships.ofType(EntityType.user).first.id,
    );
  }

  CustomListData toCustomListData() {
    return CustomListData(
      list: toCustomList(),
      user: relationships.ofType<UserAttributes>(EntityType.user).first.toUser(),
    );
  }
}
