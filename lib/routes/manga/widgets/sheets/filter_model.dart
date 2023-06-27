import "package:flutter/material.dart";
import "package:logging/logging.dart";
import "package:riba/repositories/mangadex/mangadex.dart";
import "package:riba/repositories/mangadex/services/group.dart";
import "package:riba/settings/manga_filter/store.dart";

class ChapterFilterSheetViewModel {
	final logger = Logger("ChapterFilterSheetViewModel");

	final String mangaId;
	final List<String> knownGroupIds;
	final MangaFilterSettingsStore filterSettings;

	ChapterFilterSheetViewModel({
		required this.mangaId,
		required this.knownGroupIds,
		required this.filterSettings,
	});

	late final Map<String, ValueNotifier<bool>> groupSelection = {
		for (final id in knownGroupIds) id: ValueNotifier(!filterSettings.excludedGroupIds.contains(id))
	};

	late final groupData = MangaDex.instance.group
		.getManyAsSingle(overrides: MangaDexGroupGetManyAsSingleQueryFilter(ids: knownGroupIds));


	void apply(BuildContext context) {
		final newFilter = filterSettings.copyWith(
			excludedGroupIds: groupSelection.entries
				.where((entry) => !entry.value.value)
				.map((entry) => entry.key)
				.toList(),
		);

		Navigator.pop(context, newFilter);
	}

	void resetChapterGroups() {
		for (final group in groupSelection.values) {
			group.value = true;
		}		
	}
}