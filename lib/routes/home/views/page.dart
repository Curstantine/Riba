import "package:flutter/material.dart";
import "package:riba/material_symbols.dart";
import "package:animations/animations.dart";
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
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(media.padding.top + 64),
        child: const SafeArea(child: UserBar()),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentPageIndex,
        onDestinationSelected: onDestinationSelected,
        destinations: const [
          NavigationDestination(
              label: "Home",
              icon: Icon(MaterialSymbols.home_outlined),
              selectedIcon: Icon(MaterialSymbols.home_filled)),
          NavigationDestination(
              label: "Library",
              icon: Icon(MaterialSymbols.library_outlined),
              selectedIcon: Icon(MaterialSymbols.library_filled)),
          NavigationDestination(
              label: "Search",
              icon: Icon(MaterialSymbols.search_outlined),
              selectedIcon: Icon(MaterialSymbols.search_filled)),
        ],
      ),
      body: PageTransitionSwitcher(
        duration: const Duration(milliseconds: 300),
        reverse: currentPageIndex < 1,
        transitionBuilder: (child, animation, secondaryAnimation) {
          return SharedAxisTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            transitionType: SharedAxisTransitionType.horizontal,
            child: child,
          );
        },
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
