import "dart:io";

import "package:dash_flags/dash_flags.dart";
import "package:flutter/material.dart" hide Locale;
import "package:riba/repositories/local/models/cover_art.dart";
import "package:riba/repositories/local/models/manga.dart";
import "package:riba/repositories/mangadex/mangadex.dart";
import "package:riba/repositories/runtime/manga.dart";
import "package:riba/routes/manga/widgets/chips.dart";
import "package:riba/settings/cover_persistence/controller.dart";
import "package:riba/settings/settings.dart";
import "package:riba/utils/constants.dart";
import "package:riba/utils/errors.dart";
import "package:riba/utils/theme.dart";

class MangaListCard extends StatelessWidget implements PreferredSizeWidget {
	const MangaListCard({super.key, required this.mangaData, this.onPress});

	final MangaData mangaData;
	final VoidCallback? onPress;
	
	Manga get manga => mangaData.manga;

	@override
	Size get preferredSize => const Size(150, 275);

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		final text = theme.textTheme;
		final colors = theme.colorScheme;

		return SizedBox(height: 150, child: Card(
			shadowColor: Colors.transparent,
			margin: Edges.horizontalMedium.copyWithSelf(Edges.verticalExtraSmall),
			child: InkWell(onTap: onPress, child: Row(children: [
				_MangaListCardCover(mangaId: manga.id, cover: mangaData.cover!),
				Expanded(child: Padding(
					padding: Edges.allSmall,
					child: Stack(children: [
						Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
							Text(
								manga.titles.getPreferred(Settings.instance.appearance.preferredDisplayLocales.value) ?? "N/A",
								style: text.bodyMedium!.copyWith(height: 1.2),
								// Shit like these exist:
								// https://mangadex.org/title/7c5cbad4-8bfe-48b3-af13-18c338dda5da
								maxLines: 4,
								overflow: TextOverflow.ellipsis,
							),
							Text(
								mangaData.authors.map((e) => e.name).join(", "),
								style: text.labelMedium!.copyWith(color: colors.onSurfaceVariant),
							),
							const Spacer(),
							Wrap(spacing: Edges.extraSmall, children: [
								PublicationStatusChip(status: manga.status, surfaceColor: colors.surface),
								ContentRatingChip(contentRating: manga.contentRating, surfaceColor: colors.surface),
							]),
						]),
						Align(
							alignment: Alignment.bottomRight,
							child: LanguageFlag(
								height: 18,
								language: manga.originalLanguage.getFlag(),
							),
						)
					]),
				)),
			])),
		));
	}
}

class _MangaListCardCover extends StatefulWidget {
	const _MangaListCardCover({required this.mangaId, required this.cover});

	final String mangaId;
	final CoverArt cover;

	@override
	State<_MangaListCardCover> createState() => _MangaListCardCoverState();
}

class _MangaListCardCoverState extends State<_MangaListCardCover> {
	CoverPersistenceSettingsController get persistenceSettings => Settings.instance.coverPersistence;

	Future<File?>? coverFuture;

	@override
	void initState() {
		super.initState();
		addCover();
	}

	void addCover() async {
		coverFuture = MangaDex.instance.cover.getImage(
			widget.mangaId,
			widget.cover,
			size: persistenceSettings.previewSize.value,
			cache: persistenceSettings.enabled.value,
		);

		if (mounted) setState(() => {});
	}

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		final text = theme.textTheme;
		final colors = theme.colorScheme;

		return SizedBox(width: 100, height: double.infinity, child: FutureBuilder<File?>(
			future: coverFuture,
			builder: (context, snapshot) {
				if (snapshot.connectionState == ConnectionState.waiting) {
					return const Center(child: CircularProgressIndicator());
				}

				if (snapshot.hasError) {
					final error = ErrorState.fromSource(snapshot.error);
					return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
						Text(
							error.title,
							style: text.titleSmall?.copyWith(color: colors.error, height: 1),
							textAlign: TextAlign.center,
						),
						const SizedBox(height: Edges.small),
						Text(
							error.description,
							style: text.bodySmall?.copyWith(height: 1),
							textAlign: TextAlign.center,
						),
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

				return ClipRRect(
					borderRadius: Corners.leftMedium,
					child: Image.file(
						snapshot.data!,
						fit: BoxFit.cover,
						frameBuilder: (_, child, frame, __) {
							return AnimatedOpacity(
								opacity: frame == null ? 0 : 1,
								duration: LocalDurations.emphasized,
								curve: LocalEasing.emphasized,
								child: child,
							);
						},
					),
				);
			},
		));
	}
}