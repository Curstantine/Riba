import "dart:async";

import "package:flutter/material.dart";
import "package:isar/isar.dart";
import "package:riba/repositories/local/models/cover_art.dart";
import "package:riba/repositories/mangadex/mangadex.dart";
import "package:riba/routes/settings/widgets/sheet/cover_size.dart";
import "package:riba/settings/cache.dart";
import "package:riba/utils/constants.dart";
import "package:riba/utils/errors.dart";
import "package:riba/utils/external.dart";
import "package:riba/utils/lazy.dart";

class SettingsCachingView extends StatefulWidget {
  const SettingsCachingView({super.key});

  @override
  State<SettingsCachingView> createState() => _SettingsCachingViewState();
}

class _SettingsCachingViewState extends State<SettingsCachingView> {
	Future<DirectoryInfo> coverDir = Future.delayed(
		const Duration(milliseconds: 500),
		() => getDirectoryInfo(MangaDex.instance.cover.cacheDir),
	);

	final coverCacheEnabledStream = CoverCacheSettings.ref
		.where()
		.keyEqualTo(CoverCacheSettings.isarKey)
		.enabledProperty()
		.watch(fireImmediately: true)
		.asyncMap((e) => e.first);

	final coverPreviewSizeStream = CoverCacheSettings.ref
		.where()
		.keyEqualTo(CoverCacheSettings.isarKey)
		.previewSizeProperty()
		.watch(fireImmediately: true)
		.asyncMap((e) => e.first);

	final coverFullSizeStream = CoverCacheSettings.ref
		.where()
		.keyEqualTo(CoverCacheSettings.isarKey)
		.fullSizeProperty()
		.watch(fireImmediately: true)
		.asyncMap((e) => e.first);
	
	Future<CoverCacheSettings> get settingsFuture => CoverCacheSettings.ref
		.getByKey(CoverCacheSettings.isarKey)
		.then((e) => e as CoverCacheSettings);

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		final textTheme = theme.textTheme;
		final colorScheme = theme.colorScheme;

		return Scaffold(
			appBar: AppBar(title: const Text("Caching")),
			body: ListView(
				children: [
					buildCoversSegment(textTheme, colorScheme),
				],
			),
		);
	}

	Widget buildCoversSegment(TextTheme text, ColorScheme colors) {
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
						buildTitle(text, colors, "Covers"),
						ListTile(
							isThreeLine: true,
							title: const Text("Cache Covers"),
							subtitle: const Text("Locally persist all manga covers downloaded while browsing."),
							trailing: Switch(
								value: enabled,
								onChanged: (value) async {
									final settings = (await settingsFuture).copyWith(enabled: value);
									await CoverCacheSettings.ref.isar.writeTxn(
										() => CoverCacheSettings.ref.put(settings),
									);
								},
							),
						),
						buildStreamListTile(
							text, colors,
							enabled: enabled,
							title: "Preview Cover Size",
							stream: coverPreviewSizeStream,
							contextualSubtitle: (context, size) => Text(
								"Currently using ${size.asHumanReadable().toLowerCase()} for previews.",
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
						buildStreamListTile(
							text, colors,
							enabled: enabled,
							title: "Full Cover Size",
							stream: coverFullSizeStream,
							contextualSubtitle: (context, size) => Text(
								"Currently using ${size.asHumanReadable().toLowerCase()} for full sized covers.",
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
					],
				);
			},
		);
	}

	Padding buildTitle(TextTheme textTheme, ColorScheme colorScheme, String title) {
		return Padding(
			padding: Edges.leftLarge.copyWith(top: Edges.medium, bottom: Edges.extraSmall),
			child: Text(
				title,
				style: textTheme.titleSmall?.copyWith(
					color: colorScheme.primary,
					fontWeight: FontWeight.w600,
				),
			),
		);
	}

	Widget buildStreamListTile<T>(
		TextTheme text, ColorScheme colors, {
		required bool enabled,
		required String title,
		required Stream<T> stream,
		bool isThreeLine = false,
		String? subtitle,
		Function(BuildContext, T)? contextualSubtitle,
		FutureOr<void> Function(BuildContext, T)? onTap,
		Function(BuildContext, T)? builder,
	}) {
		assert(subtitle == null || contextualSubtitle == null);

		return StreamBuilder(stream: stream, builder: (context, snapshot) {
			Widget? child;
			if (snapshot.connectionState != ConnectionState.active && !snapshot.hasData) {
				child = const CircularProgressIndicator();
			}

			if (snapshot.hasError) {
				child = Icon(Icons.error_outline, color: colors.error);
			}

			if (child != null) {
				return SizedBox.fromSize(
					size: const Size.square(24),
					child: Center(child: child),
				);
			}

			return ListTile(
				enabled: enabled,
				title: Text(title),
				subtitle: subtitle != null
					? Text(subtitle)
					: contextualSubtitle!.call(context, snapshot.requireData),
				isThreeLine: isThreeLine,
				onTap: onTap != null ? () => onTap(context, snapshot.requireData) : null,
				trailing: builder?.call(context, snapshot.requireData),
			);
		});
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
				title: const Text("Clear Covers Cache"),
				content: const Text("Are you sure you want to delete all locally cached manga covers?"),
				actions: [
					TextButton(child: const Text("Cancel"), onPressed: () => Navigator.pop(context, false)),
					TextButton(child: const Text("Clear"), onPressed: () => Navigator.pop(context, true)),
				],
			),
		);

		if (prompt != true) return;
		await MangaDex.instance.cover.deleteAllPersistent();
		if (mounted) {
			showLazyBar(context, "Cover cache cleared successfully.");
			coverDir = getDirectoryInfo(MangaDex.instance.cover.cacheDir);
			setState(() {});
		}
  }

	Future<void> setCoverCacheSettings(CoverCacheSettings settings) async {
		await CoverCacheSettings.ref.isar.writeTxn(
			() => CoverCacheSettings.ref.put(settings)
		);
	}
}

