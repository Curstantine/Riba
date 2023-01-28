import "package:riba/repositories/local/author.dart";
import "package:riba/repositories/local/localization.dart";
import "package:riba/repositories/mangadex/general.dart";

import "relationship.dart";

class AuthorAttributes {
  final String name;
  final Map<String, String> biography;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? twitter;
  final String? pixiv;
  final String? melonBook;
  final String? fanBox;
  final String? booth;
  final String? nicoVideo;
  final String? skeb;
  final String? fantia;
  final String? tumblr;
  final String? youtube;
  final String? weibo;
  final String? naver;
  final String? website;
  final int version;

  const AuthorAttributes({
    required this.name,
    required this.biography,
    required this.createdAt,
    required this.updatedAt,
    this.twitter,
    this.pixiv,
    this.melonBook,
    this.fanBox,
    this.booth,
    this.nicoVideo,
    this.skeb,
    this.fantia,
    this.tumblr,
    this.youtube,
    this.weibo,
    this.naver,
    this.website,
    required this.version,
  });

  factory AuthorAttributes.fromMap(Map<String, dynamic> map) {
    return AuthorAttributes(
      name: map["name"] as String,
      biography: (map["biography"] as Map<String, dynamic>).cast(),
      createdAt: DateTime.parse(map["createdAt"] as String),
      updatedAt: DateTime.parse(map["updatedAt"] as String),
      twitter: map["twitter"] as String?,
      pixiv: map["pixiv"] as String?,
      melonBook: map["melonBook"] as String?,
      fanBox: map["fanBox"] as String?,
      booth: map["booth"] as String?,
      nicoVideo: map["nicoVideo"] as String?,
      skeb: map["skeb"] as String?,
      fantia: map["fantia"] as String?,
      tumblr: map["tumblr"] as String?,
      youtube: map["youtube"] as String?,
      weibo: map["weibo"] as String?,
      naver: map["naver"] as String?,
      website: map["website"] as String?,
      version: map["version"] as int,
    );
  }
}

extension ToAuthor on MDResponseData<AuthorAttributes> {
  Author toAuthor() => Author(
        id: id,
        name: attributes.name,
        description: Localizations.fromMap(attributes.biography),
        socials: attributes.toAuthorSocials(),
        createdAt: attributes.createdAt,
        version: attributes.version,
      );
}

extension ToRelAuthor on Relationship<AuthorAttributes> {
  Author toAuthor() {
    if (attributes == null) throw Exception("Attributes is null");

    return Author(
      id: id,
      name: attributes!.name,
      description: Localizations.fromMap(attributes!.biography),
      socials: attributes!.toAuthorSocials(),
      createdAt: attributes!.createdAt,
      version: attributes!.version,
    );
  }
}
