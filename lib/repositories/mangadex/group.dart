import "dart:convert";

import "package:logging/logging.dart";
import "package:riba/repositories/local/group.dart";
import "package:riba/repositories/local/user.dart";
import "package:riba/repositories/mangadex.dart";
import "package:riba/repositories/mangadex/models/general.dart";
import "package:riba/repositories/mangadex/models/group.dart";
import "package:riba/repositories/mangadex/utils/service.dart";
import "package:riba/repositories/runtime/group.dart";
import "package:riba/repositories/utils/enumerate.dart";
import "package:riba/repositories/utils/exception.dart";
import "package:riba/repositories/utils/rate_limiter.dart";
import "package:riba/utils/hash.dart";

class MangaDexGroupService extends MangaDexService<GroupAttributes, Group, GroupData, GroupData,
    MangaDexGenericQueryFilter> {
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
  late final baseUrl = rootUrl.copyWith(pathSegments: ["group"]);

  @override
  final defaultFilters = MangaDexGenericQueryFilter(
    includes: [EntityType.leader, EntityType.member],
  );

  @override
  MangaDexGroupService get instance => MangaDex.instance.group;

  @override
  @Deprecated("Will not be implemented, used as a stub for the interface.")
  Future<GroupData> get(String id, {bool checkDB = true}) => throw UnimplementedError();

  @override
  Future<Map<String, GroupData>> getMany({
    required MangaDexGenericQueryFilter overrides,
    bool checkDB = true,
  }) {
    // TODO: implement getMany
    throw UnimplementedError();
  }

  Future<Map<String, Group>> getWithSingleConstraint({
    required MangaDexGenericQueryFilter overrides,
    bool checkDB = true,
  }) async {
    logger.info("getMany($overrides, $checkDB)");

    assert(overrides.ids != null, "This method requires ids to be populated.");

    final ids = overrides.ids!;
    final filters = defaultFilters.copyWith(overrides);
    final Map<String, Group?> mapped = {for (final e in ids) e: null};

    if (checkDB) {
      final inDB = await database.groups.getAll(ids.map((e) => fastHash(e)).toList());
      for (final group in inDB) {
        if (group == null) continue;
        mapped[group.id] = group;
      }
    }

    final missing = mapped.entries.where((e) => e.value == null).map((e) => e.key).toList();
    if (missing.isEmpty) return mapped.cast();

    final block = Enumerate<String, Group>(
      perStep: 100,
      items: missing,
      onStep: (resolved) async {
        await rateLimiter.wait("/group:GET");
        final reqUrl = filters.addFiltersToUrl(baseUrl.copy());
        final request = await client.get(reqUrl.toUri());
        final response = GroupCollection.fromMap(jsonDecode(request.body), url: reqUrl);

        for (final data in response.data) {
          final groupData = data.toGroupData();
          insertMeta(groupData);
          resolved[data.id] = groupData.group;
        }
      },
      onMismatch: (missedIds) {
        logger.warning("Some entries were not in the response, ignoring them: $missedIds");
      },
    );

    mapped.addAll(await block.run());
    return mapped.cast();
  }

  @override
  Future<void> insertMeta(GroupData data) async {
    await database.writeTxn(() async {
      await Future.wait([
        database.users.putAll(data.users.values.toList()),
        database.groups.put(data.group),
      ]);
    });
  }

  /// Collects related data for a group to make a [GroupData] object.
  ///
  /// [Group.memberIds] should not be null, if it is, [IncompleteDataException] is thrown.
  @override
  Future<GroupData> collectMeta(Group single) async {
    if (single.memberIds == null) throw const IncompleteDataException("Group.memberIds is null");
    final users = await database.users.getAll(single.memberIds!.map((e) => fastHash(e)).toList());

    return GroupData(
      group: single,
      users: {for (final user in users as List<User>) user.id: user},
    );
  }
}
