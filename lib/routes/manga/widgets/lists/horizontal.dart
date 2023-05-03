
import "package:flutter/material.dart";
import "package:isar/isar.dart";
import "package:riba/repositories/mangadex/mangadex.dart";
import "package:riba/repositories/mangadex/services/manga.dart";
import "package:riba/repositories/runtime/manga.dart";
import "package:riba/routes/manga/widgets/cards.dart";
import "package:riba/settings/content_filters.dart";
import "package:riba/utils/constants.dart";
import "package:riba/utils/errors.dart";
import "package:riba/widgets/material/card.dart";

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
	
	late final Stream<Map<String, MangaData>> dataFuture = ContentFilterSettings.ref
		.where()
		.keyEqualTo(ContentFilterSettings.isarKey)
		.watch(fireImmediately: true)
		.asyncMap((e) {
			final contentFilter = e.first;

			return MangaDex.instance.manga.getMany(
				overrides: MangaDexMangaQueryFilter(
					ids: widget.mangaIds,
					contentRatings: contentFilter.contentRatings,
					// excludedOriginalLanguages: contentFilter.excludedOriginalLanguages,
				),
			);
		});

	@override
	void initState() {
		super.initState();
		scrollController.addListener(() => widget.scrollOffset.value = scrollController.offset);
	}

	@override
	void dispose() {
		scrollController.dispose();
		super.dispose();
	}

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		final text = theme.textTheme;
		final colors = theme.colorScheme;

		return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
			Padding(
				padding: Edges.leftMedium,
				child: Text(widget.title, style: text.titleMedium)),
			SizedBox(height: 275, child: buildList(text, colors)),
		]);
	}

	Widget buildList(TextTheme text, ColorScheme colors) {		
		return StreamBuilder<Map<String, MangaData>>(
			stream: dataFuture,
			builder: (context, snapshot) {
				if (snapshot.connectionState != ConnectionState.active) {
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
				final missingCount = widget.mangaIds.length - ids.length;
				final itemCount = missingCount != 0 ? ids.length + 1 : ids.length;

				return ListView.separated(
					controller: scrollController,
					itemCount: itemCount,
					padding: Edges.horizontalMedium,
					scrollDirection: Axis.horizontal,
					separatorBuilder: (_, __) => const SizedBox(width: Edges.small),
					itemBuilder: (_, i) {
						if (i >= ids.length) {
							return buildOutOfIndex(text, colors, missingCount);
						}

						final id = ids[i];
						return MangaCard(key: ValueKey(id), mangaData: data[id]!);
					},
				);
			}
		);
	}

	Widget buildOutOfIndex(TextTheme text, ColorScheme colors, int count) {
		final message = "$count ${count > 1 ? "titles are" : "title is"} hidden";
		const description = "Configure your content filters to see them";

		return SizedBox(
			height: 275,
			width: 175,
			child: OutlinedCard(child: Padding(
				padding: Edges.horizontalMedium,
				child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
					Text(
						message,
						textAlign: TextAlign.center,
						style: text.titleMedium?.copyWith(color: colors.tertiary)),
					Text(
						description,
						style: text.bodySmall?.copyWith(color: colors.onSurfaceVariant),
						textAlign: TextAlign.center)
				]),
			)),
		);
	}
}
