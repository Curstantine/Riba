import "package:flutter/material.dart";
import "package:riba/routes/home/widgets/action_bar.dart";

class HomeContent extends StatefulWidget { 
	const HomeContent({super.key});

	@override
	State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
	@override
	Widget build(BuildContext context) {
		return ListView(
			primary: true,
			children: const [
				ActionBar(),
				Text("Home"),
			],
		);
	}
}
