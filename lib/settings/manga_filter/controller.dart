import "package:riba/settings/settings.dart";
import "package:riba/utils/hash.dart";

import "store.dart";

typedef Store = MangaFilterSettingsStore;

class MangaFilterSettingsController extends EntitySettingsController<Store> {
	MangaFilterSettingsController({required super.isar});

	@override
	Future<Store> get(String id) async {
		final local = await isar.mangaFilterSettings.get(fastHash(id));
		final settings = local ?? MangaFilterSettingsStore.defaultSettings(id);

		return settings;
	}

	@override
	Future<void> reset(String id) async {
		final settings = MangaFilterSettingsStore.defaultSettings(id);
		await isar.writeTxn(() => isar.mangaFilterSettings.put(settings));
	}

	@override
	Stream<Store> watch(String id, {bool fireImmediately = false}) {
		return isar.mangaFilterSettings
			.watchObject(fastHash(id), fireImmediately: fireImmediately)
			.map((e) => e ?? MangaFilterSettingsStore.defaultSettings(id));
	}

	@override
	Future<void> update(Store settings, {bool silent = false}) async {
		await isar.writeTxn(() => isar.mangaFilterSettings.put(settings), silent: silent);
	}
}