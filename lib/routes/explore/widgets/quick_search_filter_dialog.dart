import "package:flutter/material.dart" hide Chip, Locale;
import "package:riba/repositories/local/models/localization.dart";
import "package:riba/repositories/local/models/tag.dart";
import "package:riba/repositories/mangadex/models/tag.dart";
import "package:riba/routes/explore/model.dart";
import "package:riba/settings/settings.dart";
import "package:riba/utils/constants.dart";
import "package:riba/widgets/error_card.dart";
import "package:riba/widgets/material/chip.dart";


class QuickSearchFilterDialog extends StatefulWidget {
	/// Dialog that allows the user to filter the quick search results
	/// 
	/// The dialog will be dismissed with a `true` value when the user submits the filter.
	const QuickSearchFilterDialog({super.key});

	@override
	State<QuickSearchFilterDialog> createState() => _QuickSearchFilterDialogState();
}

class _QuickSearchFilterDialogState extends State<QuickSearchFilterDialog> {
	ExploreViewModel get viewModel => ExploreViewModel.instance;
	List<Locale> get preferredLocales => Settings.instance.appearance.preferredDisplayLocales.value; 

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		final colors = theme.colorScheme;
		final text = theme.textTheme;

		final media = MediaQuery.of(context);
		final deviceWidth = media.size.width;
		
		return Scaffold(
			body: CustomScrollView(slivers: [
				SliverAppBar(
					floating: true,
					title: Text("Filter", style: text.headlineSmall),
					leading: IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
					actions: [
						IconButton(icon: const Icon(Icons.check), onPressed: () => Navigator.pop(context, true)),
					],
				),
				SliverPadding(padding: Edges.horizontalMedium.copyWithSelf(Edges.verticalLarge), sliver: Builder(builder: (context) {
					final width = deviceWidth / 2 - (Edges.medium + Edges.medium / 2);

					return SliverToBoxAdapter(child: Row(children: [
						DropdownMenu(
							width: width,
							label: const Text("Tag inclusion mode"),
							inputDecorationTheme: const InputDecorationTheme(border: OutlineInputBorder(), isDense: true),
							dropdownMenuEntries: TagJoinMode.values
								.map((e) => DropdownMenuEntry(label: e.asHumanReadable(), value: e))
								.toList(),
							initialSelection: viewModel.quickSearchFilterTagInclusionMode.value,
							onSelected: (value) => {
								if (value != null) viewModel.quickSearchFilterTagInclusionMode.value = value
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
							initialSelection: viewModel.quickSearchFilterTagExclusionMode.value,
							onSelected: (value) => {
								if (value != null) viewModel.quickSearchFilterTagExclusionMode.value = value
							},
						),
					]));
				})),
				StreamBuilder(stream: viewModel.quickSearchFilterTagsStream, builder: (context, snapshot) {
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

								final groupSelectionMap = viewModel.quickSearchGroupedTagSelectionModes[group]!;

								return Wrap(
									spacing: Edges.small,
									children:  tags[group]!
										.map((tag) => buildTag(text, colors, tag, groupSelectionMap[tag.id] ??= ValueNotifier(TagSelectionMode.none)))
										.toList(),
								);
							}
						),
					);
				}),
			]),
		);
	}

	Widget buildTag(TextTheme text, ColorScheme colors, Tag tag, ValueNotifier<TagSelectionMode> modeNotifier) {
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

class QuickSearchFilterState {
	final tagInclusionMode = ValueNotifier<TagJoinMode>(TagJoinMode.and);
	final tagExclusionMode = ValueNotifier<TagJoinMode>(TagJoinMode.or);

	final Map<TagGroup, Map<String, ValueNotifier<TagSelectionMode>>> groupedTagSelection = {
		for (final tagGroup in TagGroup.values) tagGroup: <String, ValueNotifier<TagSelectionMode>>{},
	};

	QuickSearchFilterState();

	QuickSearchFilterState.from(QuickSearchFilterState state) {
		tagInclusionMode.value = state.tagInclusionMode.value;
		tagExclusionMode.value = state.tagExclusionMode.value;

		for (final group in state.groupedTagSelection.entries) {
			for (final tag in group.value.entries) {
				groupedTagSelection[group.key]![tag.key]!.value = tag.value.value;
			}
		}
	}
}