import "package:isar/isar.dart";
import "package:riba/repositories/local/models/localization.dart";
import "package:riba/repositories/mangadex/models/manga.dart";
import "package:riba/settings/settings.dart";

part "content_filters.g.dart";

@Collection(accessor: "contentFilterSettings")
class ContentFilterSettings {
	static final ref = Settings.instance.contentFilterSettings;
	static const isarKey = "contentFilterSettings";

	final Id id = Isar.autoIncrement;

	@Index(unique: true, replace: true)
	final String key = isarKey;

	@Enumerated(EnumType.ordinal)
	late List<Language> originalLanguages;
	
	@Enumerated(EnumType.ordinal)
	late List<Language> chapterLanguages;

	@Enumerated(EnumType.ordinal)
	late List<ContentRating> contentRatings;

	ContentFilterSettings({
		required this.originalLanguages,
		required this.chapterLanguages,
		required this.contentRatings,
	});

	

	ContentFilterSettings copyWith({
		List<Language>? originalLanguages,
		List<Language>? chapterLanguages,
		List<ContentRating>? contentRatings,
	}) {
		return ContentFilterSettings(
			originalLanguages: originalLanguages ?? this.originalLanguages,
			chapterLanguages: chapterLanguages ?? this.chapterLanguages,
			contentRatings: contentRatings ?? this.contentRatings,
		);
	}

	static final defaultSettings = ContentFilterSettings(
		originalLanguages: Language.values.toList(),
		chapterLanguages: Language.values.toList(),
		contentRatings: [
			ContentRating.safe,
			ContentRating.suggestive,
			ContentRating.erotica,
		],
	);
}
