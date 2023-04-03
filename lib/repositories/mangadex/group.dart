import "dart:convert";

import "package:http/http.dart";
import "package:isar/isar.dart";
import "package:logging/logging.dart";
import "package:riba/repositories/local/group.dart";
import "package:riba/repositories/local/user.dart";
import "package:riba/repositories/mangadex.dart";
import "package:riba/repositories/runtime/group.dart";
import "package:riba/repositories/utils/enumerate.dart";
import "package:riba/repositories/utils/exception.dart";
import "package:riba/repositories/utils/rate_limiter.dart";
import "package:riba/utils/hash.dart";

class MDGroupRepo {
  final Client client;
  final RateLimiter rateLimiter;
  final Isar database;
  final logger = Logger("MDChapterRepo");

  MDGroupRepo(this.client, this.rateLimiter, this.database) {
    rateLimiter.rates["/group:GET"] = const Rate(4, Duration(seconds: 1));
  }

  final url = MangaDex.url.copyWith(pathSegments: ["group"]);
  final includes = [
    EntityType.leader.toJsonValue(),
    EntityType.member.toJsonValue(),
  ];

  Future<Map<String, Group>> getSimpleMany(List<String> ids, {bool checkDB = true}) async {
    logger.info("getMany($ids, $checkDB)");

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
        final reqUrl = url
            .copy()
            .setParameter("ids[]", resolved.keys.toList())
            .setParameter("includes[]", includes)
            .setParameter("limit", 100);
        final request = await client.get(reqUrl.toUri());
        final response = MDGroupCollection.fromMap(jsonDecode(request.body), url: reqUrl);

        for (final data in response.data) {
          final groupData = data.toGroupData();
          _insertMeta(groupData);
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

  Future<void> _insertMeta(GroupData groupData) async {
    await database.writeTxn(() async {
      await Future.wait([
        database.users.putAll(groupData.users.values.toList()),
        database.groups.put(groupData.group),
      ]);
    });
  }

  /// Collects related data for a group to make a [GroupData] object.
  ///
  /// [Group.memberIds] should not be null, if it is, [IncompleteDataException] is thrown.
  Future<GroupData> _collectMeta(Group group) async {
    if (group.memberIds == null) throw const IncompleteDataException("Group.memberIds is null");
    final users = await database.users.getAll(group.memberIds!.map((e) => fastHash(e)).toList());

    return GroupData(
      group: group,
      users: {for (final user in users as List<User>) user.id: user},
    );
  }
}
