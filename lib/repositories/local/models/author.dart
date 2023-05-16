import "package:isar/isar.dart";
import "package:riba/utils/hash.dart";

import "localization.dart";

part "author.g.dart";

@collection
class Author {
	final String id;
	Id get isarId => fastHash(id);

	final String name;
	final Localizations description;
	final AuthorSocial socials;
	final DateTime createdAt;
	final int version;

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
		return where((x) => !other.any((e) => x.id == e.id && x.version == e.version)).toList();
	}
}
