import "package:flutter/material.dart";
import "package:isar/isar.dart";
import "package:riba/repositories/mangadex/models/manga.dart";
import "package:riba/routes/settings/widgets/dialogs/list_selection.dart";
import "package:riba/routes/settings/widgets/extra.dart";
import "package:riba/routes/settings/widgets/list_tile.dart";
import "package:riba/settings/content_filters.dart";

class SettingsFilteringContentRatingSegment extends StatefulWidget {
	const SettingsFilteringContentRatingSegment({super.key});

	@override
	State<SettingsFilteringContentRatingSegment> createState() => _SettingsFilteringContentRatingSegmentState();
}

class _SettingsFilteringContentRatingSegmentState extends State<SettingsFilteringContentRatingSegment> {
	final contentRatingsStream = ContentFilterSettings.ref
		.where()
		.keyEqualTo(ContentFilterSettings.isarKey)
		.contentRatingsProperty()
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
				const SegmentTitle(title: "Content Rating"),
				StreamingListTile(
					isThreeLine: false,
					title: "Allowed content ratings",
					stream: contentRatingsStream,
					subtitle: "Controls which type of explicit content is allowed.",
					onTap: showContentRatingDialog,
				)
			],
		);
	}

	Future<void> showContentRatingDialog(BuildContext context, List<ContentRating> contentRatings) async {
		final newContentRating = await showDialog(
			context: context,
			useSafeArea: false,
			builder: (context) => ListSelectionDialog<ContentRating>(
				title: "Content Ratings",
				description: "Only titles rated with the below ratings will be shown. Leave this empty to allow all.",
				currentValue: contentRatings,
				values: ContentRating.values,
			),
		);

		await ContentFilterSettings.ref.isar.writeTxn(() async {
			final newSettings = (await settingsFuture).copyWith(contentRatings: newContentRating);
			await ContentFilterSettings.ref.put(newSettings);
		});
	}
}