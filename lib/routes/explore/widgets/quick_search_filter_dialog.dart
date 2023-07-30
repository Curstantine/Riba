import "package:flutter/material.dart" hide Chip, Locale;
import "package:material_symbols_icons/symbols.dart";
import "package:riba/repositories/local/models/localization.dart";
import "package:riba/repositories/local/models/tag.dart";
import "package:riba/repositories/mangadex/models/manga.dart";
import "package:riba/repositories/mangadex/models/tag.dart";
import "package:riba/routes/explore/views/quick_search_model.dart";
import "package:riba/settings/settings.dart";
import "package:riba/utils/constants.dart";
import "package:riba/widgets/error_card.dart";
import "package:riba/widgets/material/chip.dart";
import "package:riba/widgets/premade/filter_chip.dart";
import "package:rxdart/rxdart.dart";


class QuickSearchFilterDialog extends StatefulWidget {
	/// Dialog that allows the user to filter the quick search results
	/// 
	/// The dialog will be dismissed with a [QuickSearchFilterState] value when the user submits the filter.
	const QuickSearchFilterDialog({super.key, required this.initialState, required this.tagStream});

	/// The initial state of the filters.
	/// 
	/// This value gets mutated as the user interacts with the dialog,
	/// so make sure to use a copy of the original state.
	final QuickSearchFilterState initialState;
	final ValueStream<Map<TagGroup, List<Tag>>> tagStream;

	@override
	State<QuickSearchFilterDialog> createState() => _QuickSearchFilterDialogState();
}

class _QuickSearchFilterDialogState extends State<QuickSearchFilterDialog> {
	QuickSearchFilterState get state => widget.initialState;
	List<Locale> get preferredLocales => Settings.instance.appearance.preferredDisplayLocales.value; 

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		final text = theme.textTheme;

		final media = MediaQuery.of(context);
		final deviceWidth = media.size.width;
		
