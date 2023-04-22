import "package:flutter/material.dart";

import "cover.dart";

class SettingsPersistenceView extends StatelessWidget {
	const SettingsPersistenceView({super.key});

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(title: const Text("Persistence")),
			body: ListView(children: const [
				SettingsPersistenceSegment(),
			]),
		);
	}
}

