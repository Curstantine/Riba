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
import "package:riba/repositories/runtime/group.dart";
import "package:riba/repositories/runtime/manga.dart";
import "package:riba/routes/explore/model.dart";
import "package:riba/routes/explore/widgets/quick_search_filter_dialog.dart";
import "package:riba/routes/manga/views/result_list.dart";
import "package:riba/settings/settings.dart";
import "package:riba/utils/database.dart";
import "package:riba/utils/view_model.dart";
import "package:rxdart/rxdart.dart";

class QuickSearchViewModel implements ViewModel {
	QuickSearchViewModel._internal();

	static QuickSearchViewModel? _instance;
	static QuickSearchViewModel get instance {
		return _instance ??= QuickSearchViewModel._internal()..init();
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

	/// TODO: Maybe add filter persistence between sessions?
	QuickSearchFilterState filterState = QuickSearchFilterState.empty();


	Future<void> init() async {
		logger.info("Initializing quick search");
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

			_tagsController.add(grouped);
		} catch (e) {
			_tagsController.addError(e);
		}
	}


	Future<void> refresh() async {
		final query = ExploreViewModel.instance.searchController.text;

		try {
			final manga = await MangaDex.instance.manga.withFilters(overrides: MangaDexMangaWithFiltersQueryFilter(
				title: query,
				limit: 5,
				contentRatings: Settings.instance.contentFilter.contentRatings.value,
				originalLanguages: Settings.instance.contentFilter.originalLanguages.value,
				includedTagIds: filterState.getAllTagIdsFor(TagSelectionMode.included),
				excludedTagIds: filterState.getAllTagIdsFor(TagSelectionMode.excluded),
				includedTagJoinMode: filterState.tagInclusionMode.value,
				excludedTagJoinMode: filterState.tagExclusionMode.value,
			));

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

	void showFilterSheet(BuildContext context) async {
		final QuickSearchFilterState? result = await showDialog(
			context: context,
			useSafeArea: false,
			builder: (context) => const QuickSearchFilterDialog()
		);

		if (result != null) {
			filterState.inheritFrom(result);
			refresh();
		} 
	}

	void onMangaListExpansion(BuildContext context) {
		final query = ExploreViewModel.instance.searchController.text;
		final future = MangaDex.instance.manga.withFilters(overrides: MangaDexMangaWithFiltersQueryFilter(
			title: query,
			contentRatings: Settings.instance.contentFilter.contentRatings.value,
			originalLanguages: Settings.instance.contentFilter.originalLanguages.value,
			includedTagIds: filterState.getAllTagIdsFor(TagSelectionMode.included),
			excludedTagIds: filterState.getAllTagIdsFor(TagSelectionMode.excluded),
			includedTagJoinMode: filterState.tagInclusionMode.value,
			excludedTagJoinMode: filterState.tagExclusionMode.value,
		));

		Navigator.push(context, MaterialPageRoute(
			builder: (context) => MangaResultList(
				title: "Results for \"$query\"",
				future: future,
			)
		));
	}

	@override
	void dispose() {
		filterState.dispose();

		_mangaController.close();
		_historyController.close();
		_tagsController.close();

		_instance = null;
	}
}

enum TagSelectionMode {
	included,
	excluded,
	none;
}

class QuickSearchFilterState {
	final ValueNotifier<List<ContentRating>> contentRating;
	final ValueNotifier<List<MangaPublicationStatus>> publicationStatus;

	final ValueNotifier<TagJoinMode> tagInclusionMode;
	final ValueNotifier<TagJoinMode> tagExclusionMode;
	final Map<String, ValueNotifier<TagSelectionMode>> tagSelection;

	QuickSearchFilterState({
		required this.contentRating,
		required this.publicationStatus,
		required this.tagInclusionMode,
		required this.tagExclusionMode,
		required this.tagSelection,
	});

	bool get isEmpty => this == QuickSearchFilterState.empty();

	/// Creates a default [QuickSearchFilterState]
	factory QuickSearchFilterState.empty() {
		return QuickSearchFilterState(
			contentRating: ValueNotifier(Settings.instance.contentFilter.contentRatings.value),
			publicationStatus: ValueNotifier(MangaPublicationStatus.values.toList()),
			tagInclusionMode: ValueNotifier(TagJoinMode.and),
			tagExclusionMode: ValueNotifier(TagJoinMode.or),
			tagSelection: {},
		);
	}

	/// Inherit all the values of [other] while updating the old
	/// notifiers if they exist.
	void inheritFrom(QuickSearchFilterState other) {
		contentRating.value = other.contentRating.value;
		publicationStatus.value = other.publicationStatus.value;
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
			contentRating: ValueNotifier(contentRating.value),
			publicationStatus: ValueNotifier(publicationStatus.value),
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
		contentRating.dispose();
		publicationStatus.dispose();
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
		other.contentRating == contentRating &&
		other.publicationStatus == publicationStatus &&
		other.tagInclusionMode == tagInclusionMode &&
		other.tagExclusionMode == tagExclusionMode &&
		mapEquals(other.tagSelection, tagSelection);
	}

	@override
	int get hashCode => 
		contentRating.hashCode ^ 
		publicationStatus.hashCode ^
		tagInclusionMode.hashCode ^
		tagExclusionMode.hashCode ^
		tagSelection.hashCode;
}
