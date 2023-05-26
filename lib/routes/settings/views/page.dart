import "package:animations/animations.dart";
import "package:flutter/foundation.dart" show kDebugMode;
import "package:flutter/material.dart";
import "package:riba/utils/animations.dart";

import "appearance/view.dart";
import "debug/view.dart";
import "filtering/view.dart";
import "persistence/view.dart";

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
							ListTile(
								title: const Text("Appearance"), 
								leading: const Icon(Icons.palette_rounded),
								onTap: () => navigateTo(context, const SettingsAppearanceView())),
							ListTile(
								title: const Text("Filtering"),
								leading: const Icon(Icons.filter_alt_rounded),
								onTap: () => navigateTo(context, const SettingsFilteringView())),
							ListTile(
								title: const Text("Persistence"),
								leading: const Icon(Icons.save_alt_rounded),
								onTap: () => navigateTo(context, const SettingsPersistenceView())),
							if (kDebugMode)
								ListTile(
									title: const Text("Debug"),
									leading: const Icon(Icons.bug_report_rounded),
									onTap: () => navigateTo(context, const SettingsDebugView())),
						]),
					),
				],
			),
		);
	}

	void navigateTo(BuildContext context, Widget page) {
		Navigator.of(context).push(
			sharedAxis((_) => page, SharedAxisTransitionType.horizontal),
		);
	}
}
