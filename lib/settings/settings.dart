import "package:isar/isar.dart";
import "package:riba/settings/cache.dart";
import "package:riba/settings/filter.dart";
import "package:riba/settings/theme.dart";


class Settings {
	static late final Settings instance;
	Settings._internal({required Isar database}) : _database = database;

	final Isar _database;

	IsarCollection<CoverPersistenceSettings> get coverPersistenceSettings => _database.coverPersistenceSettings;
	IsarCollection<ChapterPersistenceSettings> get chapterPersistenceSettings => _database.chapterPersistenceSettings;
	IsarCollection<MangaFilterSettings> get mangaFilterSettings => _database.mangaFilterSettings;
	IsarCollection<ThemeSettings> get themeSettings => _database.themeSettings;

	static Future<void> init(Isar database) async {
		final locals = await Future.wait([
			database.coverPersistenceSettings.getByKey(CoverPersistenceSettings.isarKey),
			database.chapterPersistenceSettings.getByKey(ChapterPersistenceSettings.isarKey),
			database.themeSettings.getByKey(ThemeSettings.isarKey),  
		]);

		final localCoverPersistenceSettings = locals[0];
		final localChapterPersistenceSettings = locals[1];
		final localThemeSettings = locals[2];

		await database.writeTxn(() => Future.wait([
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
