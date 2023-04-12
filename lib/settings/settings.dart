import "package:isar/isar.dart";
import "package:riba/utils/directories.dart";

import "cache.dart";
import "filter.dart";
import "theme.dart";

class Settings {
  static late final Settings instance;

  Settings._internal({required this.database});

  final Isar database;

  static Future<void> init() async {
    final schemas = [
      CacheCoverSettingsSchema,
      CacheChapterSettingsSchema,
      MangaFilterSettingsSchema,
      ThemeSettingsSchema,
    ];

    instance = Settings._internal(
      database: await Isar.open(
        schemas,
        directory: InitDirectories.instance.supportDir.path,
        name: "Settings",
      ),
    );
  }
}
