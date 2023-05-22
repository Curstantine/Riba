import "package:flutter/material.dart";
import "package:riba/repositories/mangadex/models/manga.dart";
import "package:riba/routes/settings/widgets/dialogs/list_selection.dart";
import "package:riba/routes/settings/widgets/extra.dart";
import "package:riba/routes/settings/widgets/list_tile.dart";
import "package:riba/settings/content_filter/controller.dart";
import "package:riba/settings/settings.dart";

class SettingsFilteringContentRatingSegment extends StatefulWidget {
	const SettingsFilteringContentRatingSegment({super.key});

	@override
	State<SettingsFilteringContentRatingSegment> createState() => _SettingsFilteringContentRatingSegmentState();
}

class _SettingsFilteringContentRatingSegmentState extends State<SettingsFilteringContentRatingSegment> {
	ContentFilterSettingsController get controller => Settings.instance.contentFilter;

	@override
	Widget build(BuildContext context) {
		return Column(
			mainAxisSize: MainAxisSize.min,
			crossAxisAlignment: CrossAxisAlignment.start,
			children: [
				const SegmentTitle(title: "Content Rating"),
				ValueListenableListTile(
					valueListenable: controller.contentRatings,
					isThreeLine: false,
					title: "Allowed content ratings",
					subtitle: "Controls which type of explicit content is allowed.",
					onTap: showContentRatingDialog,
				)
			],
		);
	}

	Future<void> showContentRatingDialog(BuildContext context, List<ContentRating> contentRatings) async {
		final newContentRating = await showDialog<List<ContentRating>>(
			context: context,
			useSafeArea: false,
			builder: (context) => ListSelectionDialog<ContentRating>(
				title: "Content Ratings",
				description: "Only titles rated with the below ratings will be shown. Leave this empty to allow all.",
				currentValue: contentRatings,
				values: ContentRating.values,
				onReset: controller.resetContentRatings,
			),
		);

		if (newContentRating == null) return;
		await controller.setContentRatings(newContentRating);
	}
}