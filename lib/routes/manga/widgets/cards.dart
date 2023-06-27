import "dart:io";

import "package:animations/animations.dart";
import "package:flutter/material.dart" hide Locale;
import "package:riba/repositories/local/models/localization.dart";
import "package:riba/repositories/local/models/manga.dart";
import "package:riba/repositories/mangadex/mangadex.dart";
import "package:riba/repositories/runtime/manga.dart";
import "package:riba/routes/manga/views/model.dart";
import "package:riba/routes/manga/views/view.dart";
import "package:riba/settings/cover_persistence/controller.dart";
import "package:riba/settings/settings.dart";
import "package:riba/utils/animations.dart";
import "package:riba/utils/constants.dart";
import "package:riba/utils/errors.dart";
import "package:riba/utils/theme.dart";
import "package:riba/widgets/material/card.dart";
import "package:rxdart/rxdart.dart";

class MangaCard extends StatefulWidget {
	const MangaCard({super.key, required this.mangaData, this.onPress});

	final MangaData mangaData;
	final VoidCallback? onPress;

	@override
	State<MangaCard> createState() => _MangaCardState();
}

class _MangaCardState extends State<MangaCard> {
	Manga get manga => widget.mangaData.manga;
	CoverPersistenceSettingsController get persistenceSettings => Settings.instance.coverPersistence;

	final coverStream = BehaviorSubject<File?>();

	@override
	void initState() {
		super.initState();
		addCover();
		Settings.instance.coverPersistence.previewSize.addListener(addCover);
	}

	@override
	void dispose() {
		Settings.instance.coverPersistence.previewSize.removeListener(addCover);
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

			coverStream.add(cover);
		} catch (error) {
			coverStream.addError(ErrorState.fromSource(error));
		}
	}

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		final text = theme.textTheme;

		return Container(
			width: 150,
			constraints: const BoxConstraints(maxHeight: 275),
			child: Column(mainAxisAlignment: MainAxisAlignment.end, crossAxisAlignment: CrossAxisAlignment.start, children: [
				Container(
					width: 150,
					constraints: const BoxConstraints(maxHeight: 225),
					child: OutlinedCard(
						clipBehavior: Clip.hardEdge,
						margin: Edges.verticalExtraSmall,
						child: InkWell(onTap: onCardPress, child: StreamBuilder<File?>(
							stream: coverStream,
							builder: (context, snapshot) {
								if (snapshot.connectionState != ConnectionState.active) {
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
											style: text.bodySmall?.withColorOpacity(0.85),
											textAlign: TextAlign.center,
										),
									);
								}

								return Image.file(snapshot.data!, fit: BoxFit.fill);
							},
						)),
					),
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
			]),
		);
	}

	void onCardPress() {
		widget.onPress?.call();
		
		Navigator.push(context, sharedAxis(
			(_) => MangaView(viewModel: MangaViewModel(mangaId: manga.id), initialData: widget.mangaData),
			SharedAxisTransitionType.vertical
		));
	}
}
