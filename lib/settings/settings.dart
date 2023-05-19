import "package:isar/isar.dart";

import "appearance.dart";
import "content_filters.dart";
import "manga_filter.dart";
import "persistence.dart";

typedef I<T> = IsarCollection<T>;

class Settings {
	static late final Settings instance;
	Settings._internal({required Isar database}) : _database = database;

	final Isar _database;

	I<ContentFilterSettings> get contentFilterSettings => _database.contentFilterSettings;
	I<CoverPersistenceSettings> get coverPersistenceSettings => _database.coverPersistenceSettings;
	I<ChapterPersistenceSettings> get chapterPersistenceSettings => _database.chapterPersistenceSettings;
	I<MangaFilterSettings> get mangaFilterSettings => _database.mangaFilterSettings;
	I<AppearanceSettings> get themeSettings => _database.appearanceSettings;

	static Future<void> init(Isar database) async {
		final locals = await Future.wait([
			database.contentFilterSettings.getByKey(ContentFilterSettings.isarKey),
			database.coverPersistenceSettings.getByKey(CoverPersistenceSettings.isarKey),
			database.chapterPersistenceSettings.getByKey(ChapterPersistenceSettings.isarKey),
			database.appearanceSettings.getByKey(AppearanceSettings.isarKey),  
		]);

		final localContentFilterSettings = locals[0];
		final localCoverPersistenceSettings = locals[1];
		final localChapterPersistenceSettings = locals[2];
		final localAppearanceSettings = locals[3];

		await database.writeTxn(() => Future.wait([
			if (localContentFilterSettings == null)
				database.contentFilterSettings.put(ContentFilterSettings.defaultSettings),
			if (localCoverPersistenceSettings == null)
				database.coverPersistenceSettings.put(CoverPersistenceSettings.defaultSettings),
			if (localChapterPersistenceSettings == null)
				database.chapterPersistenceSettings.put(ChapterPersistenceSettings.defaultSettings),
			if (localAppearanceSettings == null)
				database.appearanceSettings.put(AppearanceSettings.defaultSettings),
		]));

		/// Run migrations and default initializations here.
		instance = Settings._internal(database: database);
	}
}
