import "package:isar/isar.dart";
import "package:riba/repositories/local/models/author.dart";
import "package:riba/repositories/local/models/chapter.dart";
import "package:riba/repositories/local/models/chapter_local_meta.dart";
import "package:riba/repositories/local/models/cover_art.dart";
import "package:riba/repositories/local/models/custom_list.dart";
import "package:riba/repositories/local/models/group.dart";
import "package:riba/repositories/local/models/manga.dart";
import "package:riba/repositories/local/models/statistics.dart";
import "package:riba/repositories/local/models/tag.dart";
import "package:riba/repositories/local/models/user.dart";
import "package:riba/repositories/mangadex/mangadex.dart";
import "package:riba/settings/content_filters.dart";
import "package:riba/settings/manga_filter.dart";
import "package:riba/settings/persistence.dart";
import "package:riba/settings/settings.dart";
import "package:riba/settings/theme.dart";
import "package:riba/utils/directories.dart";

/// Database instance used throughout the app.
/// 
/// Wraps an [Isar] instance that stores all local data, regardless of the source.
/// 
/// - [MangaDex] service uses this instance to store data.
/// - [Settings] uses this instance to persist user settings.
class Database {
	static late final Database instance;
	Database._internal({required this.local});

	final Isar local;

	static Future<Database> init({bool testing = false}) async {
		instance = Database._internal(
			local: await Isar.open(
				schemas,
				directory: InitDirectories.instance.supportDir.path,
			),
		);

		await Future.wait([
			MangaDex.init(instance.local),
			Settings.init(instance.local),
		]);

		return instance;
	}


	static const schemas = [
		// Local models
		MangaSchema,
		AuthorSchema,
		CoverArtSchema,
		TagSchema,
		CustomListSchema,
		UserSchema,
		StatisticsSchema,
		GroupSchema,
		ChapterLocalMetaSchema,
		ChapterSchema,
		// Settings related models
		ContentFilterSettingsSchema,
		CoverPersistenceSettingsSchema,
		ChapterPersistenceSettingsSchema,
		MangaFilterSettingsSchema,
		ThemeSettingsSchema,
	];
}
