import "package:json_annotation/json_annotation.dart";
import "package:riba/repositories/local/models/author.dart";
import "package:riba/repositories/local/models/localization.dart";

import "general.dart";
import "relationship.dart";

part "author.g.dart";

typedef AuthorEntity = MDEntityResponse<AuthorAttributes>;
typedef AuthorCollection = MDCollectionResponse<AuthorAttributes>;

@JsonSerializable(createToJson: false)
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

	factory AuthorAttributes.fromJson(Map<String, dynamic> json) => _$AuthorAttributesFromJson(json);
}

extension ToAuthorSocials on AuthorAttributes {
	AuthorSocial toAuthorSocials() {
		return AuthorSocial(
			twitter: twitter,
			pixiv: pixiv,
			melonBook: melonBook,
			fanBox: fanBox,
			booth: booth,
			nicoVideo: nicoVideo,
			skeb: skeb,
			fantia: fantia,
			tumblr: tumblr,
			youtube: youtube,
			weibo: weibo,
			naver: naver,
			website: website,
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
