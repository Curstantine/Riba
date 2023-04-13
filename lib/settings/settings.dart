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
		/// Run migrations and default initializations here.
		instance = Settings._internal(database:  database);
	}
}
