import "package:flutter/material.dart" hide Router;
import "package:material_symbols_icons/symbols.dart";
import "package:riba/utils/router.dart";

class RootActionPopupButton extends StatelessWidget {
	const RootActionPopupButton({super.key});

	@override
	Widget build(context) {
		return PopupMenuButton<String>(
			icon: const Icon(Symbols.more_vert_rounded),
			onSelected: (value) => Navigator.pushNamed(context, value),
			offset: const Offset(-12, 58),
			itemBuilder: (context) => [
				const PopupMenuItem(value: Router.settings, child: Text("Settings")),
			],
		);
	}
}
