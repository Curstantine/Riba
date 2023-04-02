import "dart:convert";

import "package:http/http.dart";
import "package:isar/isar.dart";
import "package:logging/logging.dart";
import 'package:riba/repositories/utils/enumerate.dart';
import 'package:riba/repositories/utils/exception.dart';
import "package:riba/repositories/local/group.dart";
import "package:riba/repositories/local/localization.dart";
import "package:riba/repositories/local/user.dart";
import 'package:riba/repositories/mangadex.dart';
import 'package:riba/repositories/utils/rate_limiter.dart';
import "package:riba/repositories/runtime/group.dart";
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

class GroupAttributes {
  final String name;
  final List<Map<String, String>> altNames;
  final String? description;

  final String? website;
  final String? discord;
  final String? ircServer;
  final String? ircChannel;
  final String? contactEmail;
  final String? twitter;
  final String? mangaUpdates;

  final List<String> focusedLanguages;
  final bool official;
  final bool inactive;

  // TODO: Somehow parse this ISO8601 interval as a Duration
  // final Duration publishDelay;
  final DateTime createdAt;
  final DateTime updatedAt;

  final int version;

  const GroupAttributes({
    required this.name,
    required this.altNames,
    required this.description,
    required this.website,
    required this.discord,
    required this.ircServer,
    required this.ircChannel,
    required this.contactEmail,
    required this.twitter,
    required this.mangaUpdates,
    required this.focusedLanguages,
    required this.official,
    required this.inactive,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
  });

  factory GroupAttributes.fromMap(Map<String, dynamic> map) {
    return GroupAttributes(
      name: map["name"] as String,
      altNames: (map["altNames"] as List)
          .map((e) => (e as Map<String, dynamic>).cast<String, String>())
          .toList(),
      description: map["description"] as String?,
      website: map["website"] as String?,
      discord: map["discord"] as String?,
      ircServer: map["ircServer"] as String?,
      ircChannel: map["ircChannel"] as String?,
      contactEmail: map["contactEmail"] as String?,
      twitter: map["twitter"] as String?,
      mangaUpdates: map["mangaUpdates"] as String?,
      focusedLanguages: (map["focusedLanguages"] as List).cast(),
      official: map["official"] as bool,
      inactive: map["inactive"] as bool,
      createdAt: DateTime.parse(map["createdAt"] as String),
      updatedAt: DateTime.parse(map["updatedAt"] as String),
      version: map["version"] as int,
    );
  }

  factory GroupAttributes.fromJson(String source) =>
      GroupAttributes.fromMap(json.decode(source) as Map<String, dynamic>);
}

extension on MDResponseData<GroupAttributes> {
  Group toGroup() {
    final leaderId = relationships.ofType(EntityType.leader);
    final memberIds = relationships.ofType(EntityType.member);

    return Group(
      id: id,
      altNames: attributes.altNames.map((e) => Localizations.fromMap(e)).toList(),
      name: attributes.name,
      description: attributes.description,
      createdAt: attributes.createdAt,
      updatedAt: attributes.updatedAt,
      focusedLanguages: attributes.focusedLanguages.map((e) => Language.fromIsoCode(e)).toList(),
      inactive: attributes.inactive,
      official: attributes.official,
      socials: GroupSocials(
        website: attributes.website,
        discord: attributes.discord,
        ircServer: attributes.ircServer,
        ircChannel: attributes.ircChannel,
        contactEmail: attributes.contactEmail,
        twitter: attributes.twitter,
        mangaUpdates: attributes.mangaUpdates,
      ),
      version: attributes.version,
      leaderId: leaderId.isEmpty ? null : leaderId.first.id,
      memberIds: memberIds.map((e) => e.id).toList(),
    );
  }

  GroupData toGroupData() {
    final users = relationships.ofType<UserAttributes>(EntityType.member).map((e) => e.toUser());

    return GroupData(
      group: toGroup(),
      users: <String, User>{for (final user in users) user.id: user},
    );
  }
}

extension ToRelGroup on Relationship<GroupAttributes> {
  Group toGroup() {
    if (attributes == null) throw Exception("Attributes are null");

    return Group(
      id: id,
      altNames: attributes!.altNames.map((e) => Localizations.fromMap(e)).toList(),
      name: attributes!.name,
      description: attributes!.description,
      createdAt: attributes!.createdAt,
      updatedAt: attributes!.updatedAt,
      focusedLanguages: attributes!.focusedLanguages.map((e) => Language.fromIsoCode(e)).toList(),
      inactive: attributes!.inactive,
      official: attributes!.official,
      socials: GroupSocials(
        website: attributes!.website,
        discord: attributes!.discord,
        ircServer: attributes!.ircServer,
        ircChannel: attributes!.ircChannel,
        contactEmail: attributes!.contactEmail,
        twitter: attributes!.twitter,
        mangaUpdates: attributes!.mangaUpdates,
      ),
      version: attributes!.version,
    );
  }
}
