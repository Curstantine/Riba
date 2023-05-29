import "package:animations/animations.dart";
import "package:flutter/material.dart";
import "package:riba/routes/home/model.dart";
import "package:riba/routes/home/views/library.dart";
import "package:riba/utils/constants.dart";

import "explore.dart";
import "home.dart";

class HomeView extends StatefulWidget {
	const HomeView({super.key});

	@override
	State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
	HomeViewModel get viewModel => HomeViewModel.instance;

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			bottomNavigationBar: ValueListenableBuilder(
				valueListenable: viewModel.currentPage,
				builder: (context, value, _) => NavigationBar(
					selectedIndex: value.index,
					onDestinationSelected: (i) => viewModel.currentPage.value = HomeViewPage.values[i],
					destinations: const [
						NavigationDestination(
							label: "Home",
							icon: Icon(Icons.home_outlined),
							selectedIcon: Icon(Icons.home_rounded)),
						NavigationDestination(
							label: "Library",
							icon: Icon(Icons.library_books_outlined),
							selectedIcon: Icon(Icons.library_books_rounded)),
						NavigationDestination(
							label: "Explore",
							icon: Icon(Icons.explore_outlined),
							selectedIcon: Icon(Icons.explore_rounded)),
					],
				),
			),
			body: ValueListenableBuilder(
				valueListenable: viewModel.currentPage,
				builder: (context, value, _) => PageTransitionSwitcher(
					reverse: value.index < 1,
					duration: Durations.emphasized,
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

	Widget buildPageView(HomeViewPage page) {
		switch (page) {
			case HomeViewPage.home:
				return const HomeContent();
			case HomeViewPage.library:
				return const LibraryContent();
			case HomeViewPage.explore:
				return const ExploreContent();
		}
	}
}

enum HomeViewPage {
	home,
	library,
	explore,
}