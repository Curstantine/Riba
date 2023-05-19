import "dart:async";

import "package:dynamic_color/dynamic_color.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:isar/isar.dart";
import "package:riba/settings/appearance.dart";

typedef ThemePreference = ({SchemeId lightSchemeId, SchemeId darkSchemeId, ThemeMode themeMode});
typedef AccompanyingColorSchemes = ({ColorScheme light, ColorScheme dark});
typedef AppRefreshHook = ({void Function() init, void Function() dispose});

class ThemeManager {
	static late final ThemeManager instance;

	final _settingsStream = AppearanceSettings.ref.where()
		.keyEqualTo(AppearanceSettings.isarKey)
		.watch(fireImmediately: false)
		.asyncMap((event) => event.first);

	late final ValueNotifier<SchemeId> lightSchemeId;
	late final ValueNotifier<SchemeId> darkSchemeId;
	late final ValueNotifier<ThemeMode> themeMode;
	
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

	ThemeManager._internal(ThemePreference preference, AccompanyingColorSchemes colorSchemes) {
		lightSchemeId = ValueNotifier(preference.lightSchemeId);
		darkSchemeId = ValueNotifier(preference.darkSchemeId);
		themeMode = ValueNotifier(preference.themeMode);
		_lightScheme = colorSchemes.light;
		_darkScheme = colorSchemes.dark;

		SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
		SystemChrome.setSystemUIOverlayStyle(getOverlayStyles(themeMode: preference.themeMode));
		_settingsStream.listen(_onAppearanceSettingsChanged);
	}

	Future<void> _onAppearanceSettingsChanged(AppearanceSettings e) async {
		if (lightSchemeId.value != e.lightSchemeId) {
			_lightScheme = await getColorScheme(e.lightSchemeId, Brightness.light);
		}

		if (darkSchemeId.value != e.darkSchemeId) {
			_darkScheme = await getColorScheme(e.darkSchemeId, Brightness.dark);
		}
		
		lightSchemeId.value = e.lightSchemeId;
		darkSchemeId.value = e.darkSchemeId;
		themeMode.value = e.themeMode;
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
		final settings = (await AppearanceSettings.ref.getByKey(AppearanceSettings.isarKey))!;
		final schemes = await Future.wait([
			getColorScheme(settings.lightSchemeId, Brightness.light),
			getColorScheme(settings.darkSchemeId, Brightness.dark),
		]); 

		instance = ThemeManager._internal(
			(lightSchemeId: settings.lightSchemeId, darkSchemeId: settings.darkSchemeId, themeMode: settings.themeMode),
			(light: schemes[0], dark: schemes[1]),
		);
	}

	static Future<ColorScheme> getColorScheme(SchemeId id, Brightness brightness) async {
		if (id == SchemeId.dynamic) {
			return getDynamicColorScheme(brightness);
		}

		return ColorScheme.fromSeed(seedColor: swatches[id]!, brightness: brightness);
	}

	static Future<ColorScheme> getDynamicColorScheme(Brightness brightness) async {
		final palette = await DynamicColorPlugin.getCorePalette();
		return palette?.toColorScheme(brightness: brightness) ??  ColorSchemeDefaults.getBrightnessDefault(brightness);
	}

	/// Creates a hook to listen to the changes of [lightSchemeId] and [darkSchemeId] on demand based
	/// on the current [ThemeMode] and calls [setState] to update a [MaterialApp] with the new
	/// [ThemeData].
	static AppRefreshHook useAppRefreshHook({required void Function(void Function()) setState}) {
		void Function() createChangeHook(Brightness brightness, ValueNotifier<SchemeId> schemeId) {
			return () => {
				if (brightness == ThemeManager.instance.themeMode.value.asBrightness()) {
					setState(() => {})
				}
			};
		}

		final lightSchemeIdHook = createChangeHook(Brightness.light, instance.lightSchemeId);
		final darkSchemeIdHook = createChangeHook(Brightness.dark, instance.darkSchemeId);

		return (
			init: () {
				instance.lightSchemeId.addListener(lightSchemeIdHook);
				instance.darkSchemeId.addListener(darkSchemeIdHook);
			},
			dispose: () {
				instance.lightSchemeId.removeListener(lightSchemeIdHook);
				instance.darkSchemeId.removeListener(darkSchemeIdHook);
			},
		);
	}

	static Map<SchemeId, Color> swatches = {
		SchemeId.lavender: Colors.deepPurple.shade500,
		SchemeId.brittlePink: Colors.pink.shade500,
	};
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
