import "package:isar/isar.dart";
import "package:riba/utils/hash.dart";

import "localization.dart";

part "group.g.dart";

@collection
class Group {
	final String id;
	Id get isarId => fastHash(id);

	final String name;
	final List<Localizations> altNames;
	final String? description;
	final GroupSocials socials;

	@Enumerated(EnumType.ordinal)
	final List<Language> focusedLanguages;
	final bool official;
	final bool inactive;

	final DateTime createdAt;
	final DateTime updatedAt;

	final int version;

	/// The [User.id] of the leader of this group.
	///
	/// This could be null if the leader is not retrieved yet, or if a leader does not exist.
	final String? leaderId;

	/// The [User.id]s of the members of this group.
	///
	/// Contains the leader as well.
	///
	/// This could only be null if the members are not retrieved yet.
	final List<String>? memberIds;

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
}

@embedded
class GroupSocials {
	final String? website;
	final String? discord;
	final String? ircServer;
	final String? ircChannel;
	final String? contactEmail;
	final String? twitter;
	final String? mangaUpdates;

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
