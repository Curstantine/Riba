import "package:flutter/foundation.dart";
import "package:riba/repositories/local/models/localization.dart";
import "package:riba/repositories/mangadex/models/manga.dart";
import "package:riba/settings/settings.dart";

import "store.dart";

typedef Store = ContentFilterSettingsStore;

class ContentFilterSettingsController extends CollectionSettingsController<Store> {
	ContentFilterSettingsController({required super.isar});

	late final ValueNotifier<List<Language>> _originalLanguages;
	ValueListenable<List<Language>> get originalLanguages => _originalLanguages;

	late final ValueNotifier<List<Language>> _chapterLanguages;
	ValueListenable<List<Language>> get chapterLanguages => _chapterLanguages;

	late final ValueNotifier<List<ContentRating>> _contentRatings;
	ValueListenable<List<ContentRating>> get contentRatings => _contentRatings;

	@override
	Future<void> load() async {
		final local = await isar.contentFilterSettings.get(1);
		store = local ?? ContentFilterSettingsStore.defaultSettings;

		if (local == null) {
			isar.writeTxn(() => isar.contentFilterSettings.put(store));
		}

		_originalLanguages = ValueNotifier(store.originalLanguages);
		_chapterLanguages = ValueNotifier(store.chapterLanguages);
		_contentRatings = ValueNotifier(store.contentRatings);
	}

	@override
	Future<void> reset() async {
		store = ContentFilterSettingsStore.defaultSettings;
		_originalLanguages.value = store.originalLanguages;
		_chapterLanguages.value = store.chapterLanguages;
		_contentRatings.value = store.contentRatings;

		await isar.writeTxn(() => isar.contentFilterSettings.put(store));
	}

	@override
	Stream<Store> watch({bool fireImmediately = false}) {
		return isar.contentFilterSettings.watchObject(1, fireImmediately: fireImmediately) as Stream<Store>;
	}

	Future<void> setOriginalLanguages(List<Language> originalLanguages) async {
		store = store.copyWith(originalLanguages: originalLanguages);
		_originalLanguages.value = originalLanguages;

		await isar.writeTxn(() => isar.contentFilterSettings.put(store));
	}

	Future<void> resetOriginalLanguages() async {
		store = store.copyWith(originalLanguages: ContentFilterSettingsStore.defaultSettings.originalLanguages);
		_originalLanguages.value = store.originalLanguages;

		await isar.writeTxn(() => isar.contentFilterSettings.put(store));
	}

	Future<void> setChapterLanguages(List<Language> chapterLanguages) async {
		store = store.copyWith(chapterLanguages: chapterLanguages);
		_chapterLanguages.value = chapterLanguages;

		await isar.writeTxn(() => isar.contentFilterSettings.put(store));
	}

	Future<void> resetChapterLanguages() async {
		store = store.copyWith(chapterLanguages: ContentFilterSettingsStore.defaultSettings.chapterLanguages);
		_chapterLanguages.value = store.chapterLanguages;

		await isar.writeTxn(() => isar.contentFilterSettings.put(store));
	}

	Future<void> setContentRatings(List<ContentRating> contentRatings) async {
		store = store.copyWith(contentRatings: contentRatings);
		_contentRatings.value = contentRatings;

		await isar.writeTxn(() => isar.contentFilterSettings.put(store));
	}

	Future<void> resetContentRatings() async {
		store = store.copyWith(contentRatings: ContentFilterSettingsStore.defaultSettings.contentRatings);
		_contentRatings.value = store.contentRatings;

		await isar.writeTxn(() => isar.contentFilterSettings.put(store));
	}
}