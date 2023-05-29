import "package:flutter/material.dart" hide SearchBar;
import "package:flutter_animate/flutter_animate.dart";
import "package:isar/isar.dart";
import "package:riba/repositories/local/models/history.dart";
import "package:riba/utils/constants.dart";
import "package:riba/utils/database.dart";
import "package:riba/widgets/material/search.dart";
import "package:riba/widgets/material/skeleton_loaders.dart";

import "popup_action_button.dart";

class SearchBarImpl extends StatefulWidget {
	const SearchBarImpl({super.key});

	@override
	State<SearchBarImpl> createState() => _SearchBarImplState();
}

class _SearchBarImplState extends State<SearchBarImpl> {
	final searchController = SearchController();

	Future<List<History>>? queryHistory;

	@override
	void initState() {
		super.initState();

		queryHistory = Database.instance.local.history.where()
			.typeEqualTo(HistoryType.query)
			.sortByCreatedAt()
			.limit(5)
			.findAll();
	}

	@override
	Widget build(BuildContext context) {
		return Padding(
			padding: Edges.horizontalMedium,
			child: SearchAnchor(
				searchController: searchController,
				suggestionsBuilder: (_, __) => [],
				viewBuilder: (_) => _SearchBarSuggestionsView(
					controller: searchController,
					queryHistory: queryHistory,
				),
				viewLeading: IconButton(
					icon: const Icon(Icons.arrow_back_rounded),
					onPressed: () => searchController.closeView(null)
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
		required this.queryHistory,
	});

	final SearchController controller;
	final Future<List<History>>? queryHistory;

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		final text = theme.textTheme;

		return CustomScrollView(
			slivers: [
				const SliverPadding(padding: Edges.topSmall),
				buildRecentList(text),
			],
		);
	}

	Widget buildRecentList(TextTheme text) {
		return FutureBuilder<List<History>>(
			future: queryHistory,
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
}