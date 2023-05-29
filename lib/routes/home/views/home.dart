import "package:flutter/material.dart";

class HomeContent extends StatefulWidget { 
	const HomeContent({super.key});

	@override
	State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
	@override
	Widget build(BuildContext context) {
		return SafeArea(
			child: ListView(
				primary: true,
				children: const [Text("Home")],
			),
		);
	}
}
