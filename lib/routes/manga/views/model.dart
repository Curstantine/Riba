import "dart:async";
import "dart:io";

import "package:flutter/material.dart";
import "package:isar/isar.dart";
import "package:logging/src/logger.dart";
import "package:riba/repositories/local/models/manga.dart";
import "package:riba/repositories/local/models/statistics.dart";
import "package:riba/repositories/mangadex/mangadex.dart";
import "package:riba/repositories/mangadex/services/chapter.dart";
import "package:riba/repositories/runtime/chapter.dart";
import "package:riba/repositories/runtime/collection.dart";
import "package:riba/repositories/runtime/manga.dart";
import "package:riba/settings/manga_filter/store.dart";
import "package:riba/settings/settings.dart";
import "package:riba/utils/database.dart";
import "package:riba/utils/hash.dart";
import "package:rxdart/rxdart.dart";

class MangaViewModel {
	final String mangaId;
	
	final logger = Logger("MangaViewModel");
	final expandedAppBarHeight = 500.0;
	final scrollController = ScrollController();

	final showAppBar = ValueNotifier(false);

	final isFollowed = ValueNotifier(false);
	final hasTrackers = ValueNotifier(false);
	final hasCustomLists = ValueNotifier(false);

	int chapterOffset = 0;
	bool areChaptersEntirelyFetched = false;

	final _dataController = BehaviorSubject<MangaData>();
	final _statisticController = BehaviorSubject<Statistics>();
	final _coverController = BehaviorSubject<File?>();
	final _chapterController = BehaviorSubject<CollectionData<ChapterData>>();

	ValueStream<MangaData> get dataStream => _dataController.stream;
	ValueStream<Statistics> get statisticStream => _statisticController.stream;
	ValueStream<File?> get coverStream => _coverController.stream;
	ValueStream<CollectionData<ChapterData>> get chapterStream => _chapterController.stream;

	MangaViewModel({required this.mangaId});

	late MangaFilterSettingsStore baseFilterSettings;
	
	late final coverIdSubStream = Database.instance.local.manga
		.where()
		.isarIdEqualTo(fastHash(mangaId))
		.limit(1)
		.preferredCoverIdProperty()
		.watch()
		.map((event) => event.first)
		.listen(onCoverIdChange);

	Future<void> initialize() async {
		baseFilterSettings = await Settings.instance.mangaFilter.get(mangaId);
		scrollController.addListener(onScroll);
		loadMeta();
	}

	void dispose() {
		scrollController.removeListener(onScroll);
		scrollController.dispose();
		showAppBar.dispose();

		_dataController.close();
		_statisticController.close();
		_coverController.close();
		_chapterController.close();

		coverIdSubStream.cancel();
	}

	Future<void> loadMeta([bool force = false]) async {
		try {
			final manga = await MangaDex.instance.manga.get(mangaId, checkDB: !force);
			_dataController.add(manga);
		} catch (error) {
			_dataController.addError(error);
		}

		try {
			final statistic = await MangaDex.instance.manga.getStatistics(mangaId, checkDB: !force);
			_statisticController.add(statistic);
		} catch (error) {
			_statisticController.addError(error);
		}

		loadCover(force: force);
		loadChapters(reload: force);
	}

	void loadCover({bool force = false, String? coverId}) async {
		if (!_dataController.hasValue) {
			logger.warning("Cover load requested before manga data is loaded");
			return;
		}

		try {
			final cover = coverId != null
				? (await MangaDex.instance.cover.get(coverId, checkDB: !force)).cover
				: _dataController.value.cover;
			
			if (cover == null) {
				return _coverController.add(null);
			}

			final settings = Settings.instance.coverPersistence;
			final image = await MangaDex.instance.cover.getImage(
				mangaId,
				cover,
				size: settings.fullSize.value,
				cache: settings.enabled.value,
			);

			_coverController.add(image);
		} catch (error) {
			_coverController.addError(error);
		}
	}

	/// The initial fetch will first check if there are data available in the database, if it is,
	/// it will display everything available without prioritizing [offset] or [limit].
	///
	/// If there are no data available in the database, it will fetch everything from the API, 
	/// where it will [limit] accordingly.
	///
	/// In all cases, [areChaptersEntirelyFetched] will be set to true if the total number of
	/// chapters displayed is equal to the number of chapters available. This will not account
	/// for chapters that are out-of-sync from the server
	/// (e.g. deleted chapters, chapters published after the last sync.)
	/// 
	/// [chapterOffset] is only used for memo-ing the last offset. Instead, use [offset]
	/// to specify the offset to fetch from.
	/// 
	/// Issues:
	/// 1. When the whole list is not fetched from the get go, any session that
	/// did not load the data from the server will not be able to get chapters after the
	/// initial [offset] since the [areChaptersEntirelyFetched] is true in a database fetch.
	/// Reloading will fix this issue.
	void loadChapters({bool reload = false, int offset = 0}) async {
		logger.info("Fetching chapters with offset $offset");
	
		try {
			final data = await MangaDex.instance.chapter.getFeed(
				checkDB: !reload && offset == 0,
				overrides: MangaDexChapterGetFeedQueryFilter(
					mangaId: mangaId,
					offset: offset,
					excludedGroups: baseFilterSettings.excludedGroupIds,
					translatedLanguages: Settings.instance.contentFilter.chapterLanguages.value,
				),
			);

			chapterOffset += data.data.length;
			areChaptersEntirelyFetched = data.total <= chapterOffset;
			final temp = !_chapterController.hasValue || reload ? data : CollectionData(
				data: _chapterController.value.data..addAll(data.data),
				total: data.total,
				limit: data.limit,
				offset: data.offset,
			);

			_chapterController.add(temp);
		} catch (e) {
			_chapterController.addError(e);
		}
	}

	void onScroll() {
		final height = expandedAppBarHeight - kToolbarHeight;

		if (showAppBar.value && scrollController.offset < height) {
			showAppBar.value = false;
		} else if (!showAppBar.value && scrollController.offset > height) {
			showAppBar.value = true;
		}

		if (scrollController.offset >= scrollController.position.maxScrollExtent) {
			if (!areChaptersEntirelyFetched) loadChapters(offset: chapterOffset);
		}
	}

	void onCoverIdChange(String? newId) async {
		if (!_dataController.hasValue) {
			logger.warning("Cover id changes requested before manga data is loaded");
			return;
		}

		final tempData = _dataController.value.copyWith.manga(
			_dataController.value.manga.copyWith.preferredCoverId(newId)
		);

		_dataController.add(tempData);
		loadCover(coverId: newId);
	}

	Future<void> onFiltersApplied() async {
		chapterOffset = 0;
		areChaptersEntirelyFetched = false;
		baseFilterSettings = await Settings.instance.mangaFilter.get(mangaId);
		loadChapters(offset: 0, reload: !areChaptersEntirelyFetched);
	}

	Future<void> refresh() async {
		chapterOffset = 0;
		areChaptersEntirelyFetched = false;
		loadMeta(true);
	}
}