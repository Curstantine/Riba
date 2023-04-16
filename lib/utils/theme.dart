import "package:dynamic_color/dynamic_color.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:google_fonts/google_fonts.dart";
import "package:riba/settings/theme.dart";

class ThemeManager with ChangeNotifier {
	static bool _initialized = false;
	static late final ThemeManager instance;

	ThemeManager._internal({required this.settings}) {
		_initialized = true;
		addListener(onChange);
		SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
	}

	static Future<void> init() async {
		if (_initialized) throw Exception("ThemeManager is already initialized.");

		final settings = await ThemeSettings.ref.getByKey("themeSettings");
		if (settings == null) throw Exception("ThemeSettings is null.");

		final manager = ThemeManager._internal(settings: settings);
		await manager.setTheme(settings.themeId);

		instance = manager;
	}

	late ColorScheme scheme;
	late ThemeSettings settings;

	ThemeData get theme => ThemeData(
		useMaterial3: true,
		colorScheme: scheme,
		textTheme: textTheme,
		brightness: settings.themeMode.toBrightness());

	TextTheme get textTheme => GoogleFonts.robotoFlexTextTheme(const TextTheme());

	void onChange() {
		SystemChrome.setSystemUIOverlayStyle(getOverlayStyles());
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

		settings = settings.copyWith(themeId: themeId);
		ThemeSettings.ref.isar.writeTxn(() async {
			await ThemeSettings.ref.put(settings);
		});

		notifyListeners();
	}

	Future<void> refresh() async {
		if (settings.themeMode == ThemeMode.system) {
			if (settings.themeId == ThemeId.dynamic) {
				scheme = await getDynamicColorScheme();
			}

			notifyListeners();
		}
	}

	Future<ColorScheme> getDynamicColorScheme() async {
		final palette = await DynamicColorPlugin.getCorePalette();
		final brightness = settings.themeMode.toBrightness();

		if (palette != null) {
			return palette.toColorScheme(brightness: brightness);
		} else {
			if (brightness == Brightness.light) return const ColorScheme.light();
			if (brightness == Brightness.dark) return const ColorScheme.dark();
			throw Exception("Unknown brightness: $brightness");
		}
	}

	/// Returns a [SystemUiOverlayStyle] with the given options while applying preferred defaults.
	SystemUiOverlayStyle getOverlayStyles({
		Color statusBarColor = Colors.transparent,
		Color systemNavigationBarColor = Colors.transparent,
		Brightness? statusBarBrightness,
		Brightness? statusBarIconBrightness,
		Brightness? systemNavigationBarIconBrightness,
	}) {
		final themeModeBrightness = settings.themeMode.toBrightness();

		return SystemUiOverlayStyle(
			statusBarColor: statusBarColor,
			statusBarBrightness: statusBarBrightness ?? themeModeBrightness,
			statusBarIconBrightness: statusBarIconBrightness ?? themeModeBrightness.toOpposite(),
			systemNavigationBarColor: systemNavigationBarColor,
			systemNavigationBarDividerColor: systemNavigationBarColor,
			systemNavigationBarIconBrightness: systemNavigationBarIconBrightness ?? themeModeBrightness,
		);
	}

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

	Brightness toOpposite() {
		switch (this) {
		case Brightness.light:
			return Brightness.dark;
		case Brightness.dark:
			return Brightness.light;
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
