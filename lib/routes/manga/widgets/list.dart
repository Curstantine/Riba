import "package:flutter/material.dart";
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
			SizedBox(
				height: 275,
				child: ListView.separated(
					cacheExtent: 25,
					shrinkWrap: true,
					itemCount: mangaIds.length,
					padding: Edges.horizontalMedium,
					scrollDirection: Axis.horizontal,
					separatorBuilder: (_, __) => const SizedBox(width: Edges.small),
					itemBuilder: (_, i) => MangaCard(key: Key(mangaIds[i]), id: mangaIds[i]),
				),
			)
		]);
	}
}
