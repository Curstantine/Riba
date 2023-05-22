import "package:flutter/foundation.dart";
import "package:flutter/material.dart" hide Locale;
import "package:riba/repositories/local/models/localization.dart";
import "package:riba/settings/settings.dart";

import "store.dart";

typedef Store = AppearanceSettingsStore;

class AppearanceSettingsController extends CollectionSettingsController<Store> {
	AppearanceSettingsController({required super.isar});

	late final ValueNotifier<ThemeMode> _themeMode;
	ValueListenable<ThemeMode> get themeMode => _themeMode;

	late final ValueNotifier<SchemeId> _lightSchemeId;
	ValueListenable<SchemeId> get lightSchemeId => _lightSchemeId;

	late final ValueNotifier<SchemeId> _darkSchemeId;
	ValueListenable<SchemeId> get darkSchemeId => _darkSchemeId;

	late final ValueNotifier<List<Locale>> _preferredDisplayLocales;
	ValueListenable<List<Locale>> get preferredDisplayLocales => _preferredDisplayLocales;

	@override
	Future<void> load() async {
		final local = await isar.appearanceSettings.get(1);
		store = local ?? AppearanceSettingsStore.defaultSettings;

		if (local == null) {
			isar.writeTxn(() => isar.appearanceSettings.put(store));
		}

		_themeMode = ValueNotifier(store.themeMode);
		_lightSchemeId = ValueNotifier(store.lightSchemeId);
		_darkSchemeId = ValueNotifier(store.darkSchemeId);
		_preferredDisplayLocales = ValueNotifier(store.preferredDisplayLocales);
	}

	@override
	Future<void> reset() {
		store = AppearanceSettingsStore.defaultSettings;
		_themeMode.value = store.themeMode;
		_lightSchemeId.value = store.lightSchemeId;
		_darkSchemeId.value = store.darkSchemeId;
		_preferredDisplayLocales.value = store.preferredDisplayLocales;

		return isar.writeTxn(() => isar.appearanceSettings.put(store));
	}

	@override
	Stream<Store> watch({bool fireImmediately = false}) {
		return isar.appearanceSettings
			.watchObject(1, fireImmediately: fireImmediately)
			.map((e) => e!);
	}

	Future<void> setSchemeId(SchemeId id, Brightness brightness) {
		switch (brightness) {
			case Brightness.light:
				store = store.copyWith.lightSchemeId(id);
				_darkSchemeId.value = id;
				break;
			case Brightness.dark:
				store = store.copyWith.darkSchemeId(id);
				_lightSchemeId.value = id;
				break;
		}

		return isar.writeTxn(() => isar.appearanceSettings.put(store));
	}

	Future<void> setPreferredDisplayLocales(List<Locale> locales) {
		store = store.copyWith.preferredDisplayLocales(locales);
		_preferredDisplayLocales.value = locales;

		return isar.writeTxn(() => isar.appearanceSettings.put(store));
	}

	Future<void> resetPreferredDisplayLocales() {
		store = store.copyWith.preferredDisplayLocales(AppearanceSettingsStore.defaultSettings.preferredDisplayLocales);
		_preferredDisplayLocales.value = store.preferredDisplayLocales;

		return isar.writeTxn(() => isar.appearanceSettings.put(store));
	}
}