import "dart:io";

import "package:animations/animations.dart";
import "package:flutter/material.dart" hide Locale;
import "package:isar/isar.dart";
import "package:riba/repositories/local/models/localization.dart";
import "package:riba/repositories/local/models/manga.dart";
import "package:riba/repositories/mangadex/mangadex.dart";
import "package:riba/repositories/runtime/manga.dart";
import "package:riba/routes/manga/views/view.dart";
import "package:riba/settings/persistence.dart";
import "package:riba/utils/animations.dart";
import "package:riba/utils/constants.dart";
import "package:riba/utils/errors.dart";
import "package:riba/utils/theme.dart";
import "package:riba/widgets/material/card.dart";

class MangaCard extends StatefulWidget {
	const MangaCard({super.key, required this.mangaData});

	final MangaData mangaData;

  @override
  State<MangaCard> createState() => _MangaCardState();
}

class _MangaCardState extends State<MangaCard> {
	Manga get manga => widget.mangaData.manga;
	
	late final coverStream = CoverPersistenceSettings.ref
		.where()
		.keyEqualTo(CoverPersistenceSettings.isarKey)
		.watch(fireImmediately: true)  
		.asyncMap((e) async {
			if (widget.mangaData.cover == null) return null;

			return await MangaDex.instance.cover.getImage(
				widget.mangaData.manga.id,
				widget.mangaData.cover!,
				size: e.first.previewSize,
				cache: e.first.enabled,
			);
		});

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		final text = theme.textTheme;

		return buildCardLayout(
			theme,
			onTap: () => navigateToMangaView(context),
			// TODO: dynamic preferred locale
			title: manga.titles.getPreferred([Locale.en, Locale.ja]),
			child: StreamBuilder<File?>(
				stream: coverStream,
				builder: (context, snapshot) {
					if (snapshot.connectionState != ConnectionState.active) {
						return const Center(child: CircularProgressIndicator());
					}

					if (snapshot.hasError) {
						return buildError(theme, error: snapshot.error);
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

	Widget buildCardLayout(ThemeData theme, {void Function()? onTap, Widget? child, String? title}) {
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
					SizedBox(
						height: 50,
						child: title == null
							? null
							: Text(title,
								maxLines: 2,
								softWrap: true,
								overflow: TextOverflow.ellipsis,
								style: theme.textTheme.bodySmall),
					),
				],
			),
		);
	}

	Widget buildError(ThemeData theme, {Object? error}) {
		final errorEx = handleError(error ?? "Data was null without errors.");

		return Center(
			child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
				Text(errorEx.title,
					style: theme.textTheme.titleSmall?.copyWith(color: theme.colorScheme.error, height: 1),
					textAlign: TextAlign.center),
				const SizedBox(height: Edges.small),
				Text(errorEx.description,
					style: theme.textTheme.bodySmall?.copyWith(height: 1), textAlign: TextAlign.center),
			]),
		);
	}

	void navigateToMangaView(BuildContext context) {
		Navigator.of(context).push(
			sharedAxis(() => MangaView(id: widget.mangaData.manga.id), SharedAxisTransitionType.vertical),
		);
	}
}
