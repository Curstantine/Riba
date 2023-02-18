import "package:hive/hive.dart";

import "caching.dart";
import "theme.dart";

class Settings {
  static late final Settings instance;
  Settings._internal();

  final ThemeSettings theme = ThemeSettings();
  final CachingSettingsController caching = CachingSettingsController();

  static Future<void> init() async {
    instance = Settings._internal();

    await Future.wait([
      instance.theme.init(),
      instance.caching.init(),
    ]);
  }
}

abstract class SettingsController<T> {
  abstract final String id;
  abstract final Box box;

  T get defaultValue;

  Future<void> init();
  T get();
  void save(T data);
}
