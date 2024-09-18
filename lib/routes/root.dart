import "package:animations/animations.dart";
import "package:flutter/material.dart";
import "package:material_symbols_icons/symbols.dart";
import "package:riba/routes/library/library.dart";
import "package:riba/utils/constants.dart";

import "explore/view.dart";
import "home/view.dart";

class RootView extends StatefulWidget {
	const RootView({super.key});

	@override
	State<RootView> createState() => _RootViewState();
}

class _RootViewState extends State<RootView> {
	final ValueNotifier<RootDestinations> currentPage = ValueNotifier(RootDestinations.home);

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			bottomNavigationBar: ValueListenableBuilder(
				valueListenable: currentPage,
				builder: (context, value, _) => NavigationBar(
					selectedIndex: value.index,
					onDestinationSelected: (i) => currentPage.value = RootDestinations.values[i],
					destinations: const [
						NavigationDestination(
							label: "Home",
							icon: Icon(Symbols.home_rounded),
							selectedIcon: Icon(Symbols.home_rounded, fill: 1)),
						NavigationDestination(
							label: "Library",
							icon: Icon(Symbols.library_books_rounded),
							selectedIcon: Icon(Symbols.library_books_rounded, fill: 1)),
						NavigationDestination(
							label: "Explore",
							icon: Icon(Symbols.explore_rounded),
							selectedIcon: Icon(Symbols.explore_rounded, fill: 1)),
					],
				),
			),
			body: ValueListenableBuilder(
				valueListenable: currentPage,
				builder: (context, value, _) => PageTransitionSwitcher(
					reverse: value.index < 1,
					duration: LocalDurations.emphasized,
					transitionBuilder: (child, x, y) => SharedAxisTransition(
						animation: x,
						secondaryAnimation: y,
						transitionType: SharedAxisTransitionType.horizontal,
						child: child,
					),
					child: buildPageView(value),
				),
			),
		);
	}

	Widget buildPageView(RootDestinations page) {
		switch (page) {
			case RootDestinations.home:
				return const HomeContent();
			case RootDestinations.library:
				return const LibraryContent();
			case RootDestinations.explore:
				return const ExploreView();
		}
	}
}

enum RootDestinations {
	home,
	library,
	explore,
}