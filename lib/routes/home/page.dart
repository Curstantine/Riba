import 'package:flutter/material.dart';
import 'package:riba/material_symbols.dart';
import 'package:riba/routes/home/home_content.dart';
import 'package:riba/utils/constants.dart';
import 'package:riba/widgets/user_bar.dart';

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
    setState(() => currentPageIndex = value);
  }

  void onDestinationSelected(int value) {
    pageController.animateToPage(value, duration: Durations.normal, curve: Curves.easeIn);
  }
}
