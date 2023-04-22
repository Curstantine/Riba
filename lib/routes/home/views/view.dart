import "package:animations/animations.dart";
import "package:flutter/material.dart";
import "package:riba/routes/home/views/library.dart";
import "package:riba/routes/home/widgets/user_bar.dart";
import "package:riba/utils/constants.dart";

import "home.dart";
import "search.dart";

class HomeView extends StatelessWidget {
	HomeView({super.key});
	
	final ValueNotifier<int> _currentPageIndex = ValueNotifier(0);

	@override
	Widget build(BuildContext context) {
		final media = MediaQuery.of(context);

		return Scaffold(
			appBar: PreferredSize(
				preferredSize: Size.fromHeight(media.padding.top + 64),
				child: const SafeArea(child: HomeUserBar())),
			bottomNavigationBar: ValueListenableBuilder(
				valueListenable: _currentPageIndex,
				builder: (context, value, _) => NavigationBar(
					selectedIndex: value,
					onDestinationSelected: (i) => _currentPageIndex.value = i,
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
							label: "Search",
							icon: Icon(Icons.search_outlined),
							selectedIcon: Icon(Icons.search_rounded)),
					],
				),
			),
			body: ValueListenableBuilder(
				valueListenable: _currentPageIndex,
				builder: (context, value, _) => PageTransitionSwitcher(
					reverse: value < 1,
					duration: Durations.slow,
					transitionBuilder: (child, animation, secondaryAnimation) => SharedAxisTransition(
						animation: animation,
						secondaryAnimation: secondaryAnimation,
						transitionType: SharedAxisTransitionType.horizontal,
						child: child,
					),
					child: buildPageView(value),
				),
			),
		);
	}

	Widget buildPageView(int index) {
		switch (index) {
			case 0:
				return const HomeContent();
			case 1:
				return const LibraryContent();
			case 2:
				return const SearchContent();
			default:
				throw Exception("Invalid page index");
		}
	}
}