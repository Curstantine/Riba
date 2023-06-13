
import "package:flutter/material.dart";
import "package:isar/isar.dart";
import "package:logging/logging.dart";
import "package:riba/repositories/local/models/history.dart";
import "package:riba/repositories/local/models/tag.dart";
import "package:riba/repositories/mangadex/mangadex.dart";
import "package:riba/repositories/mangadex/models/tag.dart";
import "package:riba/repositories/mangadex/services/manga.dart";
import "package:riba/repositories/runtime/manga.dart";
import "package:riba/settings/settings.dart";
import "package:riba/utils/database.dart";
import "package:rxdart/rxdart.dart";

import "widgets/quick_search_filter_dialog.dart";

class ExploreViewModel {
	static ExploreViewModel? _instance;
	static ExploreViewModel get instance {
		return _instance ??= ExploreViewModel._internal();
	}

	ExploreViewModel._internal();

	final logger = Logger("ExploreViewModel");

	final seasonalScroll = ValueNotifier<double>(0);
	final quickSearchController = SearchController();

	final _seasonalController = BehaviorSubject<Map<String, MangaData>>();
	ValueStream<Map<String, MangaData>> get seasonalStream => _seasonalController.stream;

	final _quickSearchMangaController = BehaviorSubject<List<MangaData>>();
	ValueStream<List<MangaData>> get quickSearchMangaStream => _quickSearchMangaController.stream;

	final _quickSearchHistoryController = BehaviorSubject<List<History>>();
	ValueStream<List<History>> get quickSearchHistoryStream => _quickSearchHistoryController.stream;

	final _quickSearchFilterTagsController = BehaviorSubject<Map<TagGroup, List<Tag>>>();
	ValueStream<Map<TagGroup, List<Tag>>> get quickSearchFilterTagsStream => _quickSearchFilterTagsController.stream;

	final quickSearchIncludedTagIds = <String>[];
	final quickSearchExcludedTagIds = <String>[];
	
	ExploreViewModel() {
		Settings.instance.contentFilter
			.watchLazily()
			.map((e) => loadSeasonalMangaData(force: true));
	}

	Future<void> loadSeasonalMangaData({bool force = false}) async {
		if (_seasonalController.hasValue && !force) {
			logger.info("Seasonal manga data already loaded, returning cached data.");
			return;
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

		try {
			final tags = await MangaDex.instance.manga.getAllTags();
			final grouped = tags.fold(
				<TagGroup, List<Tag>>{},
				(map, tag) {
					if (!map.containsKey(tag.group)) {
						map[tag.group] = [];
					}

					map[tag.group]!.add(tag);
					return map;
				}
			);
			
			_quickSearchFilterTagsController.add(grouped);
		} catch (e) {
			_quickSearchFilterTagsController.addError(e);
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
				limit: 5,
				contentRatings: Settings.instance.contentFilter.contentRatings.value,
				originalLanguages: Settings.instance.contentFilter.originalLanguages.value,
			));

			_quickSearchMangaController.add(manga.data);
		} catch (e) {
			_quickSearchMangaController.addError(e);
		}
	}

	Future<void> addSearchHistory(String value, HistoryType type) async {
		try {
			await Database.instance.local.writeTxn(() async {
				final history = await Database.instance.local.history
					.where()
					.typeEqualTo(HistoryType.query)
					.filter()
					.createdAtBetween(DateTime.now().subtract(const Duration(seconds: 15)), DateTime.now())
					.valueEqualTo(value)
					.count();

				if (history == 0) {
					await Database.instance.local.history.put(History(
						type: type,
						value: value,
						createdAt: DateTime.now(),
					));
				}

				await Database.instance.local.history.put(History(
					type: type,
					value: value,
					createdAt: DateTime.now(),
				));
			});
		} catch (e) {
			logger.warning("Failed to add search history: $e");
		}
	}

	void showQuickSearchFilterSheet(BuildContext context) {
		showDialog(
			context: context,
			useSafeArea: false,
			builder: (context) => const QuickSearchFilterDialog()
		);
	}
}