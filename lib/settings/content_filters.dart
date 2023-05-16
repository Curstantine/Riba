import "package:copy_with_extension/copy_with_extension.dart";
import "package:isar/isar.dart";
import "package:riba/repositories/local/models/localization.dart";
import "package:riba/repositories/mangadex/models/manga.dart";

import "settings.dart";

part "content_filters.g.dart";

@CopyWith()
@Collection(accessor: "contentFilterSettings")
class ContentFilterSettings {
	static final ref = Settings.instance.contentFilterSettings;
	static const isarKey = "contentFilterSettings";

	final Id id = Isar.autoIncrement;

	@Index(unique: true, replace: true)
	final String key = isarKey;

	@Enumerated(EnumType.ordinal)
	final List<Language> originalLanguages;
	
	@Enumerated(EnumType.ordinal)
	final List<Language> chapterLanguages;

	@Enumerated(EnumType.ordinal)
	final List<ContentRating> contentRatings;

	ContentFilterSettings({
		required this.originalLanguages,
		required this.chapterLanguages,
		required this.contentRatings,
	});

	static final defaultSettings = ContentFilterSettings(
		originalLanguages: [],
		chapterLanguages: [],
		contentRatings: [
			ContentRating.safe,
			ContentRating.suggestive,
			ContentRating.erotica,
		],
	);
}
