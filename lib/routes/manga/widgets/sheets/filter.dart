import "package:flutter/material.dart";
import "package:logging/logging.dart";
import "package:material_symbols_icons/symbols.dart";
import "package:riba/repositories/mangadex/mangadex.dart";
import "package:riba/repositories/mangadex/services/group.dart";
import "package:riba/settings/manga_filter/store.dart";
import "package:riba/utils/constants.dart";
import "package:riba/utils/errors.dart";

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

		return ListView(
			padding: Edges.horizontalLarge.copyWith(top: Edges.extraLarge).add(widget.padding),
			shrinkWrap: true,
			children: [
				...buildChapterGroups(text, colors),
				const SizedBox(height: Edges.large),
				Row(mainAxisAlignment: MainAxisAlignment.end, children: [
					FilledButton.tonal(onPressed: apply, child: const Text("Apply")),
				])
			],
		);
	}

	List<Widget> buildChapterGroups(TextTheme text, ColorScheme colors) {
		return [
			Text("Chapter Groups", style: text.titleMedium),
			Text("Select which groups to include in the chapter list",
				style: text.bodySmall?.copyWith(color: colors.onSurfaceVariant)),
			const SizedBox(height: Edges.small),
			FutureBuilder(
				future: groupFuture,
				builder: (context, snapshot) {
					if (snapshot.connectionState != ConnectionState.done) {
						return const Center(child: CircularProgressIndicator());
					}

					if (snapshot.hasError) {
						final error = handleError(snapshot.error!);
						
						return Center(
							child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
								Icon(Symbols.image_not_supported_rounded, size: 32, color: colors.error),
								const SizedBox(height: Edges.small),
								Text(error.description, style: text.bodySmall)
							]),
						);
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
		];
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
