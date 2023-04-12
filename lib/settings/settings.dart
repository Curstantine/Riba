import "package:isar/isar.dart";
import "package:riba/settings/cache.dart";
import "package:riba/utils/directories.dart";

import "filter.dart";
import "theme.dart";

class Settings {
  static late final Settings instance;

  Settings._internal({required this.database});

  final Isar database;

  static Future<void> init() async {
    final schemas = [
      CoverCacheSettingsSchema,
      ChapterCacheSettingsSchema,
      MangaFilterSettingsSchema,
      ThemeSettingsSchema,
    ];

    instance = Settings._internal(
      database: await Isar.open(
        schemas,
        directory: InitDirectories.instance.supportDir.path,
        name: "SettingsDatabase",
      ),
    );
  }
}
