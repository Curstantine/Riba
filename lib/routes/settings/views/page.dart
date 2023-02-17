import "package:animations/animations.dart";
import "package:flutter/material.dart";
import "package:riba/routes/settings/views/caching.dart";
import "package:riba/utils/animations.dart";
import "package:riba/widgets/material/lists.dart";

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(title: const Text("Settings")),
          SliverList(
            delegate: SliverChildListDelegate([
              ListItem(
                  title: "Account", leading: const Icon(Icons.account_circle), onTap: () => {}),
              ListItem(
                  title: "Appearance", leading: const Icon(Icons.palette_rounded), onTap: () => {}),
              ListItem(
                  title: "Caching",
                  leading: const Icon(Icons.cached_rounded),
                  onTap: () => navigateTo(context, const SettingsCachingView())),
            ]),
          ),
        ],
      ),
    );
  }

  navigateTo(BuildContext context, Widget page) {
    Navigator.of(context).push(
      sharedAxis(() => page, SharedAxisTransitionType.horizontal),
    );
  }
}
