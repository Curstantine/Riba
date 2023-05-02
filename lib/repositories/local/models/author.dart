// ignore_for_file: public_member_api_docs, sort_constructors_first
import "package:isar/isar.dart";
import "package:riba/utils/hash.dart";

import "localization.dart";

part "author.g.dart";

/// Author/Artist model to be stored in the local database.
///
/// ### Note
/// This model doesn't implement an eq operator, as it is impossible to do that
/// without losing performance. Instead, use the [isLooselyEqual] method.
@collection
class Author {
  late String id;
  Id get isarId => fastHash(id);

  late String name;
  late Localizations description;
  late AuthorSocial socials;
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

  /// Checks if the given [Author] has the same [id] and the [version] as this.
  bool isLooselyEqual(Author other) {
    return id == other.id && version == other.version;
  }

  @override
  // ignore: hash_and_equals
  operator ==(Object other) {
    throw UnimplementedError();
  }
}

@embedded
class AuthorSocial {
  late String? twitter;
  late String? pixiv;
  late String? melonBook;
  late String? fanBox;
  late String? booth;
  late String? nicoVideo;
  late String? skeb;
  late String? fantia;
  late String? tumblr;
  late String? youtube;
  late String? weibo;
  late String? naver;
  late String? website;

  AuthorSocial({
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
  });
}

extension FilterAuthors on List<Author> {
  List<Author> whereNotIn(List<Author> other) {
    return where((element) => !other.any((e) => e.isLooselyEqual(element))).toList();
  }
}
