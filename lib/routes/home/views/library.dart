import "package:flutter/material.dart";

class LibraryContent extends StatelessWidget {
	const LibraryContent({super.key});

	@override
	Widget build(BuildContext context) {
		return SafeArea(
			child: ListView(
				primary: true,
				children: const [
					Text("Library"),
				],
			),
		);
	}
}
