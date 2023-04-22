import "package:flutter/material.dart";
import "package:isar/isar.dart";
import "package:riba/repositories/local/models/cover_art.dart";
import "package:riba/repositories/mangadex/mangadex.dart";
import "package:riba/routes/settings/widgets/extra.dart";
import "package:riba/routes/settings/widgets/list_tile.dart";
import "package:riba/routes/settings/widgets/sheets/cover_size.dart";
import "package:riba/settings/cache.dart";
import "package:riba/utils/constants.dart";
import "package:riba/utils/errors.dart";
import "package:riba/utils/lazy.dart";

class SettingsPersistenceSegment extends StatefulWidget {
	const SettingsPersistenceSegment({super.key});

	@override
	State<SettingsPersistenceSegment> createState() => _SettingsPersistenceSegmentState();
}

class _SettingsPersistenceSegmentState extends State<SettingsPersistenceSegment> {
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

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		final text = theme.textTheme;
		final colors = theme.colorScheme;

		return StreamBuilder(
			stream: coverCacheEnabledStream,
			builder: (context, snapshot) {
				// Since the loading indicator is in the header, we don't need to handle other states here.
				if (snapshot.connectionState != ConnectionState.active && !snapshot.hasData) {
					return const SizedBox(
						height: 200,
						child: Center(child: CircularProgressIndicator()),
					);
				}

				if (snapshot.hasError) {
					final error = handleError(snapshot.error!);

					return SizedBox(
						height: 150,
						child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
							Text(error.title, style: text.titleLarge?.copyWith(color: colors.error)),
							const SizedBox(height: 8),
							Text(error.description, style: text.bodySmall),
						]),
					);
				}

				final enabled = snapshot.requireData;

				return Column(
					mainAxisSize: MainAxisSize.min,
					crossAxisAlignment: CrossAxisAlignment.start,
					children: [
						const SegmentTitle(title: "Covers"),
						ListTile(
							isThreeLine: true,
							title: const Text("Persist covers"),
							subtitle: const Text("Locally persist all manga covers downloaded while browsing."),
							trailing: Switch(
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
							enabled: enabled,
							title: "Preview cover size",
							stream: coverPreviewSizeStream,
							contextualSubtitle: (context, size) => Text(
								"Using ${size.asHumanReadable().toLowerCase()} size.",
							),
							onTap: (context, size) => showCoverSizeDialog(
								isPreview: true,
								current: size,
								onChanged: (newSize) async {
									final newSettings = (await settingsFuture).copyWith(previewSize: newSize);
									await setCoverCacheSettings(newSettings);
								},
							),
						),
						StreamingListTile(
							enabled: enabled,
							title: "Full cover size",
							stream: coverFullSizeStream,
							contextualSubtitle: (context, size) => Text(
								"Using ${size.asHumanReadable().toLowerCase()} size.",
							),
							onTap: (context, size) => showCoverSizeDialog(
								isPreview: false,
								current: size,
								onChanged: (newSize) async {
									final newSettings = (await settingsFuture).copyWith(fullSize: newSize);
									await setCoverCacheSettings(newSettings);
								},
							),
						),
						Container(
							width: double.infinity,
							padding: Edges.horizontalLarge.copyWith(top: Edges.medium),
							child: OutlinedButton(
								onPressed: () => deleteCoversCache(context),
								child: const Text("Clear persistent covers"),
							),
						)
					],
				);
			},
		);
	}

	void showCoverSizeDialog({
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

	Future<void> deleteCoversCache(BuildContext context) async {
		final bool? prompt = await showDialog(
			context: context,
			builder: (context) => AlertDialog(
				title: const Text("Clear persistent covers"),
				content: const Text("Are you sure you want to delete all locally cached manga covers?"),
				actions: [
					TextButton(child: const Text("Cancel"), onPressed: () => Navigator.pop(context, false)),
					TextButton(child: const Text("Clear"), onPressed: () => Navigator.pop(context, true)),
				],
			),
		);

		if (prompt == false) return;
		await MangaDex.instance.cover.deleteAllPersistent();
		if (mounted) {
			showLazyBar(context, "Cover cache cleared successfully.");
		}
  }

	Future<void> setCoverCacheSettings(CoverPersistenceSettings settings) async {
		await CoverPersistenceSettings.ref.isar.writeTxn(
			() => CoverPersistenceSettings.ref.put(settings)
		);
	}
}