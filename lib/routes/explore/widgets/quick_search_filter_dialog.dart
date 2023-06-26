import "package:flutter/material.dart" hide Chip, Locale;
import "package:material_symbols_icons/symbols.dart";
import "package:riba/repositories/local/models/localization.dart";
import "package:riba/repositories/local/models/tag.dart";
import "package:riba/repositories/mangadex/models/manga.dart";
import "package:riba/repositories/mangadex/models/tag.dart";
import "package:riba/routes/explore/model.dart";
import "package:riba/routes/explore/views/quick_search_model.dart";
import "package:riba/settings/settings.dart";
import "package:riba/utils/constants.dart";
import "package:riba/widgets/error_card.dart";
import "package:riba/widgets/material/chip.dart";
import "package:riba/widgets/premade/filter_chip.dart";


class QuickSearchFilterDialog extends StatefulWidget {
	/// Dialog that allows the user to filter the quick search results
	/// 
	/// The dialog will be dismissed with a [QuickSearchFilterState] value when the user submits the filter.
	const QuickSearchFilterDialog({super.key});

	@override
	State<QuickSearchFilterDialog> createState() => _QuickSearchFilterDialogState();
}

class _QuickSearchFilterDialogState extends State<QuickSearchFilterDialog> {
	QuickSearchViewModel get viewModel => QuickSearchViewModel.instance;
	ExploreViewModel get rootViewModel => ExploreViewModel.instance;

	final state = QuickSearchViewModel.instance.filterState.copy();
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
							GenericFilterListChip(status: rating, notifier: state.contentRating),
							const SizedBox(width: Edges.small),
						]
						
					])),
					const SizedBox(height: Edges.small),
				])),
				SliverPadding(padding: Edges.horizontalMedium, sliver: SliverList.list(children: [
					Text("Publication Status", style: text.labelLarge),
					SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: [
						for (final status in MangaPublicationStatus.values) ...[
							GenericFilterListChip(status: status, notifier: state.publicationStatus),
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
				StreamBuilder(stream: viewModel.tagsStream, builder: (context, snapshot) {
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

				/// TODO: Add leading icons when the chip API supports it
				return FilterChipExt(
					showCheckmark: false,
					label: Text(tag.name.getPreferred(preferredLocales), style: text.labelLarge?.copyWith(color: foreground)),
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
