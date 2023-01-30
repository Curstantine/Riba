import "package:hive/hive.dart";

import "theme.dart";

class Settings {
  static late final Settings instance;
  Settings._internal({required this.theme});

  final ThemeManager theme;

  static Future<void> init() async {
    instance = Settings._internal(
      theme: await ThemeManager.init(),
    );
  }
}

abstract class SettingsController<T> {
  abstract String id;
  abstract Box box;

  T get defaultValue;

  Future<void> init();
  T get();
  void save(T data);
}