		return Scaffold(
			body: CustomScrollView(slivers: [
				SliverAppBar(
					floating: true,
					title: const Text("Filter"),
					leading: IconButton(icon: const Icon(Symbols.close), onPressed: () => Navigator.pop(context)),
					actions: [
						IconButton(
							icon: const Icon(Symbols.restore_rounded),
							onPressed: () => Navigator.pop(context, QuickSearchFilterState.empty())),
						IconButton(
							icon: const Icon(Symbols.check_rounded),
							onPressed: () => Navigator.pop(context, state)),
					],
				),
				SliverPadding(padding: Edges.horizontalMedium, sliver: SliverList.list(children: [
					Text("Content Rating", style: text.labelLarge),
					SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: [
						for (final rating in ContentRating.values) ...[
							GenericFilterListChip(status: rating, notifier: state.contentRatings),
							const SizedBox(width: Edges.small),
						]
						
					])),
					const SizedBox(height: Edges.small),
				])),
				SliverPadding(padding: Edges.horizontalMedium, sliver: SliverList.list(children: [
					Text("Publication Status", style: text.labelLarge),
					SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: [
						for (final status in MangaPublicationStatus.values) ...[
							GenericFilterListChip(status: status, notifier: state.publicationStatuses),
							const SizedBox(width: Edges.small),
						]
					])),
				])),
				const SliverToBoxAdapter(child: SizedBox(height: 32)),
				/// Looks like this is expensive. (24ms on SM-M215F /w profile mode)
				/// TODO: Tweak it.
				SliverPadding(padding: Edges.horizontalMedium, sliver: Builder(builder: (context) {
					final width = deviceWidth / 2 - (Edges.medium + Edges.medium / 2);

					return SliverToBoxAdapter(child: Row(children: [
						DropdownMenu(
							width: width,
							label: const Text("Tag inclusion mode"),
							inputDecorationTheme: const InputDecorationTheme(border: OutlineInputBorder(), isDense: true),
							dropdownMenuEntries: TagJoinMode.values
								.map((e) => DropdownMenuEntry(label: e.asHumanReadable(), value: e))
								.toList(),
							initialSelection: state.tagInclusionMode.value,
							onSelected: (value) => {
								if (value != null) state.tagInclusionMode.value = value
							},
						),
						const SizedBox(width: Edges.medium),
						DropdownMenu(
							width: width,
							label: const Text("Tag exclusion mode"),
							inputDecorationTheme: const InputDecorationTheme(border: OutlineInputBorder(), isDense: true),
							dropdownMenuEntries: TagJoinMode.values
								.map((e) => DropdownMenuEntry(label: e.asHumanReadable(), value: e))
								.toList(),
							initialSelection: state.tagExclusionMode.value,
							onSelected: (value) => {
								if (value != null) state.tagExclusionMode.value = value
							},
						),
					]));
				})),
				StreamBuilder(stream: widget.tagStream, builder: (context, snapshot) {
					if (snapshot.hasError) {
						return SliverToBoxAdapter(child: SizedBox(
							height: 100,
							child: ErrorCard(margin: Edges.horizontalLarge, error: snapshot.error),
						));
					}

					if (!snapshot.hasData) {
						return const SliverToBoxAdapter(child: SizedBox(
							height: 100,
							child: Center(child: CircularProgressIndicator()),
						));
					}

					final tags = snapshot.requireData;

					return SliverPadding(
						padding: Edges.horizontalMedium,
						sliver: SliverList.builder(
							itemCount: TagGroup.values.length * 2,
							itemBuilder: (context, i) {
								final correctIndex = i ~/ 2;
								final group = TagGroup.values[correctIndex];

								if (i % 2 == 0) {
									return Padding(
										padding: Edges.topLarge,
										child: Text(group.asHumanReadable(), style: text.labelLarge),
									);
								}


								return Wrap(
									spacing: Edges.small,
									children: tags[group]!
										.map((tag) => _FilterTagChip(tag: tag, modeNotifier: state.tagSelection[tag.id] ??= ValueNotifier(TagSelectionMode.none)))
										.toList(),
								);
							}
						),
					);
				}),
			]),
		);
	}
}


class _FilterTagChip extends StatelessWidget {
	final Tag tag;
	final ValueNotifier<TagSelectionMode> modeNotifier;

	const _FilterTagChip({
		required this.tag,
		required this.modeNotifier,
	});

	List<Locale> get preferredLocales => Settings.instance.appearance.preferredDisplayLocales.value; 

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		final colors = theme.colorScheme;
		final text = theme.textTheme;

		return ValueListenableBuilder(
			valueListenable: modeNotifier,
			builder: (context, mode, _) {
				final background = mode == TagSelectionMode.excluded ? colors.errorContainer : null;
				final foreground = mode == TagSelectionMode.excluded ? colors.onErrorContainer : null;
				
				Widget? leadingWidget;
				if (mode == TagSelectionMode.included) {
					leadingWidget = Icon(Symbols.add_rounded, size: 24, grade: 100, color: foreground);
				} else if (mode == TagSelectionMode.excluded) {
					leadingWidget = Icon(Symbols.remove_rounded, size: 24, grade: 100, color: foreground);
				}
	
				return FilterChipExt(
					showCheckmark: false,
					avatar: leadingWidget,
					label: Text(tag.name.getPreferred(preferredLocales) ?? "N/A", style: text.labelLarge?.copyWith(color: foreground)),
					selectedColor: background,
					selected: mode == TagSelectionMode.included || mode == TagSelectionMode.excluded,
					onSelected: (_) {
						switch (mode) {
							case TagSelectionMode.none:
								modeNotifier.value = TagSelectionMode.included;
								break;
							case TagSelectionMode.included:
								modeNotifier.value = TagSelectionMode.excluded;
								break;
							case TagSelectionMode.excluded:
								modeNotifier.value = TagSelectionMode.none;
								break;
						}
					},
				);
			},
		);
	}
}
