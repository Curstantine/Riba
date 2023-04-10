import "package:json_annotation/json_annotation.dart";
import "package:riba/repositories/local/group.dart";
import "package:riba/repositories/local/localization.dart";
import "package:riba/repositories/local/user.dart";
import "package:riba/repositories/runtime/group.dart";

import "general.dart";
import "relationship.dart";
import "user.dart";

part "group.g.dart";

typedef GroupCollection = MDCollectionResponse<GroupAttributes>;

@JsonSerializable(createToJson: false)
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

  factory GroupAttributes.fromJson(Map<String, dynamic> source) =>
      _$GroupAttributesFromJson(source);
}

extension ToGroup on MDResponseData<GroupAttributes> {
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
    final users = relationships.ofType<UserAttributes>(EntityType.member).map((e) => e.asUser());

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
