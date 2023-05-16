import "package:copy_with_extension/copy_with_extension.dart";
import "package:isar/isar.dart";
import "package:riba/repositories/local/models/cover_art.dart";
import "package:riba/settings/settings.dart";

part "persistence.g.dart";

@CopyWith()
@Collection(accessor: "coverPersistenceSettings")
class CoverPersistenceSettings {
	static final ref = Settings.instance.coverPersistenceSettings;
	static const isarKey = "coverPersistenceSettings";

	final Id id = Isar.autoIncrement;

	@Index(unique: true, replace: true)
	final String key = isarKey;

	final bool enabled;

	@Enumerated(EnumType.ordinal)
	final CoverSize previewSize;

	@Enumerated(EnumType.ordinal)
	final CoverSize fullSize;

	CoverPersistenceSettings({
		required this.enabled,
		required this.previewSize,
		required this.fullSize,
	});

	static final defaultSettings = CoverPersistenceSettings(
		enabled: true,
		previewSize: CoverSize.medium,
		fullSize: CoverSize.original,
	);
}

@CopyWith()
@Collection(accessor: "chapterPersistenceSettings")
class ChapterPersistenceSettings {
	static final ref = Settings.instance.chapterPersistenceSettings;
	static const isarKey = "chapterPersistenceSettings";

	final Id id = Isar.autoIncrement;

	@Index(unique: true, replace: true)
	final String key = isarKey;

	final bool enabled;

	ChapterPersistenceSettings({
		required this.enabled,
	});

	static final defaultSettings = ChapterPersistenceSettings(
		enabled: true,
	);
}
