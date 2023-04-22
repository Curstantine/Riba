import "package:flutter/material.dart";
import "package:riba/repositories/mangadex/mangadex.dart";
import "package:riba/repositories/runtime/custom_list.dart";
import "package:riba/routes/manga/widgets/list.dart";

class HomeContent extends StatelessWidget { 
	const HomeContent({super.key});

	@override
	Widget build(BuildContext context) {
		return SafeArea(
			child: ListView(
				primary: true,
				children: [buildSeasonal(context)],
			),
		);
	}

  Widget buildSeasonal(BuildContext context) {
    return FutureBuilder<CustomListData>(
		future: MangaDex.instance.customList.getSeasonal(),
		builder: (context, snapshot) {
			if (snapshot.connectionState != ConnectionState.done) {
				return const Center(child: CircularProgressIndicator());
			}

			if (snapshot.hasError || !snapshot.hasData) {
				return const Center(child: Text("Error"));
			}

			return MangaHorizontalList(title: "Seasonal", mangaIds: snapshot.data!.list.mangaIds);
		},
    );
  }
}
