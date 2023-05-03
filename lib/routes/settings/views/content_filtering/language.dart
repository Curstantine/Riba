	import "package:flutter/material.dart";
import "package:isar/isar.dart";
import "package:riba/repositories/local/models/localization.dart";
import "package:riba/routes/settings/widgets/dialogs/list_selection.dart";
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

	Future<ContentFilterSettings> get settingsFuture => ContentFilterSettings.ref
		.getByKey(ContentFilterSettings.isarKey)
		.then((e) => e as ContentFilterSettings);
	
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
				StreamingListTile(
					isThreeLine: true,
					title: "Allowed chapter languages",
					stream: chapterLanguagesStream,
					subtitle: "Filters out chapters that are not released in the selected languages.",
					onTap: showChapterLanguagesDialog,
				),
			],
		);
	}

	Future<void> showOriginalLanguagesDialog(BuildContext context, List<Language> languages) async {
		final newLanguages = await showDialog(
			context: context,
			useSafeArea: false,
			builder: (context) => ListSelectionDialog(
				title: "Original languages",
				description: "Only titles published in these languages will be displayed. Leave this empty to allow all.",
				currentValue: languages,
				values: Language.values,
			),
		);

		await ContentFilterSettings.ref.isar.writeTxn(() async {
			final newSettings = (await settingsFuture).copyWith(originalLanguages: newLanguages);
			await ContentFilterSettings.ref.put(newSettings);
		});
	}

	Future<void> showChapterLanguagesDialog(BuildContext context, List<Language> languages) async {
		final newLanguages = await showDialog(
			context: context,
			useSafeArea: false,
			builder: (context) => ListSelectionDialog(
				title: "Original languages",
				description: "Only chapters published in these languages will be displayed. Leave this empty to allow all.",
				currentValue: languages,
				values: Language.values,
			),
		);
		
		await ContentFilterSettings.ref.isar.writeTxn(() async {
			final newSettings = (await settingsFuture).copyWith(chapterLanguages: newLanguages);
			await ContentFilterSettings.ref.put(newSettings);
		});
	}
}