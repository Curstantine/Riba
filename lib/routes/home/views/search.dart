import "package:flutter/material.dart";

class SearchContent extends StatelessWidget {
	const SearchContent({super.key});

	@override
	Widget build(BuildContext context) {
		return SafeArea(
			child: ListView(
				primary: true,
				children: const [
					Text("Search"),
				],
			),
		);
	}
}
