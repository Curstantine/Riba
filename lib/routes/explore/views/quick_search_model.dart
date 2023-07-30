// ignore_for_file: public_member_api_docs, sort_constructors_first
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:isar/isar.dart";
import "package:logging/logging.dart";
import "package:riba/repositories/local/models/author.dart";
import "package:riba/repositories/local/models/history.dart";
import "package:riba/repositories/local/models/tag.dart";
import "package:riba/repositories/mangadex/mangadex.dart";
import "package:riba/repositories/mangadex/models/manga.dart";
import "package:riba/repositories/mangadex/models/tag.dart";
import "package:riba/repositories/mangadex/services/author.dart";
import "package:riba/repositories/mangadex/services/group.dart";
import "package:riba/repositories/mangadex/services/manga.dart";
import "package:riba/repositories/runtime/collection.dart";
import "package:riba/repositories/runtime/group.dart";
import "package:riba/repositories/runtime/manga.dart";
import "package:riba/routes/explore/model.dart";
import "package:riba/routes/explore/widgets/quick_search_filter_dialog.dart";
import "package:riba/routes/manga/views/model.dart";
import "package:riba/routes/manga/views/result_list.dart";
import "package:riba/routes/manga/views/view.dart";
import "package:riba/settings/settings.dart";
import "package:riba/utils/database.dart";
import "package:riba/utils/view_model.dart";
import "package:rxdart/rxdart.dart";

class QuickSearchViewModel implements ViewModel {
	QuickSearchViewModel._internal();

	static QuickSearchViewModel? _instance;
	static QuickSearchViewModel get instance {
		return _instance ??= QuickSearchViewModel._internal().._init();
	}

	@override
	final logger = Logger("QuickSearchViewModel");

	final _historyController = BehaviorSubject<List<History>>();
	ValueStream<List<History>> get historyStream => _historyController.stream;

	final _mangaController = BehaviorSubject<List<MangaData>>();
	ValueStream<List<MangaData>> get mangaStream => _mangaController.stream;

	final _authorController = BehaviorSubject<List<Author>>();
	ValueStream<List<Author>> get authorStream => _authorController.stream;

	final _groupController = BehaviorSubject<List<GroupData>>();
	ValueStream<List<GroupData>> get groupStream => _groupController.stream;

	final _tagsController = BehaviorSubject<Map<TagGroup, List<Tag>>>();
	ValueStream<Map<TagGroup, List<Tag>>> get tagsStream => _tagsController.stream;

	QuickSearchFilterState filterState = QuickSearchFilterState.empty();

