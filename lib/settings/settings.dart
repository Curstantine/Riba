import "package:isar/isar.dart";

import "content_filters.dart";
import "manga_filter.dart";
import "persistence.dart";
import "theme.dart";

typedef I<T> = IsarCollection<T>;

class Settings {
	static late final Settings instance;
	Settings._internal({required Isar database}) : _database = database;

	final Isar _database;

	I<ContentFilterSettings> get contentFilterSettings => _database.contentFilterSettings;
	I<CoverPersistenceSettings> get coverPersistenceSettings => _database.coverPersistenceSettings;
	I<ChapterPersistenceSettings> get chapterPersistenceSettings => _database.chapterPersistenceSettings;
	I<MangaFilterSettings> get mangaFilterSettings => _database.mangaFilterSettings;
	I<ThemeSettings> get themeSettings => _database.themeSettings;

	static Future<void> init(Isar database) async {
		final locals = await Future.wait([
			database.contentFilterSettings.getByKey(ContentFilterSettings.isarKey),
			database.coverPersistenceSettings.getByKey(CoverPersistenceSettings.isarKey),
			database.chapterPersistenceSettings.getByKey(ChapterPersistenceSettings.isarKey),
			database.themeSettings.getByKey(ThemeSettings.isarKey),  
		]);

		final localContentFilterSettings = locals[0];
		final localCoverPersistenceSettings = locals[1];
		final localChapterPersistenceSettings = locals[2];
		final localThemeSettings = locals[3];

		await database.writeTxn(() => Future.wait([
			if (localContentFilterSettings == null)
				database.contentFilterSettings.put(ContentFilterSettings.defaultSettings),
			if (localCoverPersistenceSettings == null)
				database.coverPersistenceSettings.put(CoverPersistenceSettings.defaultSettings),
			if (localChapterPersistenceSettings == null)
				database.chapterPersistenceSettings.put(ChapterPersistenceSettings.defaultSettings),
			if (localThemeSettings == null)
				database.themeSettings.put(ThemeSettings.defaultSettings),
		]));

		/// Run migrations and default initializations here.
		instance = Settings._internal(database:  database);
	}
}
