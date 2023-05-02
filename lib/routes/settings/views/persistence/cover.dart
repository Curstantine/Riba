import "package:flutter/material.dart";
import "package:isar/isar.dart";
import "package:riba/repositories/local/models/cover_art.dart";
import "package:riba/repositories/mangadex/mangadex.dart";
import "package:riba/routes/settings/widgets/extra.dart";
import "package:riba/routes/settings/widgets/list_tile.dart";
import "package:riba/routes/settings/widgets/sheets/cover_size.dart";
import "package:riba/settings/persistence.dart";
import "package:riba/utils/constants.dart";
import "package:riba/utils/lazy.dart";

class SettingsPersistenceSegment extends StatelessWidget {
	const SettingsPersistenceSegment({super.key});

	@override
	Widget build(BuildContext context) {
		final coverCacheEnabledStream = CoverPersistenceSettings.ref
			.where()
			.keyEqualTo(CoverPersistenceSettings.isarKey)
			.enabledProperty()
			.watch(fireImmediately: true)
			.asyncMap((e) => e.first);

		final coverPreviewSizeStream = CoverPersistenceSettings.ref
			.where()
			.keyEqualTo(CoverPersistenceSettings.isarKey)
			.previewSizeProperty()
			.watch(fireImmediately: true)
			.asyncMap((e) => e.first);

		final coverFullSizeStream = CoverPersistenceSettings.ref
			.where()
			.keyEqualTo(CoverPersistenceSettings.isarKey)
			.fullSizeProperty()
			.watch(fireImmediately: true)
			.asyncMap((e) => e.first);

		final settingsFuture = CoverPersistenceSettings.ref
			.getByKey(CoverPersistenceSettings.isarKey)
			.then((e) => e as CoverPersistenceSettings);

		return Column(
			mainAxisSize: MainAxisSize.min,
			crossAxisAlignment: CrossAxisAlignment.start,
			children: [
				const SegmentTitle(title: "Covers"),
				StreamingListTile(
					title: "Persist covers",
					subtitle: "Locally persist all manga covers downloaded while browsing.",
					stream: coverCacheEnabledStream,
					builder: (context, enabled) => Switch(
						value: enabled,
						onChanged: (value) async {
							final settings = (await settingsFuture).copyWith(enabled: value);
							await CoverPersistenceSettings.ref.isar.writeTxn(
								() => CoverPersistenceSettings.ref.put(settings),
							);
						},
					),
				),
				StreamingListTile(
					title: "Preview cover size",
					stream: coverPreviewSizeStream,
					contextualSubtitle: (context, size) => Text(
						"Using ${size.asHumanReadable().toLowerCase()} size.",
					),
					onTap: (context, size) => showCoverSizeDialog(
						context: context,
						isPreview: true,
						current: size,
						onChanged: (newSize) async {
							final newSettings = (await settingsFuture).copyWith(previewSize: newSize);
							await setPersistenceSettings(newSettings);
						},
					),
				),
				StreamingListTile(
					title: "Full cover size",
					stream: coverFullSizeStream,
					contextualSubtitle: (context, size) => Text(
						"Using ${size.asHumanReadable().toLowerCase()} size.",
					),
					onTap: (context, size) => showCoverSizeDialog(
						context: context,
						isPreview: false,
						current: size,
						onChanged: (newSize) async {
							final newSettings = (await settingsFuture).copyWith(fullSize: newSize);
							await setPersistenceSettings(newSettings);
						},
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

	Future<void> setPersistenceSettings(CoverPersistenceSettings settings) async {
		await CoverPersistenceSettings.ref.isar.writeTxn(
			() => CoverPersistenceSettings.ref.put(settings)
		);
	}
}