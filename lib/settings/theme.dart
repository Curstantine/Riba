import "package:flutter/material.dart";
import "package:hive/hive.dart";
import "package:riba/utils/constants.dart";

import "settings.dart";

part "theme.g.dart";

class ThemeSettings extends SettingsController<ThemeSettingsData> {
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
      id: box.get("id", defaultValue: defaultValue.id),
      mode: box.get("mode", defaultValue: defaultValue.mode),
    );
  }

  @override
  void save(ThemeSettingsData data) {
    box.put("id", data.id);
    box.put("mode", data.mode);
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

extension ToThemeMode on Brightness {
  ThemeMode toThemeMode() {
    switch (this) {
      case Brightness.light:
        return ThemeMode.light;
      case Brightness.dark:
        return ThemeMode.dark;
    }
  }
}

extension ToBrightness on ThemeMode {
  Brightness toBrightness() {
    switch (this) {
      case ThemeMode.light:
        return Brightness.light;
      case ThemeMode.dark:
        return Brightness.dark;
      case ThemeMode.system:
        return WidgetsBinding.instance.window.platformBrightness;
    }
  }
}

extension TextColor on TextStyle {
  TextStyle withColorOpacity(double alpha) {
    return copyWith(color: color?.withOpacity(alpha));
  }
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
