import "package:flutter/material.dart" hide Locale;
import "package:riba/repositories/runtime/manga.dart";
import "package:riba/routes/manga/widgets/cards/preview.dart";
import "package:riba/utils/constants.dart";

class MangaHorizontalList extends StatefulWidget {
	const MangaHorizontalList({
		super.key,
		required this.title,
		required this.mangaData,
		required this.scrollOffset,
		this.reactToCoverSizeChanges = false,
		this.onCardPress,
	});

	final String title;
	final Map<String, MangaData> mangaData;
	final ValueNotifier<double> scrollOffset;
	final bool reactToCoverSizeChanges;
	final void Function(MangaData)? onCardPress;

	@override
	State<MangaHorizontalList> createState() => _MangaHorizontalListState();
}

class _MangaHorizontalListState extends State<MangaHorizontalList> {
	late final scrollController = ScrollController(initialScrollOffset: widget.scrollOffset.value);

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
		final data = widget.mangaData;
		final ids = data.keys.toList();
		final missingCount = widget.mangaData.length - ids.length;
		final itemCount = missingCount != 0 ? ids.length + 1 : ids.length;

		return ListView.separated(
			cacheExtent: 100,
			controller: scrollController,
			itemCount: itemCount,
			padding: Edges.horizontalMedium,
			scrollDirection: Axis.horizontal,
			findChildIndexCallback: (k) {
				final key = k as ValueKey<String>;
				if (key.value == "out-of-index") return itemCount - 1;
				return ids.indexOf(key.value);
			},
			separatorBuilder: (_, __) => const SizedBox(width: Edges.small),
			itemBuilder: (_, i) {
				if (i >= ids.length) {
					return buildOutOfIndex(text, colors, missingCount);
				}

				final id = ids[i];
				final mangaData = data[id]!;

				return MangaCard(
					key: ValueKey(id),
					mangaData: mangaData,
					reactToCoverSizeChanges: widget.reactToCoverSizeChanges,
					onPress: () => widget.onCardPress?.call(mangaData),
				);
			},
		);
	}

	Widget buildOutOfIndex(TextTheme text, ColorScheme colors, int count) {
		final message = "$count ${count > 1 ? "titles are" : "title is"} hidden";
		const description = "Configure your content filters to see them";

		return Container(
			key: const ValueKey("out-of-index"),
			height: 275,
			width: 200,
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
		);
	}
}
