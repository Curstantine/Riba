import "package:flutter/material.dart" hide SearchBar;
import "package:flutter_animate/flutter_animate.dart";
import "package:riba/repositories/local/models/history.dart";
import "package:riba/repositories/runtime/manga.dart";
import "package:riba/routes/explore/model.dart";
import "package:riba/routes/manga/widgets/cards.dart";
import "package:riba/utils/constants.dart";
import "package:riba/utils/debouncer.dart";
import "package:riba/widgets/error_card.dart";

class QuickSearchView extends StatefulWidget {
	const QuickSearchView({super.key});

	@override
	State<QuickSearchView> createState() => _QuickSearchViewState();
}

class _QuickSearchViewState extends State<QuickSearchView> {
	final debouncer = Debounce(duration: const Duration(milliseconds: 500));

	ExploreViewModel get viewModel => ExploreViewModel.instance;

	@override
	void initState() {
		super.initState();
		viewModel.quickSearchController.addListener(onInputChange);
		viewModel.initializeQuickSearch();
	}

	@override
	void dispose() {
		viewModel.quickSearchController.removeListener(onInputChange);
		super.dispose();
	}

	void onInputChange() => debouncer.run(() => viewModel.refreshQuickSearch());

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		final text = theme.textTheme;
		final colors = theme.colorScheme;

		return CustomScrollView(
			slivers: [
				const SliverPadding(padding: Edges.topSmall),
				buildRecentList(text),
				buildMangaList(text, colors),
			],
		);
	}

	Widget buildRecentList(TextTheme text) {
		return StreamBuilder<List<History>>(
			stream: viewModel.quickSearchHistoryStream,
			builder: (context, snapshot) {
				if (snapshot.hasError) {
					return SliverToBoxAdapter(child: SizedBox(
						height: 100,
						child: ErrorCard(margin: Edges.horizontalLarge,	error: snapshot.error),
					));
				}

				final histories = snapshot.data;
				if (histories == null || histories.isEmpty) {
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
							onTap: () => viewModel.quickSearchController.text = history.value),
					const Padding(padding: Edges.topMedium),
				].animate().fadeIn()));
			},
		);
	}

	Widget buildMangaList(TextTheme text, ColorScheme colors) {
		return StreamBuilder<List<MangaData>>(
			stream: viewModel.quickSearchMangaStream,
			builder: (context, snapshot) {
				if (snapshot.hasError) {
					return SliverToBoxAdapter(child: SizedBox(
						height: 100,
						child: ErrorCard(margin: Edges.horizontalLarge, error: snapshot.error),
					));
				}

				final manga = snapshot.data;
				if (manga == null || manga.isEmpty) {
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