
import "package:flutter/material.dart";
import "package:riba/repositories/mangadex/mangadex.dart";
import "package:riba/repositories/mangadex/models/manga.dart";
import "package:riba/repositories/mangadex/services/manga.dart";
import "package:riba/repositories/runtime/manga.dart";
import "package:riba/routes/manga/widgets/cards.dart";
import "package:riba/utils/constants.dart";
import "package:riba/utils/errors.dart";

class MangaHorizontalList extends StatefulWidget {
	const MangaHorizontalList({
		super.key,
		required this.title,
		required this.mangaIds,
		required this.scrollOffset,
	});

	final String title;
	final List<String> mangaIds;
	final ValueNotifier<double> scrollOffset;

  @override
  State<MangaHorizontalList> createState() => _MangaHorizontalListState();
}

class _MangaHorizontalListState extends State<MangaHorizontalList> {
	late final scrollController = ScrollController(initialScrollOffset: widget.scrollOffset.value);
	
	late final dataFuture = MangaDex.instance.manga.getMany(
		overrides: MangaDexMangaQueryFilter(
			ids: widget.mangaIds,
			contentRatings: [
				ContentRating.safe,
				ContentRating.suggestive,
				ContentRating.erotica,
				ContentRating.pornographic
			]
		),
	);

	@override
	void initState() {
		super.initState();
		scrollController.addListener(() => widget.scrollOffset.value = scrollController.offset);
	}

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		final text = theme.textTheme;

		return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
			Padding(
				padding: Edges.leftMedium,
				child: Text(widget.title, style: text.titleMedium)),
			SizedBox(
				height: 275,
				child: buildList(text)),
		]);
	}

	Widget buildList(TextTheme text) {		
		return FutureBuilder<Map<String, MangaData>>(
			future: dataFuture,
			builder: (context, snapshot) {
				if (snapshot.connectionState != ConnectionState.done) {
					return const Center(child: CircularProgressIndicator());
				}

				if (snapshot.hasError || !snapshot.hasData) {
					final error = handleError(snapshot.error ?? "Data was null without errors.");

					return Center(child: Column(children: [
						Text(error.title, style: text.titleLarge),
						Text(error.description, style: text.bodyMedium),
					]));
				}


				// Since global filters are applied to these requests,
				// there are chances that data might not contain all the 
				// mangaIds requested. As such, it is a good idea to completely
				// ignore the ids given to this widget after the fetch.
				final data = snapshot.requireData;
				final ids = data.keys.toList();

				return ListView.separated(
					controller: scrollController,
					itemCount: ids.length,
					padding: Edges.horizontalMedium,
					scrollDirection: Axis.horizontal,
					separatorBuilder: (_, __) => const SizedBox(width: Edges.small),
					itemBuilder: (_, i) {
						final id = ids[i];

						return MangaCard(key: ValueKey(id), mangaData: data[id]!);
					},
				);
			}
		);
	}
}
