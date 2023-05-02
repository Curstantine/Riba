import "package:flutter/material.dart";

import "language.dart";

class SettingsContentFilteringView extends StatelessWidget {
	const SettingsContentFilteringView({super.key});
	
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(title: const Text("Content Filtering")),
			body: ListView(children: const [
				SettingsContentFilteringLanguageSegment(),
			]),
		);
	}
}