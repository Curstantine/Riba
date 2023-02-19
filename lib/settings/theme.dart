import "dart:developer";

import "package:flutter/material.dart";
import "package:hive/hive.dart";
import "package:riba/utils/constants.dart";

import "settings.dart";

part "theme.g.dart";

class ThemeSettings extends SettingsController<ThemeSettingsData> {
  static final ThemeSettings instance = Settings.instance.theme;

  @override
  final String id = "theme";

  @override
  late final Box box;

  @override
  ThemeSettingsData get defaultValue => ThemeSettingsData(
        id: ThemeId.dynamic,
        mode: ThemeMode.system,
      );

  @override
  Future<void> init() async {
    Hive.registerAdapter(ThemeIdAdapter());
    Hive.registerAdapter(ThemeModeAdapter());

    box = await Hive.openBox(id);
  }

  @override
  ThemeSettingsData get() {
    return ThemeSettingsData(
      id: box.get(ThemeSettingKeys.id, defaultValue: defaultValue.id),
      mode: box.get(ThemeSettingKeys.mode, defaultValue: defaultValue.mode),
    );
  }

  @override
  Future<void> save(ThemeSettingsData data) async {
    log("Saving theme settings: $data", name: "ThemeSettings");

    await Future.wait([
      box.put(ThemeSettingKeys.id, data.id),
      box.put(ThemeSettingKeys.mode, data.mode),
    ]);
  }
}

@HiveType(typeId: TypeAdapterIds.themeIdAdapter)
enum ThemeId {
  @HiveField(0)
  dynamic,

  @HiveField(1)
  lavender,
}

class ThemeSettingsData {
  ThemeSettingsData({required this.id, required this.mode});

  ThemeId id;
  ThemeMode mode;
}

class ThemeSettingKeys {
  static const String id = "id";
  static const String mode = "mode";
}

// Hive adapter for ThemeMode enum
class ThemeModeAdapter extends TypeAdapter<ThemeMode> {
  @override
  final int typeId = TypeAdapterIds.themeModeAdapter;

  @override
  ThemeMode read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ThemeMode.system;
      case 1:
        return ThemeMode.light;
      case 2:
        return ThemeMode.dark;
      default:
        throw Exception("Unknown theme mode: $this");
    }
  }

  @override
  void write(BinaryWriter writer, ThemeMode obj) {
    switch (obj) {
      case ThemeMode.system:
        writer.writeByte(0);
        break;
      case ThemeMode.light:
        writer.writeByte(1);
        break;
      case ThemeMode.dark:
        writer.writeByte(2);
        break;
    }
  }
}
