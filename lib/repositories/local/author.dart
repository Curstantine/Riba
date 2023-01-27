import "package:isar/isar.dart";
import "package:riba/repositories/local/localization.dart";
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
    required this.createdAt,
    required this.version,
  });
}

@embedded
class AuthorSocial {
  @Enumerated(EnumType.ordinal)
  late AuthorSocialType type;
  late String value;

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

enum AuthorSocialType {
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
