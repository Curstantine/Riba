import "package:flutter/material.dart";
import "package:logging/logging.dart";
import "package:riba/repositories/mangadex/mangadex.dart";
import "package:riba/repositories/mangadex/services/group.dart";
import "package:riba/settings/manga_filter/store.dart";
import "package:riba/utils/constants.dart";
import "package:riba/widgets/error_card.dart";

class ChapterFilterSheet extends StatefulWidget {
	const ChapterFilterSheet({
		super.key,
		required this.padding,
		required this.data,
		required this.onApply,
	});

	final EdgeInsets padding;
	final ChapterFilterSheetData data;
	final void Function(MangaFilterSettingsStore) onApply;

	@override
	State<ChapterFilterSheet> createState() => _ChapterFilterSheetState();
}

class _ChapterFilterSheetState extends State<ChapterFilterSheet> {
	final logger = Logger("ChapterFilterSheet");

	late final Map<String, ValueNotifier<bool>> _groupValues = {
		for (final id in widget.data.groupIds)
		id: ValueNotifier(!widget.data.filterSettings.excludedGroupIds.contains(id))
	};

	late final groupFuture = MangaDex.instance.group
		.getManyAsSingle(overrides: MangaDexGroupGetManyAsSingleQueryFilter(ids: widget.data.groupIds));

	@override
	Widget build(context) {
		final theme = Theme.of(context);
		final text = theme.textTheme;
		final colors = theme.colorScheme;

		return CustomScrollView(
			shrinkWrap: true,
			slivers: [
				buildChapterGroups(text, colors),
				const SliverToBoxAdapter(child: SizedBox(height: Edges.large)),
				SliverPadding(padding: Edges.horizontalMedium.copyWith(bottom: Edges.medium), sliver: SliverToBoxAdapter(
					child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
						TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
						const SizedBox(width: Edges.small),
						FilledButton(onPressed: apply, child: const Text("Apply")),
					]),
				)),
			],
		);
	}

	Widget buildChapterGroups(TextTheme text, ColorScheme colors) {
		return SliverList.list(children: [
			Padding(padding: Edges.leftMedium.copyWith(right: Edges.small), child: Row(children: [
				Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
					Text("Chapter Groups", style: text.titleMedium),
					Text("Select which groups to include in the chapter list",
						style: text.bodySmall?.copyWith(color: colors.onSurfaceVariant)),
				]),
				const Spacer(),
				TextButton(onPressed: reset, child: const Text("Reset"))
			])),
			const SizedBox(height: Edges.small),
			FutureBuilder(
				future: groupFuture,
				builder: (context, snapshot) {
					if (snapshot.connectionState != ConnectionState.done) {
						return const Center(child: CircularProgressIndicator());
					}

					if (snapshot.hasError) {
						return  ErrorCard(error: snapshot.error, margin: Edges.horizontalSmall);
					}

					final groups = snapshot.requireData;
					final items = groups.values.map((group) => ValueListenableBuilder(
						valueListenable: _groupValues[group.id]!,
						builder: (context, value, _) => CheckboxListTile(
							dense: true,
							value: value,
							onChanged: (value) => _groupValues[group.id]!.value = value!,
							title: Text(group.name, style: text.bodyMedium),
						),
					));

					return Column(mainAxisSize: MainAxisSize.min, children: items.toList());
				},
			),
		]);
	}

	void apply() {
		logger.info("Applying manga filter changes. (${widget.data.mangaId})");

		final newFilter = widget.data.filterSettings.copyWith(
			excludedGroupIds: _groupValues.entries
				.where((entry) => !entry.value.value)
				.map((entry) => entry.key)
				.toList(),
		);

		widget.onApply.call(newFilter);
	}

	void reset() {
		logger.info("Resetting manga filter changes. (${widget.data.mangaId})");
		widget.onApply.call(MangaFilterSettingsStore.defaultSettings(widget.data.mangaId));
	}
}

class ChapterFilterSheetData {
	final String mangaId;

	/// Group IDs belonging to the chapter list.
	/// Regardless of whether they are excluded or not.
	final List<String> groupIds;
	final MangaFilterSettingsStore filterSettings;

	const ChapterFilterSheetData({
		required this.filterSettings,
		required this.groupIds,
		required this.mangaId,
	});
}
