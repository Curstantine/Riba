import "package:flutter/material.dart";

import "content_rating.dart";
import "language.dart";

class SettingsContentFilteringView extends StatelessWidget {
	const SettingsContentFilteringView({super.key});
	
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(title: const Text("Content Filtering")),
			body: ListView(children: const [
				SettingsContentFilteringContentRatingSegment(),
				SettingsContentFilteringLanguageSegment(),
			]),
		);
	}
}