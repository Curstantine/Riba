import "dart:io";

import "package:flutter/material.dart" hide Locale;
import "package:riba/repositories/local/models/localization.dart";
import "package:riba/repositories/local/models/manga.dart";
import "package:riba/repositories/mangadex/mangadex.dart";
import "package:riba/repositories/runtime/manga.dart";
import "package:riba/settings/cover_persistence/controller.dart";
import "package:riba/settings/settings.dart";
import "package:riba/utils/constants.dart";
import "package:riba/utils/errors.dart";
import "package:riba/widgets/material/card.dart";
import "package:rxdart/rxdart.dart";

class MangaPreviewCard extends StatelessWidget implements PreferredSizeWidget {
	const MangaPreviewCard({
		super.key,
		required this.mangaData,
		this.reactToCoverSizeChanges = false,
		this.onPress,
	});

	final bool reactToCoverSizeChanges;
	final MangaData mangaData;
	final VoidCallback? onPress;
	
	@override
	Size get preferredSize => const Size(150, 275);

	Manga get manga => mangaData.manga;

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);

		return Container(
			width: 150,
			constraints: const BoxConstraints(maxHeight: 275),
			child: Column(mainAxisAlignment: MainAxisAlignment.end, crossAxisAlignment: CrossAxisAlignment.start, children: [
				_MangaPreviewCardCover(
					reactToCoverSizeChanges: reactToCoverSizeChanges,
					mangaData: mangaData,
					onPress: onPress,
				),
				SizedBox(height: 50, child: ValueListenableBuilder<List<Locale>>(
					valueListenable:  Settings.instance.appearance.preferredDisplayLocales,
					builder: (context, locales, _) => Text(
						manga.titles.getPreferred(locales) ?? "N/A",
						maxLines: 2,
						softWrap: true,
						overflow: TextOverflow.ellipsis,
						style: theme.textTheme.bodySmall,
					),
				)),
			]),
		);
	}
}

class _MangaPreviewCardCover extends StatefulWidget {
	const _MangaPreviewCardCover({
		required this.reactToCoverSizeChanges,
		required this.mangaData,
		this.onPress,
	});


	final bool reactToCoverSizeChanges;
	final MangaData mangaData;
	final VoidCallback? onPress;

  @override
  State<_MangaPreviewCardCover> createState() => _MangaPreviewCardCoverState();
}

class _MangaPreviewCardCoverState extends State<_MangaPreviewCardCover> {
	CoverPersistenceSettingsController get persistenceSettings => Settings.instance.coverPersistence;

	final coverStream = BehaviorSubject<File?>();

	@override
	void initState() {
		super.initState();
		addCover();

		if (widget.reactToCoverSizeChanges) {
			persistenceSettings.previewSize.addListener(addCover);
		}
	}

	@override
	void dispose() {
		if (widget.reactToCoverSizeChanges) {
			persistenceSettings.previewSize.removeListener(addCover);
		}

		coverStream.close();
		super.dispose();
	}

	void addCover() async {
		try {
			final cover = await MangaDex.instance.cover.getImage(
				widget.mangaData.manga.id,
				widget.mangaData.cover!,
				size: persistenceSettings.previewSize.value,
				cache: persistenceSettings.enabled.value,
			);

			if (mounted && !coverStream.isClosed) coverStream.add(cover);
			if (!widget.reactToCoverSizeChanges) coverStream.close();
		} catch (error) {
			coverStream.addError(ErrorState.fromSource(error));
		}
	}

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		final text = theme.textTheme;
		final colors = theme.colorScheme;

		return Container(
			width: 150,
			constraints: const BoxConstraints(maxHeight: 225),
			child: OutlinedCard(
				clipBehavior: Clip.hardEdge,
				margin: Edges.verticalExtraSmall,
				child: InkWell(onTap: widget.onPress, child: StreamBuilder<File?>(
					stream: coverStream,
					builder: (context, snapshot) {
						if (snapshot.connectionState == ConnectionState.waiting) {
							return const Center(child: CircularProgressIndicator());
						}

						if (snapshot.hasError) {
							final error = ErrorState.fromSource(snapshot.error);

							return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
								Text(error.title,
									style: theme.textTheme.titleSmall?.copyWith(color: theme.colorScheme.error, height: 1),
									textAlign: TextAlign.center),
								const SizedBox(height: Edges.small),
								Text(error.description,
									style: theme.textTheme.bodySmall?.copyWith(height: 1), textAlign: TextAlign.center),
							]));
						}

						if (!snapshot.hasData) {
							return Center(
								child: Text(
									"Cover art not found.",
									style: text.bodySmall?.copyWith(color: colors.onSurfaceVariant),
									textAlign: TextAlign.center,
								),
							);
						}

						return Image.file(
							snapshot.data!,
							fit: BoxFit.fill,
							frameBuilder: (_, child, frame, __) {
								return AnimatedOpacity(
									opacity: frame == null ? 0 : 1,
									duration: Durations.emphasized,
									curve: Easing.emphasized,
									child: child,
								);
							},
						);
					},
				)),
			),
		);
	}
}
