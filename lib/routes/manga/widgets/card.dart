import "dart:io";

import "package:animations/animations.dart";
import "package:flutter/material.dart" hide Locale;
import "package:hive_flutter/hive_flutter.dart";
import "package:riba/repositories/local/cover_art.dart";
import "package:riba/repositories/local/localization.dart";
import "package:riba/repositories/mangadex/mangadex.dart";
import "package:riba/repositories/runtime/manga.dart";
import "package:riba/routes/manga/views/view.dart";
import "package:riba/settings/caching.dart";
import "package:riba/utils/animations.dart";
import "package:riba/utils/constants.dart";
import "package:riba/utils/errors.dart";
import "package:riba/utils/theme.dart";
import "package:riba/widgets/material/card.dart";

class MangaCard extends StatelessWidget {
  const MangaCard({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ValueListenableBuilder(
        valueListenable:
            CacheSettings.instance.box.listenable(keys: [CacheSettingKeys.previewSize]),
        builder: (context, box, child) {
          return FutureBuilder<MangaData>(
            future: MangaDex.instance.manga.get(id),
            builder: (context, snapshot) {
              final previewCoverSize = box.get(CacheSettingKeys.previewSize)! as CoverSize;

              if (snapshot.connectionState != ConnectionState.done) {
                return buildCard(theme, child: const Center(child: CircularProgressIndicator()));
              }

              if (snapshot.hasError || !snapshot.hasData) {
                return buildCard(theme, child: buildError(theme, error: snapshot.error));
              }

              final cover = snapshot.data!.cover;

              return buildCard(
                theme,
                onTap: () => Navigator.push(context,
                    sharedAxis(() => MangaView(id: id), SharedAxisTransitionType.vertical)),
                title: snapshot.data!.manga.titles.getPreferred([Locale.en, Locale.ja]),
                child: FutureBuilder<File?>(
                  future: cover == null
                      ? Future.value(null)
                      : MangaDex.instance.covers.getImage(id, cover, size: previewCoverSize),
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
            },
          );
        });
  }

  Widget buildCard(ThemeData theme, {void Function()? onTap, Widget? child, String? title}) {
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
}
