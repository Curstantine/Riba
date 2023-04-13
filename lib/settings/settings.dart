import "package:isar/isar.dart";
import "package:riba/settings/cache.dart";
import "package:riba/settings/filter.dart";
import "package:riba/settings/theme.dart";


class Settings {
	static late final Settings instance;
	Settings._internal({required Isar database}) : _database = database;

	final Isar _database;

	IsarCollection<CoverCacheSettings> get coverCacheSettings => _database.coverCacheSettings;
	IsarCollection<ChapterCacheSettings> get chapterCacheSettings => _database.chapterCacheSettings;
	IsarCollection<MangaFilterSettings> get mangaFilterSettings => _database.mangaFilterSettings;
	IsarCollection<ThemeSettings> get themeSettings => _database.themeSettings;

	static Future<void> init(Isar database) async {
		final locals = await Future.wait([
			database.coverCacheSettings.getByKey(CoverCacheSettings.isarKey),
			database.chapterCacheSettings.getByKey(ChapterCacheSettings.isarKey),
			database.themeSettings.getByKey(ThemeSettings.isarKey),  
		]);

		final localCoverCacheSettings = locals[0];
		final localChapterCacheSettings = locals[1];
		final localThemeSettings = locals[2];

		await Future.wait([
			if (localCoverCacheSettings == null)
				database.coverCacheSettings.put(CoverCacheSettings.defaultSettings),
			if (localChapterCacheSettings == null)
				database.chapterCacheSettings.put(ChapterCacheSettings.defaultSettings),
			if (localThemeSettings == null)
				database.themeSettings.put(ThemeSettings.defaultSettings),
		]);

		/// Run migrations and default initializations here.
		instance = Settings._internal(database:  database);
	}
}
