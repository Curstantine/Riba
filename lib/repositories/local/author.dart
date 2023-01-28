import "package:isar/isar.dart";
import "package:riba/repositories/local/localization.dart";
import "package:riba/repositories/mangadex/author.dart";
import "package:riba/utils/hash.dart";

part "author.g.dart";

@collection
class Author {
  late String id;
  Id get isarId => fastHash(id);

  late String name;
  late Localizations description;
  late List<AuthorSocial> socials;
  late DateTime createdAt;
  late int version;

  Author({
    required this.id,
    required this.name,
    required this.description,
    required this.socials,
    required this.createdAt,
    required this.version,
  });
}

@embedded
class AuthorSocial {
  @Enumerated(EnumType.ordinal)
  late AuthorSocialType type;
  late String value;

  AuthorSocial({this.type = AuthorSocialType.none, this.value = ""});

  @override
  operator ==(Object other) {
    if (other is AuthorSocial) {
      return type == other.type && value == other.value;
    }
    return false;
  }

  @override
  int get hashCode => type.hashCode ^ value.hashCode;
}

// CAUTION: DO NOT CHANGE THE ORDER OF THE ENUMS
enum AuthorSocialType {
  none,
  twitter,
  pixiv,
  melonBook,
  fanBox,
  booth,
  nicoVideo,
  skeb,
  fantia,
  tumblr,
  youtube,
  weibo,
  naver,
  website,
}

extension ToAuthorSocials on AuthorAttributes {
  List<AuthorSocial> toAuthorSocials() {
    return [
      if (twitter != null) AuthorSocial(type: AuthorSocialType.twitter, value: twitter!),
      if (pixiv != null) AuthorSocial(type: AuthorSocialType.pixiv, value: pixiv!),
      if (melonBook != null) AuthorSocial(type: AuthorSocialType.melonBook, value: melonBook!),
      if (fanBox != null) AuthorSocial(type: AuthorSocialType.fanBox, value: fanBox!),
      if (booth != null) AuthorSocial(type: AuthorSocialType.booth, value: booth!),
      if (nicoVideo != null) AuthorSocial(type: AuthorSocialType.nicoVideo, value: nicoVideo!),
      if (skeb != null) AuthorSocial(type: AuthorSocialType.skeb, value: skeb!),
      if (fantia != null) AuthorSocial(type: AuthorSocialType.fantia, value: fantia!),
      if (tumblr != null) AuthorSocial(type: AuthorSocialType.tumblr, value: tumblr!),
      if (youtube != null) AuthorSocial(type: AuthorSocialType.youtube, value: youtube!),
      if (weibo != null) AuthorSocial(type: AuthorSocialType.weibo, value: weibo!),
      if (naver != null) AuthorSocial(type: AuthorSocialType.naver, value: naver!),
      if (website != null) AuthorSocial(type: AuthorSocialType.website, value: website!),
    ];
  }
}
