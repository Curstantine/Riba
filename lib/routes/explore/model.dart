import "package:flutter/material.dart";
import "package:logging/logging.dart";
import "package:riba/repositories/mangadex/mangadex.dart";
import "package:riba/repositories/mangadex/services/manga.dart";
import "package:riba/repositories/runtime/manga.dart";
import "package:riba/settings/settings.dart";
import "package:riba/utils/view_model.dart";
import "package:rxdart/rxdart.dart";

class ExploreViewModel implements ViewModel {
	static ExploreViewModel? _instance;
	static ExploreViewModel get instance {
		return _instance ??= ExploreViewModel._internal();
	}

	ExploreViewModel._internal() {
		Settings.instance.contentFilter
			.watchLazily()
			.map((e) => loadSeasonalMangaData(force: true));
	}

	@override
	final logger = Logger("ExploreViewModel");

	final seasonalScroll = ValueNotifier<double>(0);
	final searchController = SearchController();

	final _seasonalController = BehaviorSubject<Map<String, MangaData>>();
	ValueStream<Map<String, MangaData>> get seasonalStream => _seasonalController.stream;

	Future<void> loadSeasonalMangaData({bool force = false}) async {
		if (_seasonalController.hasValue && !force) {
			logger.info("Seasonal manga data already loaded, returning cached data.");
			return;
		}

		try {
			final settings = Settings.instance.contentFilter;
			final seasonalList = await MangaDex.instance.customList.getSeasonal();
			final manga = await MangaDex.instance.manga.getMany(
				overrides: MangaDexMangaGetManyQueryFilter(
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

	@override
	void dispose() {
		searchController.dispose();
		_seasonalController.close();
	}
}

