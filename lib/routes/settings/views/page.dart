import "package:flutter/material.dart";
import "package:riba/widgets/material/lists.dart";

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.medium(title: const Text("Settings", overflow: TextOverflow.visible)),
          SliverList(
            delegate: SliverChildListDelegate([
              ListItem(title: "Appearance", leading: const Icon(Icons.palette), onTap: () => {}),
            ]),
          ),
        ],
      ),
    );
  }
}
