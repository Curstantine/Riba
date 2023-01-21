import 'package:flutter/material.dart';
import 'package:riba/material_symbols.dart';
import 'package:riba/routes/home/home_content.dart';
import 'package:riba/utils/constants.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentPageIndex = 0;
  final pageController = PageController();

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentPageIndex,
        onDestinationSelected: (value) {
          setState(() => currentPageIndex = value);
          pageController.animateToPage(value, duration: Durations.normal, curve: Curves.ease);
        },
        destinations: [
          NavigationDestination(
              label: "Home",
              icon: currentPageIndex == 0
                  ? const Icon(MaterialSymbols.home_filled)
                  : const Icon(MaterialSymbols.home_outlined)),
          NavigationDestination(
              label: "Library",
              icon: currentPageIndex == 1
                  ? const Icon(MaterialSymbols.library_filled)
                  : const Icon(MaterialSymbols.library_outlined)),
          NavigationDestination(
              label: "Search",
              icon: currentPageIndex == 2
                  ? const Icon(MaterialSymbols.search_filled)
                  : const Icon(MaterialSymbols.search_outlined)),
        ],
      ),
      body: PageView(
        controller: pageController,
        onPageChanged: onPageChanged,
        children: const [
          HomeContent(),
          Text("Library"),
          Text("Add"),
        ],
      ),
    );
  }

  void onPageChanged(int value) {
    if (value != currentPageIndex) {
      setState(() => currentPageIndex = value);
    }
  }
}
