import "package:isar/isar.dart";
import "package:riba/utils/hash.dart";

import "localization.dart";

part "group.g.dart";

@collection
class Group {
  late String id;
  Id get isarId => fastHash(id);

  late String name;
  late List<Localizations> altNames;
  late String? description;
  late GroupSocials socials;

  @Enumerated(EnumType.ordinal)
  late List<Language> focusedLanguages;
  late bool official;
  late bool inactive;

  late DateTime createdAt;
  late DateTime updatedAt;

  late int version;

  /// The [User.id] of the leader of this group.
  ///
  /// This could be null if the leader is not retrieved yet, or if a leader does not exist.
  late String? leaderId;

  /// The [User.id]s of the members of this group.
  ///
  /// Contains the leader as well.
  ///
  /// This could only be null if the members are not retrieved yet.
  late List<String>? memberIds;

  Group({
    required this.id,
    required this.name,
    required this.altNames,
    required this.description,
    required this.socials,
    required this.focusedLanguages,
    required this.official,
    required this.inactive,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
    this.leaderId,
    this.memberIds,
  });

  /// Checks if the given [CustomList] has the same [id] and the [version] as this.
  bool isLooselyEqual(Group other) {
    return id == other.id && version == other.version;
  }

  @override
  // ignore: hash_and_equals
  operator ==(Object other) {
    throw UnimplementedError();
  }
}

@embedded
class GroupSocials {
  late String? website;
  late String? discord;
  late String? ircServer;
  late String? ircChannel;
  late String? contactEmail;
  late String? twitter;
  late String? mangaUpdates;

  GroupSocials({
    this.website,
    this.discord,
    this.ircServer,
    this.ircChannel,
    this.contactEmail,
    this.twitter,
    this.mangaUpdates,
  });
}
