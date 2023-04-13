import "dart:io";

import "package:animations/animations.dart";
import "package:flutter/material.dart" hide Locale;
import "package:isar/isar.dart";
import "package:riba/repositories/local/models/cover_art.dart";
import "package:riba/repositories/local/models/localization.dart";
import "package:riba/repositories/local/models/manga.dart";
import "package:riba/repositories/mangadex/mangadex.dart";
import "package:riba/repositories/runtime/manga.dart";
import "package:riba/routes/manga/views/view.dart";
import "package:riba/settings/cache.dart";
import "package:riba/utils/animations.dart";
import "package:riba/utils/constants.dart";
import "package:riba/utils/errors.dart";
import "package:riba/utils/theme.dart";
import "package:riba/widgets/material/card.dart";

class MangaCard extends StatelessWidget {
  MangaCard({super.key, required this.id});

  final String id;

  late final coverCacheSettingsStream = CoverCacheSettings.ref
      .where()
      .keyEqualTo(CoverCacheSettings.isarKey)
      .watch()
      .asBroadcastStream()
      .asyncMap((e) => e.first);

  late final mangaFuture = MangaDex.instance.manga.get(id);

  late final Stream<File?> coverStream = coverCacheSettingsStream.asyncMap((e) async {
    final mangaData = await mangaFuture;
    if (mangaData.cover == null) return null;

    return MangaDex.instance.cover.getFile(
      mangaData.manga.id,
      mangaData.cover!.fileId,
      mangaData.cover!.fileType,
      e.previewSize,
      e.enabled,
    );
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FutureBuilder<MangaData>(
      future: mangaFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return buildCardLayout(theme, child: const Center(child: CircularProgressIndicator()));
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return buildCardLayout(theme, child: buildError(theme, error: snapshot.error));
        }

        final data = snapshot.requireData;

        return buildCard(theme, context, data.manga, data.cover);
      },
    );
  }

  Widget buildCard(ThemeData theme, BuildContext context, Manga manga, CoverArt? cover) {
    return buildCardLayout(
      theme,
      onTap: () => navigateToMangaView(context),
      // TODO: dynamic preferred locale
      title: manga.titles.getPreferred([Locale.en, Locale.ja]),
      child: StreamBuilder<File?>(
        stream: coverStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return buildError(theme, error: snapshot.error);
          }

          if (!snapshot.hasData) {
            return Center(
              child: Text(
                "Cover art not found.",
                style: theme.textTheme.bodySmall?.withColorOpacity(0.85),
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
    Navigator.push(context, sharedAxis(() => MangaView(id: id), SharedAxisTransitionType.vertical));
  }
}
