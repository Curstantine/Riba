import "package:riba/repositories/local/user.dart";
import "package:riba/repositories/mangadex/general.dart";
import "package:riba/repositories/mangadex/relationship.dart";

typedef MDUserEntity = MDEntityResponse<UserAttributes>;
typedef MDUserCollection = MDCollectionResponse<UserAttributes>;

class UserAttributes {
  final String username;
  final List<UserRole> roles;
  final int version;

  const UserAttributes({required this.username, required this.roles, required this.version});

  factory UserAttributes.fromMap(Map<String, dynamic> map) {
    return UserAttributes(
      username: map["username"] as String,
      version: map["version"] as int,
      roles:
          (map["roles"] as List<dynamic>).map((e) => UserRole.fromJsonValue(e as String)).toList(),
    );
  }
}

// CAUTION: DO NOT CHANGE THE ORDER OF THE ENUM
enum UserRole {
  member,
  groupMember,
  groupLeader,
  mdAtHome,
  contributor,
  powerUploader,
  staff,
  forumModerator,
  globalModerator,
  developer,
  administrator;

  static Map<String, UserRole> get jsonValues => {
        "ROLE_MEMBER": UserRole.member,
        "ROLE_GROUP_MEMBER": UserRole.groupMember,
        "ROLE_GROUP_LEADER": UserRole.groupLeader,
        "ROLE_MD_AT_HOME": UserRole.mdAtHome,
        "ROLE_CONTRIBUTOR": UserRole.contributor,
        "ROLE_POWER_UPLOADER": UserRole.powerUploader,
        "ROLE_STAFF": UserRole.staff,
        "ROLE_FORUM_MODERATOR": UserRole.forumModerator,
        "ROLE_GLOBAL_MODERATOR": UserRole.globalModerator,
        "ROLE_DEVELOPER": UserRole.developer,
        "ROLE_ADMIN": UserRole.administrator,
      };

  static UserRole fromJsonValue(String value) {
    return jsonValues[value]!;
  }
}

extension ToRelUser on Relationship<UserAttributes> {
  User toUser() {
    if (attributes == null) throw Exception("Attributes are null");
    return User(
      id: id,
      username: attributes!.username,
      roles: attributes!.roles,
      version: attributes!.version,
    );
  }
}
