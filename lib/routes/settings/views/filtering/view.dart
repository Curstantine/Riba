import "package:flutter/material.dart";

import "content_rating.dart";
import "language.dart";

class SettingsFilteringView extends StatelessWidget {
	const SettingsFilteringView({super.key});
	
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(title: const Text("Filtering")),
			body: ListView(children: const [
				SettingsFilteringContentRatingSegment(),
				SettingsFilteringLanguageSegment(),
			]),
		);
	}
}