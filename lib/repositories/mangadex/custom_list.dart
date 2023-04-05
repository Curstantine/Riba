// ignore_for_file: public_member_api_docs, sort_constructors_first
import "dart:convert";

import "package:logging/logging.dart";
import "package:riba/repositories/local/custom_list.dart";
import "package:riba/repositories/local/user.dart";
import "package:riba/repositories/mangadex.dart";
import "package:riba/repositories/mangadex/models/custom_list.dart";
import "package:riba/repositories/mangadex/models/general.dart";
import "package:riba/repositories/mangadex/utils/service.dart";
import "package:riba/repositories/runtime/custom_list.dart";
import "package:riba/repositories/utils/rate_limiter.dart";
import "package:riba/repositories/utils/url.dart";
import "package:riba/utils/hash.dart";

class MangaDexCustomListService extends MangaDexService<CustomListAttributes, CustomList,
    CustomListData, CustomListData, MangaDexCustomListQueryFilter> {
  MangaDexCustomListService({
    required super.client,
    required super.rateLimiter,
    required super.database,
    required super.rootUrl,
  });

  @override
  final logger = Logger("MangaDexCustomListService");

  @override
  final Map<String, Rate> rates = {
    "/list:GET": const Rate(4, Duration(seconds: 1)),
  };

  @override
  late final baseUrl = rootUrl.copyWith(pathSegments: ["list"]);
  static const String seasonalListId = "44224004-1fad-425e-b416-45b46b74d3d1";

  @override
  final defaultFilters = MangaDexCustomListQueryFilter(
    includes: [EntityType.user],
    limit: 100,
  );

  @override
  MangaDexCustomListService get instance => MangaDex.instance.customList;

  @override
  Future<CustomListData> get(String id, {bool checkDB = true}) async {
    logger.info("get($id, checkDB: $checkDB)");

    if (checkDB) {
      final inDB = await database.customLists.get(fastHash(id));
      if (inDB != null) return await collectMeta(inDB);
    }

    await rateLimiter.wait("/list:GET");
    final reqUrl = baseUrl.addPathSegment(id).setParameter("includes[]", defaultFilters.includes);
    final request = await client.get(reqUrl.toUri());

    final response = CustomListEntity.fromMap(jsonDecode(request.body), url: reqUrl);
    final listData = response.data.toCustomListData();
    await insertMeta(listData);

    return listData;
  }

  @override
  Future<Map<String, CustomListData>> getMany({
    required MangaDexCustomListQueryFilter overrides,
    bool checkDB = true,
  }) {
    // TODO: implement getMany
    throw UnimplementedError();
  }

  Future<CustomListData> getSeasonal() => get(seasonalListId);

  @override
  Future<void> insertMeta(CustomListData data) async {
    await database.writeTxn(() async {
      await database.customLists.put(data.list);
      await database.users.put(data.user);
    });
  }

  @override
  Future<CustomListData> collectMeta(CustomList single) async {
    return CustomListData(
      list: single,
      user: (await database.users.get(fastHash(single.userId)))!,
    );
  }
}

class MangaDexCustomListQueryFilter extends MangaDexQueryFilter {
  final int? limit;
  final int? offset;
  final String? id;
  final List<EntityType>? includes;

  MangaDexCustomListQueryFilter({this.limit, this.offset, this.id, this.includes});

  @override
  URL addFiltersToUrl(URL url) {
    if (id != null) url = url.setParameter("id", id);

    final generic = MangaDexGenericQueryFilter(limit: limit, offset: offset, includes: includes);
    return generic.addFiltersToUrl(url);
  }
}
