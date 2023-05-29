import "package:flutter/foundation.dart";
import "package:riba/repositories/local/models/cover_art.dart";
import "package:riba/settings/settings.dart";

import "store.dart";

typedef Store = CoverPersistenceSettingsStore;

class CoverPersistenceSettingsController extends CollectionSettingsController<Store> {
	CoverPersistenceSettingsController({required super.isar});

	late final ValueNotifier<bool> _enabled;
	ValueListenable<bool> get enabled => _enabled;

	late final ValueNotifier<CoverSize> _previewSize;
	ValueListenable<CoverSize> get previewSize => _previewSize;

	late final ValueNotifier<CoverSize> _fullSize;
	ValueListenable<CoverSize> get fullSize => _fullSize;

	@override
	Future<void> load() async {
		final local = await isar.coverPersistenceSettings.get(1);
		store = local ?? CoverPersistenceSettingsStore.defaultSettings;

		if (local == null) {
			isar.writeTxn(() => isar.coverPersistenceSettings.put(store));
		}

		_enabled = ValueNotifier(store.enabled);
		_previewSize = ValueNotifier(store.previewSize);
		_fullSize = ValueNotifier(store.fullSize);
	}

	@override
	Future<void> reset() async {
		store = CoverPersistenceSettingsStore.defaultSettings;
		_enabled.value = store.enabled;
		_previewSize.value = store.previewSize;
		_fullSize.value = store.fullSize;

		await isar.writeTxn(() => isar.coverPersistenceSettings.put(store));
	}

	@override
	Stream<Store> watch({bool fireImmediately = false}) {
		return isar.coverPersistenceSettings
			.watchObject(1, fireImmediately: fireImmediately)
			.map((e) => e!);
	}

	@override
	Stream<void> watchLazily({bool fireImmediately = false}) {
		return isar.coverPersistenceSettings
			.watchObjectLazy(1, fireImmediately: fireImmediately);
	}

	Future<void> setEnabled(bool enabled) async {
		store = store.copyWith(enabled: enabled);
		_enabled.value = enabled;

		await isar.writeTxn(() => isar.coverPersistenceSettings.put(store));
	}

	Future<void> setPreviewSize(CoverSize previewSize) async {
		store = store.copyWith(previewSize: previewSize);
		_previewSize.value = previewSize;

		await isar.writeTxn(() => isar.coverPersistenceSettings.put(store));
	}

	Future<void> setFullSize(CoverSize fullSize) async {
		store = store.copyWith(fullSize: fullSize);
		_fullSize.value = fullSize;

		await isar.writeTxn(() => isar.coverPersistenceSettings.put(store));
	}
}