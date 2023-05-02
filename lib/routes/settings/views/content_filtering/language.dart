	import "package:flutter/material.dart";
import "package:isar/isar.dart";
import "package:riba/repositories/local/models/localization.dart";
import "package:riba/routes/settings/widgets/dialogs/language_selection.dart";
import "package:riba/routes/settings/widgets/extra.dart";
import "package:riba/routes/settings/widgets/list_tile.dart";
import "package:riba/settings/content_filters.dart";

class SettingsContentFilteringLanguageSegment extends StatefulWidget {
	const SettingsContentFilteringLanguageSegment({super.key});

	@override
	State<SettingsContentFilteringLanguageSegment> createState() => _SettingsContentFilteringLanguageSegmentState();
}

class _SettingsContentFilteringLanguageSegmentState extends State<SettingsContentFilteringLanguageSegment> {
	final originalLanguagesStream = ContentFilterSettings.ref
		.where()
		.keyEqualTo(ContentFilterSettings.isarKey)
		.originalLanguagesProperty()
		.watch(fireImmediately: true)
		.asyncMap((e) => e.first);

	final chapterLanguagesStream = ContentFilterSettings.ref
		.where()
		.keyEqualTo(ContentFilterSettings.isarKey)
		.chapterLanguagesProperty()
		.watch(fireImmediately: true)
		.asyncMap((e) => e.first);

	final contentRatingsStream = ContentFilterSettings.ref
		.where()
		.keyEqualTo(ContentFilterSettings.isarKey)
		.contentRatingsProperty()
		.watch(fireImmediately: true)
		.asyncMap((e) => e.first);
	
	@override
	Widget build(BuildContext context) {
		return Column(
			mainAxisSize: MainAxisSize.min,
			crossAxisAlignment: CrossAxisAlignment.start,
			children: [
				const SegmentTitle(title: "Language"),
				StreamingListTile(
					isThreeLine: true,
					title: "Allowed original languages",
					stream: originalLanguagesStream,
					subtitle: "Filters out titles that are not published in the selected languages.",
					onTap: showOriginalLanguagesDialog,
				),
			],
		);
	}

	Future<void> showOriginalLanguagesDialog(BuildContext context, List<Language> languages) async {
		await showDialog(
			context: context,
			useSafeArea: false,
			builder: (context) => LanguageSelectionSheet(
				title: "Original languages",
				description: "Only titles published in these languages will be displayed. Leave this empty to allow all.",
				currentValue: languages,
				onConfirm: (newLanguages) => {},
			),
		);
	}
}