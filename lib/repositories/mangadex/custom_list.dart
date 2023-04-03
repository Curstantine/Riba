import "dart:convert";
import "dart:developer";

import "package:http/http.dart";
import "package:isar/isar.dart";
import "package:riba/repositories/local/custom_list.dart";
import "package:riba/repositories/local/user.dart";
import "package:riba/repositories/utils/rate_limiter.dart";
import "package:riba/repositories/runtime/custom_list.dart";
import "package:riba/utils/hash.dart";

import "general.dart";
import "../mangadex.dart";
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
