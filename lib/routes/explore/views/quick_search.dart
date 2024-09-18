import "package:flutter/material.dart" hide SearchBar;
import "package:flutter_animate/flutter_animate.dart";
import "package:material_symbols_icons/symbols.dart";
import "package:riba/repositories/local/models/author.dart";
import "package:riba/repositories/local/models/history.dart";
import "package:riba/repositories/runtime/group.dart";
import "package:riba/routes/authors/widgets/cards.dart";
import "package:riba/routes/explore/model.dart";
import "package:riba/routes/explore/views/quick_search_model.dart";
import "package:riba/routes/groups/widgets/cards.dart";
import "package:riba/routes/manga/widgets/cards/preview.dart";
import "package:riba/utils/constants.dart";
import "package:riba/utils/debouncer.dart";
import "package:riba/widgets/error_card.dart";
import "package:rxdart/rxdart.dart";

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

				return SliverList.list(children: AnimateList(
					effects: [
						const FadeEffect(
							duration: LocalDurations.emphasized,
							curve: LocalEasing.emphasized)
					],
					children: [
						Padding(
							padding: Edges.horizontalLarge,
							child: Text("Recent searches", style: text.titleSmall)),
						for (final history in histories)
							ListTile(
								leading: const Icon(Symbols.history_rounded),
								title: Text(history.value),
								onTap: () => rootViewModel.searchController.text = history.value),
						const Padding(padding: Edges.topMedium),
					],
				));
			},
		);
	}

	Widget buildMangaList(TextTheme text, ColorScheme colors) {
		return _QuickSearchHorizontalScrollableCategory(
			title: "Manga",
			stream: viewModel.mangaStream,
			onExpansionPressed: () => viewModel.onMangaListExpansion(context),
			listHeight: 275,
			builder: (mangaData) => MangaPreviewCard(
				key: ValueKey(mangaData.manga.id),
				mangaData: mangaData,
				onPress: () => viewModel.addSearchHistory(mangaData.manga.id, HistoryType.manga),
			),
		);
	}

	Widget buildAuthorList(TextTheme text, ColorScheme colors) {
		return _QuickSearchHorizontalScrollableCategory<Author>(
			title: "Authors",
			stream: viewModel.authorStream,
			onExpansionPressed: () => {},
			listHeight: 175,
			builder: (author) => AuthorCard(
				key: ValueKey(author.id),
				elevation: 20,
				author: author,
				onPress: () => viewModel.addSearchHistory(author.id, HistoryType.author),
			),
		);
	}

	Widget buildGroupList(TextTheme text, ColorScheme colors) {
		return _QuickSearchHorizontalScrollableCategory<GroupData>(
			title: "Groups",
			stream: viewModel.groupStream,
			onExpansionPressed: () => {},
			listHeight: 175,
			builder: (groupData) => GroupCard(
				key: ValueKey(groupData.group.id),
				elevation: 20,
				groupData: groupData,
				onPress: () => viewModel.addSearchHistory(groupData.group.id, HistoryType.author),
			),
		);
	}
}

class _QuickSearchHorizontalScrollableCategory<T> extends StatelessWidget {
	final String title;
	final ValueStream<List<T>> stream;
	final VoidCallback onExpansionPressed;

	final double listHeight;
	final Widget Function(T) builder;

	const _QuickSearchHorizontalScrollableCategory({
		super.key,
		required this.title,
		required this.stream,
		required this.onExpansionPressed,
		required this.listHeight,
		required this.builder,
	});

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		final text = theme.textTheme;

		return StreamBuilder<List<T>>(
			stream: stream,
			builder: (context, snapshot) {
				if (snapshot.hasError) {
					return SliverToBoxAdapter(child: SizedBox(
						height: 100,
						child: ErrorCard(margin: Edges.horizontalLarge, error: snapshot.error),
					));
				}

				final data = snapshot.data;
				if (data == null || data.isEmpty) {
					return const SliverToBoxAdapter();
				}

				return SliverList.list(children: AnimateList(
					effects: [
						const FadeEffect(
							duration: LocalDurations.emphasized,
							curve: LocalEasing.emphasized)
					],
					children: [
						Padding(
							padding: Edges.horizontalLarge,
							child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
								Text(title, style: text.titleSmall),
								IconButton(
									onPressed: onExpansionPressed,
									icon: const Icon(Symbols.navigate_next_rounded), 
									visualDensity: VisualDensity.compact,
								),
							])
						),
						SizedBox(height: listHeight, child: ListView.separated(
							itemCount: data.length,
							scrollDirection: Axis.horizontal,
							padding: Edges.horizontalLarge,
							separatorBuilder: (_, __) => const SizedBox(width: Edges.small),
							itemBuilder: (_, index) => builder(data[index]),
						)),
					],
				));
			},
		);
	} 
}