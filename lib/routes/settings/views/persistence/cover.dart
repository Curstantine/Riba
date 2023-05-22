import "package:flutter/material.dart";
import "package:riba/repositories/local/models/cover_art.dart";
import "package:riba/repositories/mangadex/mangadex.dart";
import "package:riba/routes/settings/widgets/extra.dart";
import "package:riba/routes/settings/widgets/list_tile.dart";
import "package:riba/routes/settings/widgets/sheets/cover_size.dart";
import "package:riba/settings/cover_persistence/controller.dart";
import "package:riba/settings/settings.dart";
import "package:riba/utils/constants.dart";
import "package:riba/utils/lazy.dart";

class SettingsPersistenceSegment extends StatefulWidget {
	const SettingsPersistenceSegment({super.key});

  @override
  State<SettingsPersistenceSegment> createState() => _SettingsPersistenceSegmentState();
}

class _SettingsPersistenceSegmentState extends State<SettingsPersistenceSegment> {
	CoverPersistenceSettingsController get controller => Settings.instance.coverPersistence;

	@override
	Widget build(BuildContext context) {
		return Column(
			mainAxisSize: MainAxisSize.min,
			crossAxisAlignment: CrossAxisAlignment.start,
			children: [
				const SegmentTitle(title: "Covers"),
				ValueListenableListTile(
					valueListenable: controller.enabled,
					title: "Persist covers",
					subtitle: "Locally persist all manga covers downloaded while browsing.",
					builder: (context, enabled) => Switch(
						value: enabled,
						onChanged: controller.setEnabled,
					),
				),
				ValueListenableListTile(
					valueListenable: controller.previewSize,
					title: "Preview cover size",
					contextualSubtitle: (context, size) => Text(
						"Using ${size.asHumanReadable().toLowerCase()} size.",
					),
					onTap: (context, size) => showCoverSizeDialog(
						context: context,
						isPreview: true,
						current: size,
						onChanged: controller.setPreviewSize,
					),
				),
				ValueListenableListTile(
					valueListenable: controller.fullSize,
					title: "Full cover size",
					contextualSubtitle: (context, size) => Text(
						"Using ${size.asHumanReadable().toLowerCase()} size.",
					),
					onTap: (context, size) => showCoverSizeDialog(
						context: context,
						isPreview: false,
						current: size,
						onChanged: controller.setFullSize,
					),
				),
				Container(
					width: double.infinity,
					padding: Edges.horizontalLarge.copyWith(top: Edges.medium),
					child: OutlinedButton(
						onPressed: () => clearPersistentCovers(context),
						child: const Text("Clear persistent covers"),
					),
				)
			],
		);
	}

	void showCoverSizeDialog({
		required BuildContext context,
		required bool isPreview,
		required CoverSize current,
		required ValueChanged<CoverSize> onChanged,
	}) => showModalBottomSheet(
			context: context,
			builder: (context) {
				return CoverSizeSheet(
					title: isPreview ? "Preview Cover Size" : "Full Cover Size",
					currentValue: current,
					onChanged: onChanged,
				);
			},
		);

	Future<void> clearPersistentCovers(BuildContext context) async {
		final bool? prompt = await showDialog(
			context: context,
			builder: (context) => AlertDialog(
				title: const Text("Clear persistent covers"),
				content: const Text(
					"Are you sure you want to delete all locally stored manga covers? "
					"This would mean that all the covers would be re-downloaded "
					"when you browse the manga list again.",
				),
				actions: [
					TextButton(child: const Text("Cancel"), onPressed: () => Navigator.pop(context, false)),
					TextButton(child: const Text("Clear"), onPressed: () => Navigator.pop(context, true)),
				],
			),
		);

		if (prompt != true) return;
		await MangaDex.instance.cover.deleteAllPersistent();
		if (context.mounted) {
			showLazyBar(context, "Cover cache cleared successfully.");
		}
	}
}