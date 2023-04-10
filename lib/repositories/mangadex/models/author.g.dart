// GENERATED CODE - DO NOT MODIFY BY HAND

part of "author.dart";

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthorAttributes _$AuthorAttributesFromJson(Map<String, dynamic> json) =>
    AuthorAttributes(
      name: json["name"] as String,
      biography: Map<String, String>.from(json["biography"] as Map),
      createdAt: DateTime.parse(json["createdAt"] as String),
      updatedAt: DateTime.parse(json["updatedAt"] as String),
      twitter: json["twitter"] as String?,
      pixiv: json["pixiv"] as String?,
      melonBook: json["melonBook"] as String?,
      fanBox: json["fanBox"] as String?,
      booth: json["booth"] as String?,
      nicoVideo: json["nicoVideo"] as String?,
      skeb: json["skeb"] as String?,
      fantia: json["fantia"] as String?,
      tumblr: json["tumblr"] as String?,
      youtube: json["youtube"] as String?,
      weibo: json["weibo"] as String?,
      naver: json["naver"] as String?,
      website: json["website"] as String?,
      version: json["version"] as int,
    );
