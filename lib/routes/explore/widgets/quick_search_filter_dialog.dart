import "package:flutter/material.dart" hide Chip, Locale;
import "package:riba/repositories/local/models/localization.dart";
import "package:riba/repositories/mangadex/models/tag.dart";
import "package:riba/routes/explore/model.dart";
import "package:riba/settings/settings.dart";
import "package:riba/utils/constants.dart";
import "package:riba/widgets/error_card.dart";
import "package:riba/widgets/material/chip.dart";

class QuickSearchFilterDialog extends StatelessWidget {
	const QuickSearchFilterDialog({super.key});

	ExploreViewModel get viewModel => ExploreViewModel.instance;
	List<Locale> get preferredLocales => Settings.instance.appearance.preferredDisplayLocales.value; 

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		final colors = theme.colorScheme;
		final text = theme.textTheme;
		
		return Scaffold(
			body: CustomScrollView(slivers: [
				SliverAppBar(
					floating: true,
					title: Text("Filter", style: text.headlineSmall),
					leading: IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
					actions: [
						IconButton(icon: const Icon(Icons.check), onPressed: () => Navigator.pop(context)),
					],
				),
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

								return Wrap(
									spacing: Edges.small,
									children:  tags[group]!
										.map((tag) => FilterChipExt(onSelected: (s) => {} , label: Text(tag.name.getPreferred(preferredLocales))))
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