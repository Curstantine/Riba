
import "package:flutter/material.dart" hide SearchBar;
import "package:flutter_animate/flutter_animate.dart";
import "package:riba/repositories/local/models/history.dart";
import "package:riba/repositories/runtime/manga.dart";
import "package:riba/routes/home/model.dart";
import "package:riba/routes/home/views/explore/model.dart";
import "package:riba/routes/home/widgets/popup_action_button.dart";
import "package:riba/routes/manga/widgets/cards.dart";
import "package:riba/utils/constants.dart";
import "package:riba/utils/debouncer.dart";
import "package:riba/widgets/error_card.dart";
import "package:riba/widgets/material/search.dart";
import "package:riba/widgets/material/skeleton_loaders.dart";
import "package:rxdart/rxdart.dart";


class SearchBarImpl extends StatefulWidget {
	const SearchBarImpl({super.key});

	@override
	State<SearchBarImpl> createState() => _SearchBarImplState();
}

class _SearchBarImplState extends State<SearchBarImpl> {
	final debouncer = Debounce(duration: const Duration(milliseconds: 500));

	ExploreContentViewModel get viewModel => HomeViewModel.instance.exploreViewModel;

	@override
	void initState() {
		super.initState();
		viewModel.quickSearchController.addListener(onInputChange);
		viewModel.initializeQuickSearch();
	}

	@override
	void dispose() {
		super.dispose();
		viewModel.quickSearchController.removeListener(onInputChange);
	}

	void onInputChange() => debouncer.run(() => viewModel.refreshQuickSearch());

	@override
	Widget build(BuildContext context) {
		return Padding(
			padding: Edges.horizontalMedium,
			child: SearchAnchor(
				searchController: viewModel.quickSearchController,
				suggestionsBuilder: (_, __) => [],
				viewBuilder: (_) => _SearchBarSuggestionsView(
					controller: viewModel.quickSearchController,
					historyStream: viewModel.quickSearchHistoryStream,
					mangaStream: viewModel.quickSearchMangaStream,
				),
				viewLeading: IconButton(
					icon: const Icon(Icons.arrow_back_rounded),
					onPressed: () => viewModel.quickSearchController.closeView(null)
				),
				builder: (context, controller) => SearchBar(
					controller: controller,
					trailing: const [
						PopupActionButton()
					],
				),
			),
		);
	}

	Color getSearchBarShadow(Set<MaterialState> states) {
		return Colors.transparent;
	}
}

class _SearchBarSuggestionsView extends StatelessWidget {
	const _SearchBarSuggestionsView({
		required this.controller,
		required this.historyStream,
		required this.mangaStream,
	});

	final SearchController controller;
	final ValueStream<List<History>> historyStream;
	final ValueStream<List<MangaData>> mangaStream;

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
			stream: historyStream,
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
							onTap: () => controller.text = history.value)
				].animate().fadeIn()));
			},
		);
	}

	Widget buildMangaList(TextTheme text) {
		return StreamBuilder<List<MangaData>>(
			stream: mangaStream,
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
								);
							},
						)),
					],
				));
			},
		);
	}
}