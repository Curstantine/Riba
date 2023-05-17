import "dart:async";

import "package:dynamic_color/dynamic_color.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:isar/isar.dart";
import "package:riba/settings/theme.dart";

class ThemeManager {
	// static bool _initialized = false;
	// static late final ThemeManager instance;

	// ThemeManager._internal({required this.settings}) {
	// 	_initialized = true;
	// 	SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
	// }

	// static Future<void> init() async {
	// 	if (_initialized) throw Exception("ThemeManager is already initialized.");

	// 	final settings = await ThemeSettings.ref.getByKey("themeSettings");
	// 	if (settings == null) throw Exception("ThemeSettings is null.");

	// 	final manager = ThemeManager._internal(settings: settings);
	// 	await manager.setTheme(settings.themeId);

	// 	instance = manager;
	// }

	// // final scheme = ValueNotifier<ColorScheme>(themes.values.first);
	// ThemeSettings settings;

	// ThemeData get theme => ThemeData(
	// 	useMaterial3: true,
	// 	colorScheme: scheme.value,
	// 	brightness: settings.themeMode.asBrightness());

	// void onChange() {
	// 	SystemChrome.setSystemUIOverlayStyle(getOverlayStyles());
	// }

	// // FutureOr<ColorScheme> getColorScheme(ThemeId themeId) {
	// // 	if (themeId == ThemeId.dynamic) {
	// // 		return getDynamicColorScheme();
	// // 	} else {
	// // 		return themes[themeId]!;
	// // 	}
	// // }

	// Future<void> setTheme(ThemeId themeId) async {
	// 	scheme.value = await getColorScheme(themeId);
	// 	settings = settings.copyWith.themeId(themeId);

	// 	await ThemeSettings.ref.isar.writeTxn(() => ThemeSettings.ref.put(settings));
	// 	return refresh();
	// }

	// Future<void> refresh() async {
	// if (settings.themeMode == ThemeMode.system) {
	// 		if (settings.themeId == ThemeId.dynamic) {
	// 			scheme.value = await getDynamicColorScheme();
	// 		}
	// 	}
	// }

	// Future<ColorScheme> getDynamicColorScheme() async {
	// 	final palette = await DynamicColorPlugin.getCorePalette();
	// 	final brightness = settings.themeMode.asBrightness();

	// 	if (palette != null) {
	// 		return palette.toColorScheme(brightness: brightness);
	// 	} else {
	// 		if (brightness == Brightness.light) return const ColorScheme.light();
	// 		if (brightness == Brightness.dark) return const ColorScheme.dark();
	// 		throw Exception("Unknown brightness: $brightness");
	// 	}
	// }

	/// Returns a [SystemUiOverlayStyle] with the given options while applying preferred defaults.
	// SystemUiOverlayStyle getOverlayStyles({
	// 	Color statusBarColor = Colors.transparent,
	// 	Color systemNavigationBarColor = Colors.transparent,
	// 	Brightness? statusBarBrightness,
	// 	Brightness? statusBarIconBrightness,
	// 	Brightness? systemNavigationBarIconBrightness,
	// }) {

	// 	return SystemUiOverlayStyle(
	// 		statusBarColor: statusBarColor,
	// 		statusBarBrightness: statusBarBrightness ?? themeModeBrightness,
	// 		statusBarIconBrightness: statusBarIconBrightness ?? themeModeBrightness.toOpposite(),
	// 		systemNavigationBarColor: systemNavigationBarColor,
	// 		systemNavigationBarDividerColor: systemNavigationBarColor,
	// 		systemNavigationBarIconBrightness: systemNavigationBarIconBrightness ?? themeModeBrightness,
	// 	);
	// }
}

class ExperimentalThemeManager {
	static late final ExperimentalThemeManager instance;

	final themeSettingsStream = ThemeSettings.ref.where()
		.keyEqualTo(ThemeSettings.isarKey)
		.watch();

	/// The current theme preference
	/// 
	/// Hoisted for the sake of listening to changes.
	final ValueNotifier<({ThemeId id, ColorScheme scheme, ThemeMode themeMode})> pref = ValueNotifier(
		(id: ThemeId.lavender, scheme: themes[ThemeId.lavender]!, themeMode: ThemeMode.system)
	);

	ThemeData get theme => ThemeData(
		useMaterial3: true,
		colorScheme: pref.value.scheme,
		brightness: pref.value.themeMode.asBrightness());

	ExperimentalThemeManager._internal() {
		SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
		themeSettingsStream.asyncMap((e) => e.first).listen((e) async {
			pref.value = (
				id: e.themeId,
				scheme: await getColorScheme(e.themeId, e.themeMode.asBrightness()),
				themeMode: e.themeMode,
			);
		});
	}

	/// Updates the current theme preference according to the current preferred brightness.
	/// Useful for cases where [ThemeMode] is `system`, and the user changes the system brightness.
	Future<void> refreshBrightness() async {		
		pref.value = (
			id: pref.value.id,
			scheme: await getColorScheme(pref.value.id, pref.value.themeMode.asBrightness()),
			themeMode: pref.value.themeMode,
		);
	}

	static void init() => instance = ExperimentalThemeManager._internal();

	static FutureOr<ColorScheme> getColorScheme(ThemeId themeId, Brightness brightness) {
		if (themeId == ThemeId.dynamic) {
			return getDynamicColorScheme(brightness);
		} 
	
		return themes[themeId]!;		
	}

	static Future<ColorScheme> getDynamicColorScheme(Brightness brightness) async {
		final palette = await DynamicColorPlugin.getCorePalette();

		if (palette != null) {
			return palette.toColorScheme(brightness: brightness);
		}
		
		switch (brightness) {
			case Brightness.light:
		    	return const ColorScheme.light();
			case Brightness.dark:
				return const ColorScheme.dark();
		}
	}

	static Map<ThemeId, ColorScheme> themes = {
		ThemeId.lavender: ColorScheme.fromSeed(seedColor: Colors.purple.shade500)
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

extension TextColor on TextStyle {
	TextStyle withColorOpacity(double opacity) => copyWith(color: color?.withOpacity(opacity));
}
