import "package:flutter/material.dart" hide SearchBar;
import "package:flutter_animate/flutter_animate.dart";
import "package:riba/repositories/local/models/history.dart";
import "package:riba/repositories/runtime/manga.dart";
import "package:riba/routes/explore/model.dart";
import "package:riba/routes/manga/widgets/cards.dart";
import "package:riba/utils/constants.dart";
import "package:riba/widgets/error_card.dart";
import "package:riba/widgets/material/skeleton_loaders.dart";

class QuickSearchView extends StatelessWidget {
	const QuickSearchView({super.key});

	ExploreViewModel get viewModel => ExploreViewModel.instance;


	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		final text = theme.textTheme;

		return CustomScrollView(
			slivers: [
				const SliverPadding(padding: Edges.topSmall),
				buildRecentList(text),
				buildMangaList(text),
			],
		);
	}

	Widget buildRecentList(TextTheme text) {
		return StreamBuilder<List<History>>(
			stream: viewModel.quickSearchHistoryStream,
			builder: (context, snapshot) {
				if (!snapshot.hasData) {
					return SliverToBoxAdapter(
						child: Column(
							mainAxisSize: MainAxisSize.min,
							crossAxisAlignment: CrossAxisAlignment.start,
							children: [
							Padding(
								padding: Edges.horizontalLarge,
								child: TextSkeleton(style: text.titleSmall!, width: 100)),
							for (final _ in List.generate(5, (index) => index))
								const ListTileSkeleton(useLeadingIcon: true),
							],
						),
					);
				}

				final histories = snapshot.requireData;
				if (histories.isEmpty) {
					return const SliverToBoxAdapter();
				}

				return SliverList(delegate: SliverChildListDelegate([
					Padding(
						padding: Edges.horizontalLarge,
						child: Text("Recent searches", style: text.titleSmall)),
					for (final history in histories)
						ListTile(
							leading: const Icon(Icons.history),
							title: Text(history.value),
							onTap: () => viewModel.quickSearchController.text = history.value)
				].animate().fadeIn()));
			},
		);
	}

	Widget buildMangaList(TextTheme text) {
		return StreamBuilder<List<MangaData>>(
			stream: viewModel.quickSearchMangaStream,
			builder: (context, snapshot) {
				if (snapshot.hasError) {
					return SliverToBoxAdapter(child: SizedBox(
						height: 100,
						child: ErrorCard(
							margin: Edges.horizontalLarge,
							error: snapshot.error),
					));
				}

				if (!snapshot.hasData) {
					return SliverList.list(children: AnimateList(
						effects: [
							const FadeEffect(
								duration: Durations.emphasized,
								curve: Easing.emphasized)
						],
						children: [
							Padding(
								padding: Edges.horizontalLarge,
								child: TextSkeleton(style: text.titleSmall!, width: 100)),
							SizedBox(height: 250, child: ListView.separated(
								itemCount: 3,
								scrollDirection: Axis.horizontal,
								padding: Edges.horizontalLarge,
								physics: const NeverScrollableScrollPhysics(),
								separatorBuilder: (_, __) => const SizedBox(width: Edges.small),
								itemBuilder: (_, __) => const MangaCardSkeleton(),
							)),
						],
					));
				}

				final manga = snapshot.requireData;
				if (manga.isEmpty) {
					return const SliverToBoxAdapter();
				}

				return SliverList.list(children: AnimateList(
					effects: [
						const FadeEffect(
							duration: Durations.emphasized,
							curve: Easing.emphasized)
					],
					children: [
						Padding(
							padding: Edges.horizontalLarge,
							child: Text("Manga", style: text.titleSmall)),
						SizedBox(height: 275, child: ListView.separated(
							itemCount: manga.length,
							scrollDirection: Axis.horizontal,
							padding: Edges.horizontalLarge,
							separatorBuilder: (_, __) => const SizedBox(width: Edges.small),
							itemBuilder: (_, index) {
								final mangaData = manga[index];
								return MangaCard(
									key: ValueKey(mangaData.manga.id),
									mangaData: mangaData,
									onPress: () => viewModel.addSearchHistory(mangaData.manga.id, HistoryType.manga),
								);
							},
						)),
					],
				));
			},
		);
	}
}