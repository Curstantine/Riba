import "package:flutter/material.dart" hide Router;
import "package:riba/utils/router.dart";

class PopupActionButton extends StatelessWidget {
	const PopupActionButton({super.key});

	@override
	Widget build(context) {
		return PopupMenuButton<String>(
			icon: const Icon(Icons.more_vert_rounded),
			onSelected: (value) => Navigator.pushNamed(context, value),
			offset: const Offset(-10, 56),
			itemBuilder: (context) => [
				const PopupMenuItem(value: Router.settings, child: Text("Settings")),
			],
		);
	}
}
