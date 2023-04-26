import "package:animations/animations.dart";
import "package:flutter/material.dart";
import "package:logging/logging.dart";
import "package:riba/routes/home/views/library.dart";
import "package:riba/routes/home/widgets/user_bar.dart";
import "package:riba/utils/constants.dart";

import "home.dart";
import "search.dart";

class HomeView extends StatefulWidget {
	const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
	final logger = Logger("HomeView");
	
	final ValueNotifier<int> currentPage = ValueNotifier(0);
	
	// Hoists the scroll offset of the home page.
	// Changing this value won't actively change the scroll offset of the home page,
	// but will be used in the widget initialization step.
	final ValueNotifier<double> homeScrollOffset = ValueNotifier(0);

	@override
	Widget build(BuildContext context) {
		final media = MediaQuery.of(context);

		return Scaffold(
			appBar: PreferredSize(
				preferredSize: Size.fromHeight(media.padding.top + 64),
				child: const SafeArea(child: HomeUserBar())),
			bottomNavigationBar: ValueListenableBuilder(
				valueListenable: currentPage,
				builder: (context, value, _) => NavigationBar(
					selectedIndex: value,
					onDestinationSelected: (i) => currentPage.value = i,
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
				valueListenable: currentPage,
				builder: (context, value, _) => PageTransitionSwitcher(
					reverse: value < 1,
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

	Widget buildPageView(int index) {
		switch (index) {
			case 0:
				return HomeContent(scrollOffset: homeScrollOffset);
			case 1:
				return const LibraryContent();
			case 2:
				return const SearchContent();
			default:
				throw Exception("Invalid page index");
		}
	}
}