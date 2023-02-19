import "package:dynamic_color/dynamic_color.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:google_fonts/google_fonts.dart";
import "package:riba/settings/theme.dart";

class ThemeManager with ChangeNotifier {
  static bool _initialized = false;
  static late final ThemeManager instance;

  ThemeManager._internal({required this.id, required this.mode, required this.settings}) {
    _initialized = true;
    addListener(onChange);
  }

  static Future<void> init() async {
    if (_initialized) throw Exception("ThemeManager is already initialized.");

    final settings = ThemeSettings.instance;

    final manager = ThemeManager._internal(
      id: settings.themeId,
      mode: settings.mode,
      settings: settings,
    );

    await manager.setTheme(manager.id);
    instance = manager;
  }

  ThemeId id;
  ThemeMode mode;
  late ColorScheme scheme;
  final ThemeSettings settings;

  /// Stops the changes done by [setSystemOverlayStyles] whenever [refresh] | [onChange] is called.
  bool preventSystemOverlaySync = false;

  ThemeData get theme => ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      textTheme: textTheme,
      brightness: mode.toBrightness());

  TextTheme get textTheme => GoogleFonts.robotoFlexTextTheme(const TextTheme());

  void onChange() {
    if (!preventSystemOverlaySync) {
      setSystemOverlayStyles();
    }
  }

  @override
  void dispose() {
    removeListener(onChange);
    super.dispose();
  }

  Future<void> setTheme(ThemeId themeId) async {
    if (themeId == ThemeId.dynamic) {
      scheme = await getDynamicColorScheme();
    } else {
      scheme = themes[themeId]!;
    }

    id = themeId;
    settings.box.put(ThemeSettingKeys.id, id);

    notifyListeners();
  }

  Future<void> refresh() async {
    if (mode == ThemeMode.system) {
      if (id == ThemeId.dynamic) {
        scheme = await getDynamicColorScheme();
      }

      notifyListeners();
    }
  }

  Future<ColorScheme> getDynamicColorScheme() async {
    final palette = await DynamicColorPlugin.getCorePalette();
    final brightness = mode.toBrightness();

    if (palette != null) {
      return palette.toColorScheme(brightness: brightness)!;
    } else {
      if (brightness == Brightness.light) return const ColorScheme.light();
      if (brightness == Brightness.dark) return const ColorScheme.dark();
      throw Exception("Unknown brightness: $brightness");
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