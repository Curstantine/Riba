import "package:flutter/material.dart";
import "package:riba/repositories/runtime/collection.dart";
import "package:riba/repositories/runtime/manga.dart";
import "package:riba/routes/manga/widgets/cards.dart";
import "package:riba/utils/constants.dart";
import "package:riba/widgets/error_card.dart";

class MangaResultList extends StatelessWidget {
	const MangaResultList({super.key, required this.title, required this.future});

	final String title;
	final Future<CollectionData<MangaData>> future;

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(title: Text(title)),
			body: CustomScrollView(slivers: [
				buildList(),
			])
		);
	}

	Widget buildList() {
		return FutureBuilder(
			future: future,
			builder: (context, snapshot) {
				if (snapshot.connectionState == ConnectionState.waiting) {
					return const SliverFillRemaining(
						child: Center(child: CircularProgressIndicator())
					);
				}

				if (snapshot.hasError || !snapshot.hasData) {
					return SliverFillRemaining(
						child: Center(child: SizedBox(
							height: 150,
							width: double.infinity,
							child: ErrorCard(error: snapshot.error, margin: Edges.horizontalMedium),
						))
					);
				}

				final data = snapshot.requireData;

				return SliverList.builder(
					itemCount: data.data.length,
					itemBuilder: (context, i) {
						final mangaData = data.data[i];

						return MangaListCard(
							key: ValueKey(mangaData.manga.id),
							mangaData: mangaData,
						);
					},
				);
			},
		);
	}
}