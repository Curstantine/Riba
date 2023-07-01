import "package:flutter/material.dart" hide SearchBar;
import "package:flutter_animate/flutter_animate.dart";
import "package:material_symbols_icons/symbols.dart";
import "package:riba/repositories/local/models/history.dart";
import "package:riba/repositories/runtime/manga.dart";
import "package:riba/routes/authors/widgets/cards.dart";
import "package:riba/routes/explore/model.dart";
import "package:riba/routes/explore/views/quick_search_model.dart";
import "package:riba/routes/groups/widgets/cards.dart";
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
	/// Why?
	/// 
	/// [SearchController]'s [ValueNotifier] gets updated on input renders,
	/// so if the view is rebuilt, regardless of the input value, notifyListeners
	/// will be called.
	final textValueListenable = ValueNotifier<String?>(ExploreViewModel.instance.searchController.text);
	final debouncer = Debounce(duration: const Duration(milliseconds: 500));

	ExploreViewModel get rootViewModel => ExploreViewModel.instance;
	QuickSearchViewModel get viewModel => QuickSearchViewModel.instance;

	@override
	void initState() {
		super.initState();
		rootViewModel.searchController.addListener(onSearchControllerChange);
		textValueListenable.addListener(onTextValueChange);
	}

	@override
	void dispose() {
		rootViewModel.searchController.removeListener(onSearchControllerChange);
		textValueListenable.removeListener(onTextValueChange);
		viewModel.dispose();
		super.dispose();
	}

	void onSearchControllerChange() => textValueListenable.value = rootViewModel.searchController.text;
	void onTextValueChange() => debouncer.run(() => viewModel.refresh());

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
				buildAuthorList(text, colors),
				buildGroupList(text, colors),
			],
		);
	}

	Widget buildRecentList(TextTheme text) {
		return StreamBuilder<List<History>>(
			stream: viewModel.historyStream,
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

				return SliverList.list(children: [
					Padding(
						padding: Edges.horizontalLarge,
						child: Text("Recent searches", style: text.titleSmall)),
					for (final history in histories)
						ListTile(
							leading: const Icon(Symbols.history_rounded),
							title: Text(history.value),
							onTap: () => rootViewModel.searchController.text = history.value),
					const Padding(padding: Edges.topMedium),
				].animate().fadeIn());
			},
		);
	}

	Widget buildMangaList(TextTheme text, ColorScheme colors) {
		return StreamBuilder<List<MangaData>>(
			stream: viewModel.mangaStream,
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
							child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
								Text("Manga", style: text.titleSmall),
								IconButton(
									onPressed: () => {},
									icon: const Icon(Symbols.navigate_next_rounded), 
									visualDensity: VisualDensity.compact,
								),
							])
						),
						SizedBox(height: 275, child: ListView.separated(
							itemCount: manga.length,
							scrollDirection: Axis.horizontal,
							padding: Edges.horizontalLarge,
							separatorBuilder: (_, __) => const SizedBox(width: Edges.small),
							itemBuilder: (_, index) {
								final mangaData = manga[index];
								return Align(
									alignment: Alignment.bottomLeft,
									child: MangaCard(
										key: ValueKey(mangaData.manga.id),
										mangaData: mangaData,
										onPress: () => viewModel.addSearchHistory(mangaData.manga.id, HistoryType.manga),
									),
								);
							},
						)),
					],
				));
			},
		);
	}

	Widget buildAuthorList(TextTheme text, ColorScheme colors) {
		return StreamBuilder(
			stream: viewModel.authorStream,
			builder: (context, snapshot) {
				if (snapshot.hasError) {
					return SliverToBoxAdapter(child: SizedBox(
						height: 100,
						child: ErrorCard(margin: Edges.horizontalLarge, error: snapshot.error),
					));
				}

				final authors = snapshot.data;
				if (authors == null || authors.isEmpty) {
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
							child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
								Text("Authors", style: text.titleSmall),
								IconButton(
									onPressed: () => {},
									icon: const Icon(Symbols.navigate_next_rounded), 
									visualDensity: VisualDensity.compact,
								),
							])
						),
						SizedBox(height: 175, child: ListView.separated(
							itemCount: authors.length,
							scrollDirection: Axis.horizontal,
							padding: Edges.horizontalLarge,
							separatorBuilder: (_, __) => const SizedBox(width: Edges.small),
							itemBuilder: (_, index) {
								final author = authors[index];

								return AuthorCard(
									key: ValueKey(author.id),
									author: author,
									onPress: () => viewModel.addSearchHistory(author.id, HistoryType.author),
								);
							},
						)),
					],
				));
			},
		);
	}

	Widget buildGroupList(TextTheme text, ColorScheme colors) {
		return StreamBuilder(
			stream: viewModel.groupStream,
			builder: (context, snapshot) {
				if (snapshot.hasError) {
					return SliverToBoxAdapter(child: SizedBox(
						height: 100,
						child: ErrorCard(margin: Edges.horizontalLarge, error: snapshot.error),
					));
				}

				final authors = snapshot.data;
				if (authors == null || authors.isEmpty) {
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
							child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
								Text("Groups", style: text.titleSmall),
								IconButton(
									onPressed: () => {},
									icon: const Icon(Symbols.navigate_next_rounded), 
									visualDensity: VisualDensity.compact,
								),
							])
						),
						SizedBox(height: 175, child: ListView.separated(
							itemCount: authors.length,
							scrollDirection: Axis.horizontal,
							padding: Edges.horizontalLarge,
							separatorBuilder: (_, __) => const SizedBox(width: Edges.small),
							itemBuilder: (_, index) {
								final groupData = authors[index];

								return GroupCard(
									key: ValueKey(groupData.group.id),
									groupData: groupData,
									onPress: () => viewModel.addSearchHistory(groupData.group.id, HistoryType.author),
								);
							},
						)),
					],
				));
			},
		);
	}
}
