import "dart:io";

import "package:animations/animations.dart";
import "package:flutter/material.dart" hide Locale;
import "package:riba/repositories/local/models/localization.dart";
import "package:riba/repositories/local/models/manga.dart";
import "package:riba/repositories/mangadex/mangadex.dart";
import "package:riba/repositories/runtime/manga.dart";
import "package:riba/routes/manga/views/view.dart";
import "package:riba/settings/settings.dart";
import "package:riba/utils/animations.dart";
import "package:riba/utils/constants.dart";
import "package:riba/utils/errors.dart";
import "package:riba/utils/theme.dart";
import "package:riba/widgets/material/card.dart";
import "package:riba/widgets/material/skeleton_loaders.dart";

class MangaCard extends StatefulWidget {
	const MangaCard({super.key, required this.mangaData});

	final MangaData mangaData;

	@override
	State<MangaCard> createState() => _MangaCardState();
}

class _MangaCardState extends State<MangaCard> {
	Manga get manga => widget.mangaData.manga;
	
	late final coverStream = Settings.instance.coverPersistence
		.watch(fireImmediately: true)
		.asyncMap((e) async {
			if (widget.mangaData.cover == null) return null;

			return await MangaDex.instance.cover.getImage(
				widget.mangaData.manga.id,
				widget.mangaData.cover!,
				size: e.previewSize,
				cache: e.enabled,
			);
		});

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		final text = theme.textTheme;

		return buildCardLayout(
			theme,
			onTap: () => navigateToMangaView(context),
			child: StreamBuilder<File?>(
				stream: coverStream,
				builder: (context, snapshot) {
					if (snapshot.connectionState != ConnectionState.active) {
						return const Center(child: CircularProgressIndicator());
					}

					if (snapshot.hasError) {
						return buildError(theme, source: snapshot.error);
					}

					if (!snapshot.hasData) {
						return Center(
							child: Text(
								"Cover art not found.",
								style: text.bodySmall?.withColorOpacity(0.85),
								textAlign: TextAlign.center,
							),
						);
					}

					return Image.file(snapshot.data!, fit: BoxFit.fill);
				},
			),
		);
	}

	Widget buildCardLayout(ThemeData theme, {void Function()? onTap, Widget? child}) {
		return Container(
			width: 150,
			constraints: const BoxConstraints(maxHeight: 275),
			child: Column(
				mainAxisAlignment: MainAxisAlignment.end,
				crossAxisAlignment: CrossAxisAlignment.start,
				children: [
					Container(
						width: 150,
						constraints: const BoxConstraints(maxHeight: 225),
						child: OutlinedCard(
							clipBehavior: Clip.hardEdge,
							margin: Edges.verticalExtraSmall,
							child: InkWell(onTap: onTap, child: child ?? const Placeholder())),
					),
					SizedBox(height: 50, child: ValueListenableBuilder<List<Locale>>(
						valueListenable:  Settings.instance.appearance.preferredDisplayLocales,
						builder: (context, locales, _) => Text(
							manga.titles.getPreferred(locales),
							maxLines: 2,
							softWrap: true,
							overflow: TextOverflow.ellipsis,
							style: theme.textTheme.bodySmall,
						),
					)),
				],
			),
		);
	}

	Widget buildError(ThemeData theme, {Object? source}) {
		final error = handleError(source ?? "Data was null without errors.");

		return Center(
			child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
				Text(error.title,
					style: theme.textTheme.titleSmall?.copyWith(color: theme.colorScheme.error, height: 1),
					textAlign: TextAlign.center),
				const SizedBox(height: Edges.small),
				Text(error.description,
					style: theme.textTheme.bodySmall?.copyWith(height: 1), textAlign: TextAlign.center),
			]),
		);
	}

	void navigateToMangaView(BuildContext context) {
		Navigator.of(context).push(
			sharedAxis((_) => MangaView(id: manga.id), SharedAxisTransitionType.vertical),
		);
	}
}

class MangaCardSkeleton extends StatelessWidget {
	const MangaCardSkeleton({super.key});

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		final colors = theme.colorScheme;
		final text = theme.textTheme;


		return SizedBox(
			width: 150,
			height: 250,
			child: Column(
				mainAxisAlignment: MainAxisAlignment.end,
				crossAxisAlignment: CrossAxisAlignment.start,
				children: [
					Expanded(child: Container(
						width: 150,
						margin: Edges.verticalSmall,
						decoration: BoxDecoration(
							color: theme.colorScheme.surface.withOpacity(0.75),
							borderRadius: Corners.allMedium,
						),
						// child: const Placeholder(),
					)),
					TextSkeleton(style: text.bodyLarge!, color: colors.surface.withOpacity(0.5)),
				],
			),
		);
	}
}