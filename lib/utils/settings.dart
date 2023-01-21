import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:riba/utils/theme.dart';

class Settings {
  static late Settings instance;
  Settings._internal();

  static Future<void> init() async {
    final box = await Hive.openBox(_Keys.self);
    SettingsData localData;

    if (box.isEmpty) {
      localData = SettingsData.getDefaultData()..save();
    } else {
      localData = SettingsData.fromBox();
    }

    instance = Settings._internal()
      ..box = box
      ..data = localData;
  }

  late Box box;
  late SettingsData data;
}

class _Keys {
  static const self = "settings";
  static const themeId = 'themeId';
  static const themeMode = 'themeMode';
}

class SettingsData {
  SettingsData({
    required this.themeId,
    required this.themeMode,
  });

  ThemeId themeId;
  ThemeMode themeMode;

  static SettingsData getDefaultData() {
    return SettingsData(
      themeId: ThemeId.dynamic,
      themeMode: ThemeMode.system,
    );
  }

  static SettingsData fromBox() {
    final box = Hive.box(_Keys.self);

    return SettingsData(
      themeId: box.get(_Keys.themeId),
      themeMode: box.get(_Keys.themeMode),
    );
  }

  void save() {
    final box = Hive.box(_Keys.self);

    box.put(_Keys.themeId, themeId);
    box.put(_Keys.themeMode, themeMode);
  }
}

// HiveType for ThemeMode enum
