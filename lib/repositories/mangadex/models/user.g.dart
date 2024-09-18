// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserAttributes _$UserAttributesFromJson(Map<String, dynamic> json) =>
    UserAttributes(
      username: json['username'] as String,
      roles: (json['roles'] as List<dynamic>)
          .map((e) => UserRole.fromJson(e as String))
          .toList(),
      version: (json['version'] as num).toInt(),
    );

const _$UserRoleEnumMap = {
  UserRole.bot: 'ROLE_BOT',
  UserRole.user: 'ROLE_USER',
  UserRole.member: 'ROLE_MEMBER',
  UserRole.groupMember: 'ROLE_GROUP_MEMBER',
  UserRole.groupLeader: 'ROLE_GROUP_LEADER',
  UserRole.mdAtHome: 'ROLE_MD_AT_HOME',
  UserRole.contributor: 'ROLE_CONTRIBUTOR',
  UserRole.supporter: 'ROLE_SUPPORTER',
  UserRole.powerUploader: 'ROLE_POWER_UPLOADER',
  UserRole.vip: 'ROLE_VIP',
  UserRole.staff: 'ROLE_STAFF',
  UserRole.publicRelations: 'ROLE_PUBLIC_RELATIONS',
  UserRole.forumModerator: 'ROLE_FORUM_MODERATOR',
  UserRole.globalModerator: 'ROLE_GLOBAL_MODERATOR',
  UserRole.developer: 'ROLE_DEVELOPER',
  UserRole.administrator: 'ROLE_ADMIN',
};
