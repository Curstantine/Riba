import "package:copy_with_extension/copy_with_extension.dart";
import "package:isar/isar.dart";
import "package:riba/repositories/local/models/localization.dart";
import "package:riba/repositories/mangadex/models/manga.dart";

part "store.g.dart";

@CopyWith()
@Collection(accessor: "contentFilterSettings")
class ContentFilterSettingsStore {
	final Id id = 1;

	@Enumerated(EnumType.ordinal)
	final List<Language> originalLanguages;
	
	@Enumerated(EnumType.ordinal)
	final List<Language> chapterLanguages;

	@Enumerated(EnumType.ordinal)
	final List<ContentRating> contentRatings;

	ContentFilterSettingsStore({
		required this.originalLanguages,
		required this.chapterLanguages,
		required this.contentRatings,
	});

	static final defaultSettings = ContentFilterSettingsStore(
		originalLanguages: [],
		chapterLanguages: [],
		contentRatings: [
			ContentRating.safe,
			ContentRating.suggestive,
			ContentRating.erotica,
		],
	);
}
