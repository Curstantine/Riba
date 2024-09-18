// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GroupAttributes _$GroupAttributesFromJson(Map<String, dynamic> json) =>
    GroupAttributes(
      name: json['name'] as String,
      altNames: (json['altNames'] as List<dynamic>)
          .map((e) => Map<String, String>.from(e as Map))
          .toList(),
      description: json['description'] as String?,
      website: json['website'] as String?,
      discord: json['discord'] as String?,
      ircServer: json['ircServer'] as String?,
      ircChannel: json['ircChannel'] as String?,
      contactEmail: json['contactEmail'] as String?,
      twitter: json['twitter'] as String?,
      mangaUpdates: json['mangaUpdates'] as String?,
      focusedLanguages: (json['focusedLanguages'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      official: json['official'] as bool,
      inactive: json['inactive'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      version: (json['version'] as num).toInt(),
    );
