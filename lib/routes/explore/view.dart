
import "package:flutter/material.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:riba/repositories/runtime/manga.dart";
import "package:riba/routes/explore/model.dart";
import "package:riba/routes/explore/widgets/quick_search_portal.dart";
import "package:riba/routes/manga/widgets/lists/horizontal.dart";
import "package:riba/utils/constants.dart";
import "package:riba/widgets/error_card.dart";
import "package:riba/widgets/material/skeleton_loaders.dart";

class ExploreView extends StatefulWidget {
	const ExploreView({super.key});

	@override
	State<ExploreView> createState() => _ExploreViewState();
}

class _ExploreViewState extends State<ExploreView> {	
	ExploreViewModel get viewModel => ExploreViewModel.instance;

	@override
	void initState() {
		super.initState();
		viewModel.loadSeasonalMangaData();
	}

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		final text = theme.textTheme;

		return ListView(
			primary: true,
			children: [
				const QuickSearchPortal(),
				const SizedBox(height: Edges.medium),
				buildSeasonal(text),
			],
		);
	}

	Widget buildSeasonal(TextTheme text) {
		return StreamBuilder<Map<String, MangaData>>(
			stream: viewModel.seasonalStream,
			builder: (context, snapshot) {
				if (snapshot.connectionState != ConnectionState.active || !snapshot.hasData) {
					return Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
						Padding(
							padding: Edges.horizontalLarge,
							child: TextSkeleton(style: text.titleSmall!, width: 100)),
						SizedBox(height: 250, child: ListView.separated(
							itemCount: 3,
							scrollDirection: Axis.horizontal,
							padding: Edges.horizontalLarge,
							physics: const NeverScrollableScrollPhysics(),
							separatorBuilder: (_, __) => const SizedBox(width: Edges.small),
							itemBuilder: (_, __) => const MangaCardSkeleton()
								.animate(onPlay: (controller) => controller.repeat())
								.shimmer(delay: Durations.standard, duration: Durations.long),
						)),
					]);
				}

				if (snapshot.hasError || !snapshot.hasData) {
					return SizedBox(
						height: 100,
						child:  ErrorCard(
							margin: Edges.horizontalLarge,
							error: snapshot.error)
					);
				}

				return MangaHorizontalList(
					title: "Seasonal",
					scrollOffset: viewModel.seasonalScroll,
					mangaData: snapshot.requireData,
					reactToCoverSizeChanges: true,
					onCardPress: (mangaData) {
						viewModel.onMangaCardPress(context, mangaData);
					},
				);
			},
		);
	}
}
