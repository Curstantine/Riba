
import "package:flutter/material.dart";
import "package:riba/repositories/mangadex/mangadex.dart";
import "package:riba/repositories/mangadex/services/manga.dart";
import "package:riba/routes/manga/widgets/cards.dart";
import "package:riba/utils/constants.dart";

class MangaHorizontalList extends StatelessWidget {
	const MangaHorizontalList({super.key, required this.title, required this.mangaIds});

	final String title;
	final List<String> mangaIds;

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);

		return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
			Padding(
				padding: Edges.leftMedium,
				child: Text(title, style: theme.textTheme.titleMedium)),
			buildList()
		]);
	}

	SizedBox buildList() {
		return SizedBox(
			height: 275,
			child: FutureBuilder(
				future: MangaDex.instance.manga.getMany(
					overrides: MangaDexMangaQueryFilter(ids: mangaIds),
				),
				builder: (context, snapshot) {
					if (snapshot.connectionState != ConnectionState.done) {
						return const Center(child: CircularProgressIndicator());
					}

					if (snapshot.hasError || !snapshot.hasData) {
						return const Center(child: Text("Error"));
					}

					// Since global filters are applied to these requests,
					// there are chances that data might not contain all the 
					// mangaIds requested. As such, it is a good idea to completely
					// ignore the ids given to this widget after the fetch.
					final data = snapshot.requireData;
					final ids = data.keys.toList();

					return ListView.separated(
						shrinkWrap: true,
						itemCount: ids.length,
						padding: Edges.horizontalMedium,
						scrollDirection: Axis.horizontal,
						findChildIndexCallback: (key) => ids.indexOf(key.toString()),
						separatorBuilder: (_, __) => const SizedBox(width: Edges.small),
						itemBuilder: (_, i) => MangaCard(mangaData: data[ids[i]]!),
					);
				}
			),
		);
	}
}
