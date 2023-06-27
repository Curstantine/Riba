import "package:copy_with_extension/copy_with_extension.dart";
import "package:riba/repositories/local/models/author.dart";
import "package:riba/repositories/local/models/cover_art.dart";
import "package:riba/repositories/local/models/manga.dart";
import "package:riba/repositories/local/models/tag.dart";

part "manga.g.dart";

@CopyWith()
class MangaData {
	final Manga manga;
	final CoverArt? cover;
	final List<Author> authors;
	final List<Author> artists;
	final List<Tag> tags;

	const MangaData({
		required this.manga,
		required this.cover,
		required this.authors,
		required this.artists,
		required this.tags,
	});
}

class InternalMangaData {
	final Manga manga;
	final List<CoverArt> covers;
	final List<Author> authors;
	final List<Author> artists;
	final List<Tag> tags;

	const InternalMangaData({
		required this.manga,
		required this.covers,
		required this.authors,
		required this.artists,
		required this.tags,
	});

	MangaData toMangaData() {
		return MangaData(
			manga: manga,
			authors: authors,
			artists: artists,
			tags: tags,
			cover: covers.firstWhere(
				(e) => e.id == (manga.preferredCoverId ?? manga.defaultCoverId),
				orElse: () => covers.first,
			),
		);
	}
}
