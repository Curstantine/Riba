import "package:riba/repositories/mangadex/general.dart";

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

enum UserRole {
  member,
  groupMember,
  groupLeader,
  powerUploader,
  forumModerator,
  globalModerator,
  administrator;

  static Map<String, UserRole> get jsonValues => {
        "ROLE_MEMBER": UserRole.member,
        "ROLE_GROUP_MEMBER": UserRole.groupMember,
        "ROLE_GROUP_LEADER": UserRole.groupLeader,
        "ROLE_POWER_UPLOADER": UserRole.powerUploader,
        "ROLE_FORUM_MODERATOR": UserRole.forumModerator,
        "ROLE_GLOBAL_MODERATOR": UserRole.globalModerator,
        "ROLE_ADMIN": UserRole.administrator,
      };

  static UserRole fromJsonValue(String value) {
    return jsonValues[value]!;
  }
}
