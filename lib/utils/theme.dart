import "dart:async";

import "package:dynamic_color/dynamic_color.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:isar/isar.dart";
import "package:riba/settings/theme.dart";

typedef ThemePreference = ({ThemeId id, ColorScheme scheme, ThemeMode themeMode});

class ExperimentalThemeManager {
	static late final ExperimentalThemeManager instance;

	final themeSettingsStream = ThemeSettings.ref.where()
		.keyEqualTo(ThemeSettings.isarKey)
		.watch(fireImmediately: false);

	/// The current theme preference
	/// 
	/// Hoisted for the sake of listening to changes.
	late final ValueNotifier<ThemePreference> pref;

	ThemeData get theme => ThemeData(
		useMaterial3: true,
		colorScheme: pref.value.scheme,
		brightness: pref.value.themeMode.asBrightness(),
	);

	ExperimentalThemeManager._internal(ThemePreference preference) {
		pref = ValueNotifier(preference);

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
		final pref = this.pref.value;
		this.pref.value = (
			id: pref.id,
			scheme: await getColorScheme(pref.id, pref.themeMode.asBrightness()),
			themeMode: pref.themeMode,
		);
	}

	static Future<void> init() async {
		final settings = (await ThemeSettings.ref.getByKey(ThemeSettings.isarKey))!;

		instance = ExperimentalThemeManager._internal((
			id: settings.themeId,
			themeMode: settings.themeMode,
			scheme: await getColorScheme(settings.themeId, settings.themeMode.asBrightness()),
		));
	}

	static FutureOr<ColorScheme> getColorScheme(ThemeId themeId, Brightness brightness) {
		if (themeId == ThemeId.dynamic) {
			return getDynamicColorScheme(brightness);
		} 
	
		return ColorScheme.fromSeed(seedColor: swatches[themeId]!, brightness: brightness);
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

extension TextColor on TextStyle {
	TextStyle withColorOpacity(double opacity) => copyWith(color: color?.withOpacity(opacity));
}
