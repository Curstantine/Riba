import "package:flutter/material.dart" hide Router, SearchBar;
import "package:flutter_animate/flutter_animate.dart";
import "package:isar/isar.dart";
import "package:riba/repositories/local/models/history.dart";
import "package:riba/repositories/mangadex/models/user.dart";
import "package:riba/utils/constants.dart";
import "package:riba/utils/database.dart";
import "package:riba/utils/router.dart";
import "package:riba/utils/theme.dart";
import "package:riba/widgets/material/search.dart";
import "package:riba/widgets/material/skeleton_loaders.dart";

class ActionBar extends StatelessWidget implements PreferredSizeWidget {
	const ActionBar({super.key, required this.currentPage});

	final ValueNotifier<int> currentPage;

	@override
	Size get preferredSize => const Size.fromHeight(64);
	
	@override
	Widget build(BuildContext context) {
		final media = MediaQuery.of(context);

		return Container(
			height: 64,
			padding: Edges.horizontalSmall,
			margin: EdgeInsets.only(top: media.padding.top),
			child: ValueListenableBuilder(
				valueListenable: currentPage,
				builder: (context, value, child) => AnimatedSwitcher(
					duration: Durations.emphasized,
					switchInCurve: Easing.emphasized,
					switchOutCurve: Easing.emphasized,
					child: value == 2 ? const _SearchImplBar() : const _UserBar(),
				),
			),
		);
	}
}

class _SearchImplBar extends StatefulWidget {
	const _SearchImplBar();

	@override
	State<_SearchImplBar> createState() => _SearchImplBarState();
}

class _SearchImplBarState extends State<_SearchImplBar> {
	final focusNode = FocusNode();
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
			padding: Edges.horizontalSmall,
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
						_PopupActionsButton()
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

class _UserBar extends StatelessWidget {
	const _UserBar();

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		final text = theme.textTheme;

		return Row(children: [
			IconButton(onPressed: () => {}, icon: const Icon(Icons.person)),
			Column(
				mainAxisAlignment: MainAxisAlignment.center,
				crossAxisAlignment: CrossAxisAlignment.start,
				children: [
					Text("Guest", style: text.titleMedium?.copyWith(height: 0)),
					Text(UserRole.member.asHumanReadable(),
						style: text.bodySmall?.withColorOpacity(0.5).copyWith(letterSpacing: 0, height: 0))
				],
			),
			const Spacer(),
			const _PopupActionsButton(),
		]);
	}
}

class _PopupActionsButton extends StatelessWidget {
	const _PopupActionsButton();

	@override
	Widget build(context) {
		return PopupMenuButton<String>(
			icon: const Icon(Icons.more_vert_rounded),
			onSelected: (value) => Navigator.pushNamed(context, value),
			offset: const Offset(-10, 56),
			itemBuilder: (context) => [
				const PopupMenuItem(value: Router.settings, child: Text("Settings")),
			],
		);
	}
}
