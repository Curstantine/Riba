import "package:flutter/material.dart";
import "package:riba/utils/lazy.dart";

class SettingsDebugView extends StatelessWidget {
	const SettingsDebugView({super.key});

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: const Text("Debug"),
			),
			body: ListView(children: [
				ListTile(
					title: const Text("Spawn lazy bar"),
					onTap: () => showLazyBar(context, "Lorem Ipsum Dolor Sit Amet."),
				)
			]),
		);
	}
}