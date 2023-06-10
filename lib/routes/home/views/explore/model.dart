
import "package:flutter/material.dart";
import "package:isar/isar.dart";
import "package:logging/logging.dart";
import "package:riba/repositories/local/models/history.dart";
import "package:riba/repositories/mangadex/mangadex.dart";
import "package:riba/repositories/mangadex/services/manga.dart";
import "package:riba/repositories/runtime/manga.dart";
import "package:riba/settings/settings.dart";
import "package:riba/utils/database.dart";
import "package:rxdart/rxdart.dart";

class ExploreContentViewModel {
	final logger = Logger("ExploreContent");
	final seasonalScroll = ValueNotifier<double>(0);
	final quickSearchController = SearchController();

	final _seasonalController = BehaviorSubject<Map<String, MangaData>>();
	ValueStream<Map<String, MangaData>> get seasonalStream => _seasonalController.stream;

	final _quickSearchMangaController = BehaviorSubject<List<MangaData>>();
	ValueStream<List<MangaData>> get quickSearchMangaStream => _quickSearchMangaController.stream;

	final _quickSearchHistoryController = BehaviorSubject<List<History>>();
	ValueStream<List<History>> get quickSearchHistoryStream => _quickSearchHistoryController.stream;
	
	ExploreContentViewModel() {
		Settings.instance.contentFilter
			.watchLazily()
			.map((e) => loadSeasonalMangaData(force: true));
	}

	Future<void> loadSeasonalMangaData({bool force = false}) async {
		if (_seasonalController.hasValue && !force) {
			logger.info("Seasonal manga data already loaded, returning cached data.");
			return _seasonalController.add(_seasonalController.value);
		}

		try {
			final settings = Settings.instance.contentFilter;
			final seasonalList = await MangaDex.instance.customList.getSeasonal();
			final manga = await MangaDex.instance.manga.getMany(
				overrides: MangaDexMangaQueryFilter(
					ids: seasonalList.list.mangaIds,
					contentRatings: settings.contentRatings.value,
					originalLanguages: settings.originalLanguages.value,
				),
			);

			_seasonalController.add(manga);
		} catch (e) {
			_seasonalController.addError(e);
		}
	}


	Future<void> initializeQuickSearch() async {
		try {
			final history = await Database.instance.local.history.where()
				.typeEqualTo(HistoryType.query)
				.sortByCreatedAt()
				.limit(5)
				.findAll();

			_quickSearchHistoryController.add(history);
		} catch (e) {
			_quickSearchHistoryController.addError(e);
		}
	}

	Future<void> refreshQuickSearch() async {
		final query = quickSearchController.text;
		if (query.isEmpty) {
			_quickSearchMangaController.add([]);
			return;
		}

		try {
			final manga = await MangaDex.instance.manga.withFilters(overrides: MangaDexMangaQueryFilter(
				title: query,
				contentRatings: Settings.instance.contentFilter.contentRatings.value,
				limit: 5,
				originalLanguages: Settings.instance.contentFilter.originalLanguages.value,
			));

			_quickSearchMangaController.add(manga.data);
		} catch (e) {
			_quickSearchMangaController.addError(e);
		}
	}
}