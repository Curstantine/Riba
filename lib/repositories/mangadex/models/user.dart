import "package:json_annotation/json_annotation.dart";
import "package:riba/repositories/local/models/user.dart";
import "package:riba/repositories/mangadex/utils/serde_ext.dart";
import "package:riba/repositories/utils/exception.dart";

import "relationship.dart";

part "user.g.dart";

@JsonSerializable(createToJson: false)
class UserAttributes {
	final String username;
	final List<UserRole> roles;
	final int version;

	const UserAttributes({required this.username, required this.roles, required this.version});

	factory UserAttributes.fromJson(Map<String, dynamic> source) => _$UserAttributesFromJson(source);
}

// CAUTION: DO NOT CHANGE THE ORDER OF THE ENUM
@JsonEnum(alwaysCreate: true)
enum UserRole implements SerializableDataExt {
	@JsonValue("ROLE_BOT")
	bot,
	@JsonValue("ROLE_USER")
	user,
	@JsonValue("ROLE_MEMBER")
	member,
	@JsonValue("ROLE_GROUP_MEMBER")
	groupMember,
	@JsonValue("ROLE_GROUP_LEADER")
	groupLeader,
	@JsonValue("ROLE_MD_AT_HOME")
	mdAtHome,
	@JsonValue("ROLE_CONTRIBUTOR")
	contributor,
	@JsonValue("ROLE_SUPPORTER")
	supporter,
	@JsonValue("ROLE_POWER_UPLOADER")
	powerUploader,
	@JsonValue("ROLE_VIP")
	vip,
	@JsonValue("ROLE_STAFF")
	staff,
	@JsonValue("ROLE_PUBLIC_RELATIONS")
	publicRelations,
	@JsonValue("ROLE_FORUM_MODERATOR")
	forumModerator,
	@JsonValue("ROLE_GLOBAL_MODERATOR")
	globalModerator,
	@JsonValue("ROLE_DEVELOPER")
	developer,
	@JsonValue("ROLE_ADMIN")
	administrator;

	@override
	factory UserRole.fromJson(String source) => $enumDecode(_$UserRoleEnumMap, source);

	@override
	String toJson() => _$UserRoleEnumMap[this]!;

	@override
	String asHumanReadable() {
		switch (this) {
			case UserRole.bot:
				return "Bot";
			case UserRole.user:
				return "User";
			case UserRole.member:
				return "Member";
			case UserRole.groupMember:
				return "Group Member";
			case UserRole.groupLeader:
				return "Group Leader";
				
			case UserRole.mdAtHome:
				return "MD@Home";
			case UserRole.supporter:
				return "Supporter";	
			case UserRole.contributor:
				return "Contributor";
			case UserRole.powerUploader:
				return "Power Uploader";
			case UserRole.vip:
				return "VIP";
			case UserRole.staff:
				return "Staff";
			case UserRole.publicRelations:
				return "Public Relations";
			case UserRole.forumModerator:
				return "Forum Moderator";
			case UserRole.globalModerator:
				return "Global Moderator";
			case UserRole.developer:
				return "Developer";
			case UserRole.administrator:
				return "Administrator";
		}
	}
}

extension ToRelUser on Relationship<UserAttributes> {
	/// Converts self to a [User] object.
	///
	/// Might throw a [IncompleteDataException] if the attributes are null.
	User asUser() {
		if (attributes == null) throw const IncompleteDataException("Attributes are null");
		return User(
			id: id,
			username: attributes!.username,
			roles: attributes!.roles,
			version: attributes!.version,
		);
	}
}
