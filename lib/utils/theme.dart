import "dart:async";

import "package:dynamic_color/dynamic_color.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:isar/isar.dart";
import "package:riba/settings/theme.dart";

typedef ThemePreference = ({ThemeId id, ThemeMode themeMode});
typedef AccompanyingColorSchemes = ({ColorScheme light, ColorScheme dark});

class ThemeManager {
	static late final ThemeManager instance;

	final themeSettingsStream = ThemeSettings.ref.where()
		.keyEqualTo(ThemeSettings.isarKey)
		.watch(fireImmediately: false)
		.asyncMap((event) => event.first);

	late final ValueNotifier<ThemeId> themeId;
	late final ValueNotifier<ThemeMode> themeMode;
	late AccompanyingColorSchemes schemes;

	ThemeData get lightTheme => ThemeData(
		useMaterial3: true,
		colorScheme: schemes.light,
		brightness: Brightness.light
	);

	ThemeData get darkTheme => ThemeData(
		useMaterial3: true,
		colorScheme: schemes.dark,
		brightness: Brightness.dark,
	);

	ThemeManager._internal(ThemePreference preference, AccompanyingColorSchemes colorSchemes) {
		themeId = ValueNotifier(preference.id);
		themeMode = ValueNotifier(preference.themeMode);
		schemes = colorSchemes;

		SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
		SystemChrome.setSystemUIOverlayStyle(getOverlayStyles(themeMode: preference.themeMode));
		themeSettingsStream.listen((e) async {
			if (themeId.value != e.themeId) {
				schemes = await getAccompanyingColorSchemes(e.themeId);
			}
			
			themeId.value = e.themeId;
			themeMode.value = e.themeMode;
		});
	}

		/// Returns a [SystemUiOverlayStyle] with the given options while applying preferred defaults.
	SystemUiOverlayStyle getOverlayStyles({
		required ThemeMode themeMode,
		Color statusBarColor = Colors.transparent,
		Color systemNavigationBarColor = Colors.transparent,
		Brightness? statusBarBrightness,
		Brightness? statusBarIconBrightness,
		Brightness? systemNavigationBarIconBrightness,
	}) {
		final brightness = themeMode.asBrightness();

		return SystemUiOverlayStyle(
			statusBarColor: statusBarColor,
			statusBarBrightness: statusBarBrightness ?? brightness,
			statusBarIconBrightness: statusBarIconBrightness ?? brightness.toOpposite(),
			systemNavigationBarColor: systemNavigationBarColor,
			systemNavigationBarDividerColor: systemNavigationBarColor,
			systemNavigationBarIconBrightness: systemNavigationBarIconBrightness ?? brightness,
		);
	}

	static Future<void> init() async {
		final settings = (await ThemeSettings.ref.getByKey(ThemeSettings.isarKey))!;
		final schemes = await getAccompanyingColorSchemes(settings.themeId); 

		instance = ThemeManager._internal(
			(id: settings.themeId, themeMode: settings.themeMode),
			schemes,
		);
	}

	static FutureOr<AccompanyingColorSchemes> getAccompanyingColorSchemes(ThemeId id) async {
		if (id == ThemeId.dynamic) {
			return getAccompanyingDynamicColorSchemes();
		}

		final swatch = swatches[id]!;
		final light = ColorScheme.fromSeed(seedColor: swatch, brightness: Brightness.light);
		final dark = ColorScheme.fromSeed(seedColor: swatch, brightness: Brightness.dark);

		return (light: light, dark: dark);
	}

	static Future<AccompanyingColorSchemes> getAccompanyingDynamicColorSchemes() async {
		final palette = await DynamicColorPlugin.getCorePalette();
		final light = palette?.toColorScheme(brightness: Brightness.light) ?? const ColorScheme.light();
		final dark = palette?.toColorScheme(brightness: Brightness.dark) ?? const ColorScheme.dark();
		
		return (light: light, dark: dark);
	}

	static Map<ThemeId, Color> swatches = {
		ThemeId.lavender: Colors.deepPurple.shade500,
	};
}

extension ToThemeMode on Brightness {
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
	Brightness asBrightness() {
		switch (this) {
			case ThemeMode.light:
				return Brightness.light;
			case ThemeMode.dark:
				return Brightness.dark;
			case ThemeMode.system:
				return PlatformDispatcher.instance.platformBrightness;
		}
	}
}

extension OfBrightness on AccompanyingColorSchemes {
	ColorScheme ofBrightness(Brightness brightness) {
		switch (brightness) {
			case Brightness.light:
				return light;
			case Brightness.dark:
				return dark;
		}
	}
}

extension TextColor on TextStyle {
	TextStyle withColorOpacity(double opacity) => copyWith(color: color?.withOpacity(opacity));
}
