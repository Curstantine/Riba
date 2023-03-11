import "package:animations/animations.dart";
import "package:flutter/material.dart";
import "package:riba/routes/home/views/library_content.dart";
import "package:riba/routes/home/widgets/user_bar.dart";

import "home_content.dart";
import "search_content.dart";

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int currentPageIndex = 0;
  bool showAppBar = true;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(media.padding.top + 64),
        child: const SafeArea(child: HomeUserBar()),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentPageIndex,
        onDestinationSelected: onDestinationSelected,
        destinations: const [
          NavigationDestination(
            label: "Home",
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
          ),
          NavigationDestination(
            label: "Library",
            icon: Icon(Icons.library_books_outlined),
            selectedIcon: Icon(Icons.library_books_rounded),
          ),
          NavigationDestination(
            label: "Search",
            icon: Icon(Icons.search_outlined),
            selectedIcon: Icon(Icons.search_rounded),
          ),
        ],
      ),
      body: PageTransitionSwitcher(
        duration: const Duration(milliseconds: 300),
        reverse: currentPageIndex < 1,
        transitionBuilder: (child, animation, secondaryAnimation) => SharedAxisTransition(
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          transitionType: SharedAxisTransitionType.horizontal,
          child: child,
        ),
        child: buildPageView(),
      ),
    );
  }

  Widget buildPageView() {
    late Widget page;

    switch (currentPageIndex) {
      case 0:
        page = const HomeContent();
        break;
      case 1:
        page = const LibraryContent();
        break;
      case 2:
        page = const SearchContent();
        break;
      default:
        throw Exception("Invalid page index");
    }

    return page;
  }

  void onDestinationSelected(int value) {
    setState(() => currentPageIndex = value);
  }
}
