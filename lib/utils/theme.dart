import 'package:dynamic_color/dynamic_color.dart' show CorePaletteToColorScheme, DynamicColorPlugin;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:riba/utils/constants.dart';
import 'package:riba/utils/settings.dart';

part 'theme.g.dart';

class ThemeManager with ChangeNotifier {
  static late ThemeManager instance;
  ThemeManager._internal({required this.id, required this.mode}) {
    addListener(onChange);
  }

  @override
  void dispose() {
    removeListener(onChange);
    super.dispose();
  }

  void onChange() {
    if (!preventSystemOverlaySync) {
      setSystemOverlayStyles();
    }
  }

  static Future<void> init() async {
    instance = ThemeManager._internal(
      id: Settings.instance.data.themeId,
      mode: Settings.instance.data.themeMode,
    );

    await instance.refresh();
  }

  late ThemeId id;
  late ThemeMode mode;
  late ColorScheme scheme;

  /// Stops the changes done by [setSystemOverlayStyles] whenever [refresh] | [onChange] is called.
  bool preventSystemOverlaySync = false;

  ThemeData get theme => ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      textTheme: textTheme,
      brightness: mode.toBrightness());

  TextTheme get textTheme => const TextTheme(
        titleLarge: TextStyle(fontFamily: FontFamily.Rubik),
        titleMedium: TextStyle(fontFamily: FontFamily.Rubik, letterSpacing: 0.2),
        titleSmall: TextStyle(fontFamily: FontFamily.Rubik),
        labelLarge: TextStyle(fontFamily: FontFamily.Rubik),
        labelMedium: TextStyle(fontFamily: FontFamily.Rubik),
        labelSmall: TextStyle(fontFamily: FontFamily.Rubik),
      );

  Future<void> setTheme(ThemeId themeId) async {
    if (themeId == ThemeId.dynamic) {
      scheme = await getDynamicColorScheme();
    } else {
      scheme = themes[themeId]!;
    }

    id = themeId;
    notifyListeners();
  }

  Future<ColorScheme> getDynamicColorScheme() async {
    final palette = await DynamicColorPlugin.getCorePalette();
    final brightness = mode.toBrightness();

    if (palette != null) {
      return palette.toColorScheme(brightness: brightness)!;
    } else {
      if (brightness == Brightness.light) return const ColorScheme.light();
      if (brightness == Brightness.dark) return const ColorScheme.dark();
      throw Exception('Unknown brightness: $brightness');
    }
  }

  Future<void> refresh() async {
    if (mode == ThemeMode.system) {
      if (id == ThemeId.dynamic) {
        scheme = await getDynamicColorScheme();
      }

      notifyListeners();
    }
  }

  /// Sets the system overlay styles used by the app.
  ///
  /// In case a relevant parameter is not passed, it will be set to a default value.
  void setSystemOverlayStyles({
    Color statusBarColor = Colors.transparent,
    Brightness? statusBarBrightness,
    Brightness? statusBarIconBrightness,
  }) =>
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: statusBarColor,
        statusBarBrightness: statusBarBrightness ?? mode.toBrightness(),
        statusBarIconBrightness: statusBarIconBrightness ??
            (mode.toBrightness() == Brightness.light ? Brightness.dark : Brightness.light),
      ));

  static Map<ThemeId, ColorScheme> themes = {
    ThemeId.lavender: ColorScheme.fromSeed(seedColor: Colors.purple.shade500)
  };
}

@HiveType(typeId: TypeAdapterIds.themeIdAdapter)
enum ThemeId {
  @HiveField(0)
  dynamic,

  @HiveField(1)
  lavender,
}

extension ToThemeMode on Brightness {
  ThemeMode toThemeMode() {
    if (this == Brightness.light) return ThemeMode.light;
    if (this == Brightness.dark) return ThemeMode.dark;
    throw Exception('Unknown brightness: $this');
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
      default:
        throw Exception('Unknown theme mode: $this');
    }
  }
}

extension TextColor on TextStyle {
  TextStyle withColorAlpha(double alpha) {
    if (alpha < 0 || alpha > 1) {
      throw Exception("alpha should be between 0 and 1");
    }
    return copyWith(color: color?.withAlpha((alpha * 255).round()));
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
        throw Exception('Unknown theme mode: $this');
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
