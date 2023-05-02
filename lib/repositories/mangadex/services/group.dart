import "dart:convert";
import "dart:io";

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
  Directory get cacheDir => throw UnimplementedError();

  @override
  Directory get dataDir => throw UnimplementedError();

  @override
  late final baseUrl = rootUrl.copyWith(pathSegments: ["group"]);

  @override
  final defaultFilters = MangaDexGenericQueryFilter(
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
  Future<CollectionData<GroupData>> withFilters({required overrides}) {
    // TODO: implement withFilters
    throw UnimplementedError();
  }

  Future<Map<String, Group>> getManyAsSingle({
    required MangaDexGenericQueryFilter overrides,
    bool checkDB = true,
  }) async {
    logger.info("getManyAsSingle($overrides, $checkDB)");

    assert(overrides.ids != null, "This method requires ids to be populated.");
    assert(overrides.offset != 0, "This method does not support pagination, offset must be 0");

    final ids = overrides.ids!;
    final filters = defaultFilters.copyWith(overrides);
    final Map<String, Group?> mapped = {for (final e in ids) e: null};

    if (checkDB) {
      final inDB = await database.getAll(ids.map(fastHash).toList());
      for (final group in inDB) {
        if (group == null) continue;
        mapped[group.id] = group;
      }
    }

    final missing = mapped.entries.where((e) => e.value == null).map((e) => e.key).toList();
    if (missing.isEmpty) return mapped.cast<String, Group>();

    final block = Enumerate<String, GroupData>(
      perStep: 100,
      items: missing,
      onStep: (resolved) async {
        await rateLimiter.wait("/group:GET");
        final reqUrl = filters.addFiltersToUrl(baseUrl.copy());
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
    final users =
        await database.isar.users.getAll(single.memberIds!.map((e) => fastHash(e)).toList());

    return GroupData(
      group: single,
      users: {for (final user in users as List<User>) user.id: user},
    );
  }
}
