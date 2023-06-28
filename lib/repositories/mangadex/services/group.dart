// ignore_for_file: public_member_api_docs, sort_constructors_first
import "dart:convert";
import "dart:io";

import "package:copy_with_extension/copy_with_extension.dart";
import "package:logging/logging.dart";
import "package:riba/repositories/local/models/group.dart";
import "package:riba/repositories/local/models/user.dart";
import "package:riba/repositories/mangadex/models/general.dart";
import "package:riba/repositories/mangadex/models/group.dart";
import "package:riba/repositories/mangadex/utils/service.dart";
import "package:riba/repositories/runtime/collection.dart";
import "package:riba/repositories/runtime/group.dart";
import "package:riba/repositories/utils/enumerate.dart";
import "package:riba/repositories/utils/exception.dart";
import "package:riba/repositories/utils/rate_limiter.dart";
import "package:riba/repositories/utils/url.dart";
import "package:riba/utils/hash.dart";

part "group.g.dart";

class MangaDexGroupService extends MangaDexService<
	GroupAttributes, Group, GroupData, GroupData,
    MangaDexGenericQueryFilter,
	MangaDexGenericQueryFilter,
	MangaDexGroupWithFilterQueryFilter
> {
	MangaDexGroupService({
		required super.client,
		required super.rateLimiter,
		required super.database,
		required super.rootUrl,
	});

	@override
	final logger = Logger("MangaDexGroupService");

	@override
	final Map<String, Rate> rates = {
		"/group:GET": const Rate(4, Duration(seconds: 1)),
	};

	@override
	Directory get cacheDir => throw UnimplementedError();

	@override
	Directory get dataDir => throw UnimplementedError();

	@override
	late final baseUrl = rootUrl.copyWith(pathSegments: ["group"]);

	@override
	final defaultFilters = const MangaDexGenericQueryFilter(
		includes: [EntityType.leader, EntityType.member],
		limit: 100,
	);

	@override
	Future<GroupData> get(String id, {bool checkDB = true}) {
		// TODO: implement get
		throw UnimplementedError();
	}

	@override
	@Deprecated(
		"Will not be implemented, used as a stub for the interface. Use getManyAsSingle instead.")
	Future<Map<String, GroupData>> getMany({required overrides, checkDB = true}) {
		throw UnimplementedError();
	}

	@override
	Future<CollectionData<GroupData>> withFilters({required overrides}) async {
		logger.info("withFilters(${overrides.toString()})");

		await rateLimiter.wait("/group:GET");
		final reqUrl = baseUrl.clone().addFilters(defaultFilters).addFilters(overrides);
		final request = await client.get(reqUrl.toUri());
		final response = GroupCollection.fromMap(jsonDecode(request.body), url: reqUrl);

		final data = response.data.map((e) => e.toGroupData()).toList();
		await database.isar.writeTxn(() => Future.wait(data.map(insertMeta)));

		return CollectionData(
			data: data,
			limit: response.limit,
			offset: response.offset,
			total: response.total,
		);
	}

	Future<Map<String, Group>> getManyAsSingle({
		required MangaDexGroupGetManyAsSingleQueryFilter overrides,
		bool checkDB = true,
	}) async {
		logger.info("getManyAsSingle(${overrides.toString()}, $checkDB)");

		final Map<String, Group?> mapped = {for (final e in overrides.ids) e: null};

		if (checkDB) {
			final inDB = await database.getAll(overrides.ids.map(fastHash).toList());
			for (final group in inDB) {
				if (group == null) continue;
				mapped[group.id] = group;
			}
		}

		final missing = mapped.entries.where((e) => e.value == null).map((e) => e.key).toList();
		if (missing.isEmpty) return mapped.cast<String, Group>();

		final hoistedUrl = baseUrl.clone().addFilters(defaultFilters).addFilters(overrides);

		final block = Enumerate<String, GroupData>(
			perStep: defaultFilters.limit!,
			items: missing,
			onStep: (resolved) async {
				await rateLimiter.wait("/group:GET");

				final reqUrl = hoistedUrl.setParameter("ids[]", resolved.keys.toList());
				final request = await client.get(reqUrl.toUri());
				final response = GroupCollection.fromMap(jsonDecode(request.body), url: reqUrl);

				for (final data in response.data) {
					try {
						resolved[data.id] = data.toGroupData();
					} on LanguageNotSupportedException catch (e) {
						logger.warning(e.toString());
					}
				}
			},
			onMismatch: (missedIds) {
				logger.warning("Some entries were not in the response, ignoring them: $missedIds");
				for (final id in missedIds) {
					mapped.remove(id);
				}
			},
		);

		final res = await block.run();
		await database.isar.writeTxn(() => Future.wait(res.values.map(insertMeta)));

		return mapped.cast<String, Group>()..addAll(res.map((k, v) => MapEntry(k, v.group)));
	}

	@override
	Future<void> insertMeta(GroupData data) async {
		await Future.wait([
			database.put(data.group),
			database.isar.users.putAll(data.users.values.toList()),
		]);
	}

	/// Collects related data for a group to make a [GroupData] object.
	///
	/// [Group.memberIds] should not be null, if it is, [IncompleteDataException] is thrown.
	@override
	Future<GroupData> collectMeta(Group single) async {
		if (single.memberIds == null) throw const IncompleteDataException("Group.memberIds is null");
		final users = await database.isar.users.getAll(single.memberIds!.map((e) => fastHash(e)).toList());

		return GroupData(
			group: single,
			users: {for (final user in users as List<User>) user.id: user},
		);
	}
}

@CopyWith()
class MangaDexGroupGetManyAsSingleQueryFilter implements MangaDexQueryFilter {
	final List<String> ids;

	const MangaDexGroupGetManyAsSingleQueryFilter({required this.ids});

	@override
	URL addFiltersToUrl(URL sourceUrl) {
		return sourceUrl.setParameter("ids[]", ids);
	}

	@override
	String toString() => "MangaDexGroupGetManyAsSingleQueryFilter(ids: $ids)";
}

@CopyWith()
class MangaDexGroupWithFilterQueryFilter implements MangaDexQueryFilter {
	final int limit;
	final int offset;

	final String? name;
	final bool orderByFollowedCountDesc;

	const MangaDexGroupWithFilterQueryFilter({
		this.limit = 100,
		this.offset = 0,
		this.name,
		this.orderByFollowedCountDesc = true, 
	});

	@override
	URL addFiltersToUrl(URL sourceUrl) {
		if (name != null) sourceUrl.setParameter("name", name);
		if (orderByFollowedCountDesc) sourceUrl.setParameter("order[followedCount]", "desc");

		return MangaDexGenericQueryFilter(limit: limit, offset: offset).addFiltersToUrl(sourceUrl);
	}


	@override
	String toString() {
		return "MangaDexGroupWithFilterQueryFilter(limit: $limit, offset: $offset, name: $name, orderByFollowedCountDesc: $orderByFollowedCountDesc)";
	}
}
