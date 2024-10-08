// ignore_for_file: public_member_api_docs, sort_constructors_first
import "dart:convert";
import "dart:io";

import "package:logging/logging.dart";
import "package:riba/repositories/local/models/custom_list.dart";
import "package:riba/repositories/local/models/user.dart";
import "package:riba/repositories/mangadex/models/custom_list.dart";
import "package:riba/repositories/mangadex/models/general.dart";
import "package:riba/repositories/mangadex/utils/service.dart";
import "package:riba/repositories/runtime/collection.dart";
import "package:riba/repositories/runtime/custom_list.dart";
import "package:riba/repositories/utils/rate_limiter.dart";
import "package:riba/utils/hash.dart";

class MangaDexCustomListService extends MangaDexService<
	CustomListAttributes, CustomList, CustomListData, CustomListData,
	MangaDexGenericQueryFilter,
	MangaDexGenericQueryFilter,
	MangaDexGenericQueryFilter
> {
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
	Directory get cacheDir => throw UnimplementedError();

	@override
	Directory get dataDir => throw UnimplementedError();

	@override
	late final baseUrl = rootUrl.copyWith(pathSegments: ["list"]);
	static const String seasonalListId = "54736a5c-eb7f-4844-971b-80ee171cdf29";

	@override
	final defaultFilters = const MangaDexGenericQueryFilter(
		includes: [EntityType.user],
		limit: 100,
	);

	@override
	Future<CustomListData> get(String id, {checkDB = true}) async {
		logger.info("get($id, $checkDB)");

		if (checkDB) {
			final inDB = await database.get(fastHash(id));
			if (inDB != null) return await collectMeta(inDB);
		}

		await rateLimiter.wait("/list:GET");

		final reqUrl = baseUrl.clone().addPathSegment(id).addFilters(defaultFilters);
		final request = await client.get(reqUrl.toUri());
		final response = CustomListEntity.fromMap(jsonDecode(request.body), url: reqUrl);

		final listData = response.data.toCustomListData();
		await database.isar.writeTxn(() => insertMeta(listData));

		return listData;
	}

	@override
	Future<Map<String, CustomListData>> getMany({required overrides, checkDB = true}) {
		// TODO: implement getMany
		throw UnimplementedError();
	}

	@override
	@Deprecated("Will not be implemented, used as a stub for the interface.")
	Future<CollectionData<CustomListData>> withFilters({required overrides}) {
		throw UnimplementedError();
	}

	Future<CustomListData> getSeasonal() => get(seasonalListId);

	@override
	Future<void> insertMeta(CustomListData data) async {
		await Future.wait([
			database.put(data.list),
			database.isar.users.put(data.user),
		]);
	}

	@override
	Future<CustomListData> collectMeta(CustomList single) async {
		return CustomListData(
			list: single,
			user: (await database.isar.users.get(fastHash(single.userId)))!,
		);
	}
}
