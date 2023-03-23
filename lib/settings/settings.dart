import "package:hive/hive.dart";
import "package:riba/settings/filter.dart";

import "cache.dart";
import "theme.dart";

class Settings {
  static late final Settings instance;
  Settings._internal();

  final ThemeSettings theme = ThemeSettings();
  final CacheSettings caching = CacheSettings();
  final FilterSettings filter = FilterSettings();

  static Future<void> init() async {
    instance = Settings._internal();

    await Future.wait([
      instance.theme.init(),
      instance.caching.init(),
      instance.filter.init(),
    ]);
  }
}

abstract class SettingsController<T> {
  abstract final String id;
  abstract final Box box;

  T get defaultValue;

  Future<void> init();
}