	Future<void> _init() async {
		_fetchQueryHistory();
		
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

			// Sort the tags by their name
			for (final group in grouped.keys) {
				grouped[group]!.sort(
					(a, b) => a.name.compareTo(b.name, Settings.instance.appearance.preferredDisplayLocales.value),
				);
			}

			_tagsController.add(grouped);
		} catch (e) {
			_tagsController.addError(e);
		}
	}


	Future<void> refresh() async {
		final query = ExploreViewModel.instance.searchController.text;

		if (query.isEmpty) {
			_mangaController.add([]);
			_authorController.add([]);
			_groupController.add([]);

			if (_historyController.value.isEmpty) {
				await _fetchQueryHistory();
			}

			return;
		} else if (_historyController.value.isNotEmpty) {
			_historyController.add([]);
		}

		try {
			final manga = await _getMangaWithFilters(query: query);
			_mangaController.add(manga.data);
		} catch (e) {
			_mangaController.addError(e);
		}

		try {
			final authors = await MangaDex.instance.author.withFilters(overrides: MangaDexAuthorWithFilterQueryFilter(
				name: query,
				limit: 5,
				orderByNameDesc: true,
			));

			_authorController.add(authors.data);
		} catch (e) {
			_authorController.addError(e);
		}

		try {
			final groups = await MangaDex.instance.group.withFilters(overrides: MangaDexGroupWithFilterQueryFilter(
				name: query,
				limit: 5,
				orderByFollowedCountDesc: true,
			));

			_groupController.add(groups.data);
		} catch (e) {
			_groupController.addError(e);
		}
	}

	/// Adds a search history entry of [type] to the database.
	/// 
	/// Internally this checks for duplicate entries and only adds them if they don't exist.
	Future<void> addSearchHistory(String value, HistoryType type) async {
		try {
			await Database.instance.local.writeTxn(() async {
				final history = await Database.instance.local.history
					.where()
					.typeEqualTo(type)
					.filter()
					.createdAtBetween(DateTime.now().subtract(const Duration(days: 1)), DateTime.now())
					.valueEqualTo(value)
					.count();

				if (history != 0) return;

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

	void showFilterSheet(BuildContext context) async {
		final QuickSearchFilterState? result = await showDialog(
			context: context,
			useSafeArea: false,
			builder: (context) => QuickSearchFilterDialog(
				initialState: filterState.copy(),
				tagStream: tagsStream,
			),
		);

		if (result != null) {
			filterState.inheritFrom(result);
			refresh();
		} 
	}

	void onMangaListExpansion(BuildContext context) {
		final query = ExploreViewModel.instance.searchController.text;
		final future = _getMangaWithFilters(limit: 100, query: query);

		addSearchHistory(query, HistoryType.query);

		Navigator.push(context, MaterialPageRoute(
			builder: (context) => MangaResultList(
				title: "Results for \"$query\"",
				future: future,
				onListItemPress: (mangaData) => onMangaListItemPress(context, mangaData),
			)
		));
	}

	void onMangaListItemPress(BuildContext context, MangaData mangaData) {
		final nestedViewModel = MangaViewModel(mangaId: mangaData.manga.id);

		Navigator.push(context, MaterialPageRoute(
			builder: (_) => MangaView(viewModel: nestedViewModel, initialData: mangaData)
		));
	}

	Future<void> _fetchQueryHistory() async {
		try {
			final history = await Database.instance.local.history.where()
				.typeEqualTo(HistoryType.query)
				.sortByCreatedAt()
				.limit(5)
				.findAll();

			_historyController.add(history);
		} catch (e) {
			_historyController.addError(e);
		}
	}

	Future<CollectionData<MangaData>> _getMangaWithFilters({int limit = 5, String? query}) => MangaDex.instance.manga.withFilters(
		overrides: MangaDexMangaWithFiltersQueryFilter(
			limit: limit,
			title: query,
			contentRatings: filterState.contentRatings.value,
			statuses: filterState.publicationStatuses.value,
			includedTagIds: filterState.getAllTagIdsFor(TagSelectionMode.included),
			excludedTagIds: filterState.getAllTagIdsFor(TagSelectionMode.excluded),
			includedTagJoinMode: filterState.tagInclusionMode.value,
			excludedTagJoinMode: filterState.tagExclusionMode.value,
			originalLanguages: Settings.instance.contentFilter.originalLanguages.value,
		),
	);

	@override
	void dispose() {
		_historyController.close();
		_mangaController.close();
		_authorController.close();
		_groupController.close();
		_tagsController.close();

		filterState.dispose();

		_instance = null;
	}
}

enum TagSelectionMode {
	included,
	excluded,
	none;
}

class QuickSearchFilterState {
	final ValueNotifier<List<ContentRating>> contentRatings;
	final ValueNotifier<List<MangaPublicationStatus>> publicationStatuses;

	final ValueNotifier<TagJoinMode> tagInclusionMode;
	final ValueNotifier<TagJoinMode> tagExclusionMode;
	final Map<String, ValueNotifier<TagSelectionMode>> tagSelection;

	QuickSearchFilterState({
		required this.contentRatings,
		required this.publicationStatuses,
		required this.tagInclusionMode,
		required this.tagExclusionMode,
		required this.tagSelection,
	});

	bool get isEmpty => this == QuickSearchFilterState.empty();

	/// Creates a default [QuickSearchFilterState]
	factory QuickSearchFilterState.empty() {
		return QuickSearchFilterState(
			contentRatings: ValueNotifier(Settings.instance.contentFilter.contentRatings.value),
			publicationStatuses: ValueNotifier(MangaPublicationStatus.values.toList()),
			tagInclusionMode: ValueNotifier(TagJoinMode.and),
			tagExclusionMode: ValueNotifier(TagJoinMode.or),
			tagSelection: {},
		);
	}

	/// Inherit all the values of [other] while updating the old
	/// notifiers if they exist.
	void inheritFrom(QuickSearchFilterState other) {
		contentRatings.value = other.contentRatings.value;
		publicationStatuses.value = other.publicationStatuses.value;
		tagInclusionMode.value = other.tagInclusionMode.value;
		tagExclusionMode.value = other.tagExclusionMode.value;

		for (final key in other.tagSelection.keys) {
			if (tagSelection.containsKey(key)) {
				tagSelection[key]!.value = other.tagSelection[key]!.value;
			} else {
				tagSelection[key] = other.tagSelection[key]!;
			}
		}
	}

	/// Copies self into a new instance
	QuickSearchFilterState copy() {
		return QuickSearchFilterState(
			contentRatings: ValueNotifier(contentRatings.value),
			publicationStatuses: ValueNotifier(publicationStatuses.value),
			tagInclusionMode: ValueNotifier(tagInclusionMode.value),
			tagExclusionMode: ValueNotifier(tagExclusionMode.value),
			tagSelection: tagSelection.map((key, value) => MapEntry(key, ValueNotifier(value.value))),
		);
	}

	List<String> getAllTagIdsFor(TagSelectionMode mode) {
		return tagSelection.entries.where((e) => e.value.value == mode).map((e) => e.key).toList();
	}

	/// Disposes all the notifiers
	void dispose() {
		contentRatings.dispose();
		publicationStatuses.dispose();
		tagInclusionMode.dispose();
		tagExclusionMode.dispose();

		for (final notifier in tagSelection.values) {
			notifier.dispose();
		}
	}

	@override
	bool operator ==(covariant QuickSearchFilterState other) {
		if (identical(this, other)) return true;
	
		return 
		other.contentRatings == contentRatings &&
		other.publicationStatuses == publicationStatuses &&
		other.tagInclusionMode == tagInclusionMode &&
		other.tagExclusionMode == tagExclusionMode &&
		mapEquals(other.tagSelection, tagSelection);
	}

	@override
	int get hashCode => 
		contentRatings.hashCode ^ 
		publicationStatuses.hashCode ^
		tagInclusionMode.hashCode ^
		tagExclusionMode.hashCode ^
		tagSelection.hashCode;
}
