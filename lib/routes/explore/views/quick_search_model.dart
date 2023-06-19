import "package:flutter/material.dart";
import "package:isar/isar.dart";
import "package:logging/logging.dart";
import "package:riba/repositories/local/models/history.dart";
import "package:riba/repositories/local/models/tag.dart";
import "package:riba/repositories/mangadex/mangadex.dart";
import "package:riba/repositories/mangadex/models/tag.dart";
import "package:riba/repositories/mangadex/services/manga.dart";
import "package:riba/repositories/runtime/manga.dart";
import "package:riba/routes/explore/model.dart";
import "package:riba/routes/explore/widgets/quick_search_filter_dialog.dart";
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

	final _mangaController = BehaviorSubject<List<MangaData>>();
	ValueStream<List<MangaData>> get mangaStream => _mangaController.stream;

	final _historyController = BehaviorSubject<List<History>>();
	ValueStream<List<History>> get historyStream => _historyController.stream;

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
		if (query.isEmpty) {
			_mangaController.add([]);
			return;
		}

		try {
			final manga = await MangaDex.instance.manga.withFilters(overrides: MangaDexMangaWithFiltersQueryFilter(
				title: query,
				limit: 5,
				contentRatings: Settings.instance.contentFilter.contentRatings.value,
				originalLanguages: Settings.instance.contentFilter.originalLanguages.value,
			));

			_mangaController.add(manga.data);
		} catch (e) {
			_mangaController.addError(e);
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
	final ValueNotifier<TagJoinMode> tagInclusionMode;
	final ValueNotifier<TagJoinMode> tagExclusionMode;
	final Map<TagGroup, Map<String, ValueNotifier<TagSelectionMode>>> groupedTagSelection;

	QuickSearchFilterState({
		required this.tagInclusionMode,
		required this.tagExclusionMode,
		required this.groupedTagSelection,
	}) :
		assert(
			groupedTagSelection.keys.toSet().containsAll(TagGroup.values),
			"groupedTagSelection must contain all TagGroups"
		);

	/// Creates a default [QuickSearchFilterState]
	factory QuickSearchFilterState.empty() {
		return QuickSearchFilterState(
			tagInclusionMode: ValueNotifier(TagJoinMode.and),
			tagExclusionMode: ValueNotifier(TagJoinMode.or),
			groupedTagSelection: { 
				for (final tagGroup in TagGroup.values) tagGroup: <String, ValueNotifier<TagSelectionMode>>{},
			},
		);
	}

	/// Inherit all the values of [other] while updating the old
	/// notifiers if they exist.
	void inheritFrom(QuickSearchFilterState other) {
		tagInclusionMode.value = other.tagInclusionMode.value;
		tagExclusionMode.value = other.tagExclusionMode.value;

		for (final group in TagGroup.values) {
			final otherGroup = other.groupedTagSelection[group]!;
			final thisGroup = groupedTagSelection[group]!;

			for (final tag in otherGroup.keys) {
				final oldNotifier = thisGroup[tag];

				if (oldNotifier != null) {
					oldNotifier.value = otherGroup[tag]!.value;
					continue;
				}

				thisGroup[tag] = ValueNotifier(otherGroup[tag]!.value);
			}
		}
	}

	/// Copies self into a new instance
	QuickSearchFilterState copy() {
		return QuickSearchFilterState(
			tagInclusionMode: ValueNotifier(tagInclusionMode.value),
			tagExclusionMode: ValueNotifier(tagExclusionMode.value),
			groupedTagSelection: {
				for (final group in TagGroup.values) group: {
					for (final tag in groupedTagSelection[group]!.keys) tag: ValueNotifier(groupedTagSelection[group]![tag]!.value),
				},
			},
		);
	}

	/// Disposes all the notifiers
	void dispose() {
		tagInclusionMode.dispose();
		tagExclusionMode.dispose();

		for (final group in TagGroup.values) {
			for (final notifier in groupedTagSelection[group]!.values) {
				notifier.dispose();
			}
		}
	}
}