// ignore_for_file: public_member_api_docs, sort_constructors_first
import "dart:async";

import "package:dynamic_color/dynamic_color.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:riba/settings/appearance/store.dart" show SchemeId;
import "package:riba/settings/settings.dart";

typedef AccompanyingColorSchemes = ({ColorScheme light, ColorScheme dark});
typedef AppRefreshHook = ({void Function() init, void Function() dispose});

class ThemeManager {
	static late final ThemeManager instance;
	
	late ColorScheme _lightScheme;
	late ColorScheme _darkScheme;

	ThemeData get lightTheme => ThemeData(
		useMaterial3: true,
		colorScheme: _lightScheme,
		brightness: Brightness.light
	);

	ThemeData get darkTheme => ThemeData(
		useMaterial3: true,
		colorScheme: _darkScheme,
		brightness: Brightness.dark,
	);

	ThemeManager._internal(ThemeMode themeMode, AccompanyingColorSchemes colorSchemes) {
		_lightScheme = colorSchemes.light;
		_darkScheme = colorSchemes.dark;

		SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
		setOverlayStyles(themeMode.asBrightness());
	}

	static Future<void> init() async {
		final settings = Settings.instance.appearance;
		final schemes = await Future.wait([
			getColorScheme(settings.lightSchemeId.value, Brightness.light),
			getColorScheme(settings.darkSchemeId.value, Brightness.dark),
		]); 

		instance = ThemeManager._internal(
			settings.themeMode.value,
			(light: schemes[0], dark: schemes[1]),
		);
	}

	static Future<ColorScheme> getColorScheme(SchemeId id, Brightness brightness) async {
		if (id == SchemeId.dynamic) {
			return getDynamicColorScheme(brightness);
		}

		final swatch = swatches[id]!;
		return ColorScheme.fromSeed(seedColor: swatch, brightness: brightness);
	}

	static Future<ColorScheme> getDynamicColorScheme(Brightness brightness) async {
		final palette = await DynamicColorPlugin.getCorePalette();
		return palette?.toColorScheme(brightness: brightness) ??  ColorSchemeDefaults.getBrightnessDefault(brightness);
	}

	/// Returns a [SystemUiOverlayStyle] with the given options while applying preferred defaults.
	static SystemUiOverlayStyle getOverlayStyles({
		required Brightness brightness,
		Color statusBarColor = Colors.transparent,
		Color systemNavigationBarColor = Colors.transparent,
		Brightness? statusBarBrightness,
		Brightness? statusBarIconBrightness,
		Brightness? systemNavigationBarIconBrightness,
	}) {
		return SystemUiOverlayStyle(
			statusBarColor: statusBarColor,
			statusBarBrightness: statusBarBrightness ?? brightness,
			statusBarIconBrightness: statusBarIconBrightness ?? brightness.toOpposite(),
			systemNavigationBarColor: systemNavigationBarColor,
			systemNavigationBarDividerColor: systemNavigationBarColor,
			systemNavigationBarIconBrightness: systemNavigationBarIconBrightness ?? brightness,
		);
	}

	/// Convenience alias for [SystemChrome.setSystemUIOverlayStyle] with
	/// [getOverlayStyles] as the argument.
	static void setOverlayStyles(Brightness brightness) => SystemChrome
		.setSystemUIOverlayStyle(getOverlayStyles(brightness: brightness));

	/// Creates a hook to listen to the changes of [lightSchemeId] and [darkSchemeId] on demand based
	/// on the current [ThemeMode] and calls [setState] to update a [MaterialApp] with the new
	/// [ThemeData].
	static AppRefreshHook useAppRefreshHook({required void Function(void Function()) setState}) {
		final settings = Settings.instance.appearance;
		final lightSchemeId = settings.lightSchemeId;
		final darkSchemeId = settings.darkSchemeId;
		final themeMode = settings.themeMode;

		void Function() createChangeHook(Brightness brightness, ValueListenable<SchemeId> schemeId) {
			return () => {
				if (brightness == Settings.instance.appearance.themeMode.value.asBrightness()) {
					setState(() => {})
				}
			};
		}

		void Function() createThemeModeHook(ValueListenable<ThemeMode> mode) {
			bool wasPlatformBrightnessModded = false;

			return () {
				switch (mode.value) {
					case ThemeMode.light:
					case ThemeMode.dark:
						if (wasPlatformBrightnessModded) {
							wasPlatformBrightnessModded = false;
							PlatformDispatcher.instance.onPlatformBrightnessChanged = WidgetsBinding.instance.handlePlatformBrightnessChanged;
						}
						ThemeManager.setOverlayStyles(mode.value.asBrightness());
						break;
					case ThemeMode.system:
						wasPlatformBrightnessModded = true;
						PlatformDispatcher.instance.onPlatformBrightnessChanged = () {
							ThemeManager.setOverlayStyles(themeMode.value.asBrightness());
							WidgetsBinding.instance.handlePlatformBrightnessChanged();
						};
						break;
				}
			};
		}

		final lightSchemeIdHook = createChangeHook(Brightness.light, lightSchemeId);
		final darkSchemeIdHook = createChangeHook(Brightness.dark, darkSchemeId);
		final themeModeHook = createThemeModeHook(themeMode);

		/// Initial call to hook to the current theme mode.
		themeModeHook.call();

		return (
			init: () {
				lightSchemeId.addListener(lightSchemeIdHook);
				darkSchemeId.addListener(darkSchemeIdHook);
				themeMode.addListener(themeModeHook);
			},
			dispose: () {
				lightSchemeId.removeListener(lightSchemeIdHook);
				darkSchemeId.removeListener(darkSchemeIdHook);
				themeMode.removeListener(themeModeHook);
			},
		);
	}

	static Map<SchemeId, Color> get swatches => {
		SchemeId.brittlePink: const Color(0xFFE14E4E),
	};
}

class Swatch {
	final Color light;
	final Color dark;

	const Swatch({required this.light, required this.dark});

	Color get(Brightness brightness) {
		switch (brightness) {
			case Brightness.light:
				return light;
			case Brightness.dark:
				return dark;
		}
	}
}



extension ColorSchemeDefaults on ColorScheme {
	static ColorScheme getBrightnessDefault(Brightness brightness) {
		switch (brightness) {
			case Brightness.light:
				return const ColorScheme.light();
			case Brightness.dark:
				return const ColorScheme.dark();
		}
	}
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
