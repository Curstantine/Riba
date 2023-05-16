import "package:copy_with_extension/copy_with_extension.dart";
import "package:isar/isar.dart";
import "package:riba/repositories/mangadex/models/manga.dart";
import "package:riba/utils/hash.dart";

import "localization.dart";

part "manga.g.dart";

@CopyWith()
@Collection(accessor: "manga")
class Manga {
	final String id;
	Id get isarId => fastHash(id);

	final Localizations titles;
	final Localizations description;
	final List<Localizations> altTitles;

	@Index(type: IndexType.hashElements)
	final List<String> authorIds;

	@Index(type: IndexType.hashElements)
	final List<String> artistIds;

	@Index(type: IndexType.hashElements)
	final List<String> tagsIds;

	/// The cover id defaulted by the provider.
	final String? defaultCoverId;

	/// The cover id preferred by the user.
	final String? preferredCoverId;

	final int version;

	@Enumerated(EnumType.ordinal)
	final Language originalLanguage;

	@Enumerated(EnumType.ordinal)
	final MangaStatus status;

	@Enumerated(EnumType.ordinal)
	final MangaPublicationDemographic publicationDemographic;

	@Enumerated(EnumType.ordinal)
	final ContentRating contentRating;

	Manga({
		required this.id,
		required this.titles,
		required this.description,
		required this.altTitles,
		required this.authorIds,
		required this.artistIds,
		required this.tagsIds,
		required this.defaultCoverId,
		required this.preferredCoverId,
		required this.originalLanguage,
		required this.version,
		required this.status,
		required this.publicationDemographic,
		required this.contentRating,
	});
}
