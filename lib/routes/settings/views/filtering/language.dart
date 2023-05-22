	import "package:flutter/material.dart";
import "package:riba/repositories/local/models/localization.dart";
import "package:riba/routes/settings/widgets/dialogs/list_selection.dart";
import "package:riba/routes/settings/widgets/extra.dart";
import "package:riba/routes/settings/widgets/list_tile.dart";
import "package:riba/settings/content_filter/controller.dart";
import "package:riba/settings/settings.dart";

class SettingsFilteringLanguageSegment extends StatefulWidget {
	const SettingsFilteringLanguageSegment({super.key});

	@override
	State<SettingsFilteringLanguageSegment> createState() => _SettingsFilteringLanguageSegmentState();
}

class _SettingsFilteringLanguageSegmentState extends State<SettingsFilteringLanguageSegment> {
	ContentFilterSettingsController get controller => Settings.instance.contentFilter;

	@override
	Widget build(BuildContext context) {
		return Column(
			mainAxisSize: MainAxisSize.min,
			crossAxisAlignment: CrossAxisAlignment.start,
			children: [
				const SegmentTitle(title: "Language"),
				ValueListenableListTile(
					valueListenable: controller.originalLanguages,
					isThreeLine: true,
					title: "Allowed original languages",
					subtitle: "Filters out titles that are not published in the selected languages.",
					onTap: showOriginalLanguagesDialog,
				),
				ValueListenableListTile(
					valueListenable: controller.chapterLanguages,
					isThreeLine: true,
					title: "Allowed chapter languages",
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
				onReset: controller.resetOriginalLanguages,
			),
		);

		if (newLanguages == null) return;
		await controller.setOriginalLanguages(newLanguages);
	}

	Future<void> showChapterLanguagesDialog(BuildContext context, List<Language> languages) async {
		final newLanguages = await showDialog(
			context: context,
			useSafeArea: false,
			builder: (context) => ListSelectionDialog(
				title: "Chapter languages",
				description: "Only chapters published in these languages will be displayed. Leave this empty to allow all.",
				currentValue: languages,
				values: Language.values,
				onReset: controller.resetChapterLanguages,
			),
		);
		
		if (newLanguages == null) return;
		await controller.setChapterLanguages(newLanguages);
	}
}