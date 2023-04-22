import "package:isar/isar.dart";
import "package:riba/repositories/local/models/cover_art.dart";
import "package:riba/settings/settings.dart";

part "cache.g.dart";

@Collection(accessor: "coverPersistenceSettings")
class CoverPersistenceSettings {
	static final ref = Settings.instance.coverPersistenceSettings;
	static const isarKey = "coverPersistenceSettings";

	final Id id = Isar.autoIncrement;

	@Index(unique: true, replace: true)
	final String key = isarKey;

	late bool enabled;

	@Enumerated(EnumType.ordinal)
	late CoverSize previewSize;

	@Enumerated(EnumType.ordinal)
	late CoverSize fullSize;

	CoverPersistenceSettings({
		required this.enabled,
		required this.previewSize,
		required this.fullSize,
	});

	CoverPersistenceSettings copyWith({
		bool? enabled,
		CoverSize? previewSize,
		CoverSize? fullSize,
	}) {
		return CoverPersistenceSettings(
			enabled: enabled ?? this.enabled,
			previewSize: previewSize ?? this.previewSize,
			fullSize: fullSize ?? this.fullSize,
		);
	}

	static final defaultSettings = CoverPersistenceSettings(
		enabled: true,
		previewSize: CoverSize.medium,
		fullSize: CoverSize.original,
	);
}

@Collection(accessor: "chapterPersistenceSettings")
class ChapterPersistenceSettings {
	static final ref = Settings.instance.chapterPersistenceSettings;
	static const isarKey = "chapterPersistenceSettings";

	final Id id = Isar.autoIncrement;

	@Index(unique: true, replace: true)
	final String key = isarKey;

	late bool enabled;

	ChapterPersistenceSettings({
		required this.enabled,
	});

	ChapterPersistenceSettings copyWith({
		bool? enabled,
	}) {
		return ChapterPersistenceSettings(
			enabled: enabled ?? this.enabled,
		);
	}

	static final defaultSettings = ChapterPersistenceSettings(
		enabled: true,
	);
}
