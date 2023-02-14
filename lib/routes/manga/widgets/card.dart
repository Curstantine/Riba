import "package:flutter/material.dart" hide Locale;
import "package:animations/animations.dart";
import "package:riba/repositories/local/localization.dart";
import "package:riba/repositories/mangadex/mangadex.dart";
import "package:riba/repositories/runtime/manga.dart";
import "package:riba/routes/manga/views/view.dart";
import "package:riba/utils/animations.dart";
import "package:riba/utils/constants.dart";
import "package:riba/utils/errors.dart";
import "package:riba/settings/theme.dart";
import "package:riba/widgets/material/card.dart";

class MangaCard extends StatelessWidget {
  const MangaCard({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FutureBuilder<MangaData>(
      future: MangaDex.instance.manga.get(id),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return SizedBox(
            height: 225,
            child: buildCard(theme, child: const Center(child: CircularProgressIndicator())),
          );
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return buildCard(theme, child: buildError(theme, error: snapshot.error));
        }

        return buildCard(
          theme,
          onTap: () => Navigator.push(
              context, sharedAxis(() => MangaView(id: id), SharedAxisTransitionType.vertical)),
          title: snapshot.data!.manga.titles.getPreferred([Locale.en, Locale.ja]),
          child: FutureBuilder(
            future: MangaDex.instance.covers.get(id, snapshot.data!.cover!.fileName),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError || !snapshot.hasData) {
                return buildError(theme, error: snapshot.error);
              }

              return Image.file(snapshot.data!, fit: BoxFit.cover);
            },
          ),
        );
      },
    );
  }

  Widget buildCard(ThemeData theme, {Function()? onTap, Widget? child, String? title}) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 275, minWidth: 150, maxWidth: 150),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 225),
          child: OutlinedCard(
              clipBehavior: Clip.hardEdge,
              margin: Edges.verticalExtraSmall,
              child: InkWell(onTap: onTap, child: child ?? const Placeholder())),
        ),
        if (title != null)
          Text(title,
              maxLines: 2,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelSmall?.withColorAlpha(0.85)),
      ]),
    );
  }

  Widget buildError(ThemeData theme, {Object? error}) {
    final errorEx = handleError(error ?? "Data was null without errors.");

    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(errorEx.title,
            style: theme.textTheme.titleSmall?.copyWith(color: theme.colorScheme.error),
            textAlign: TextAlign.center),
        const SizedBox(height: 4),
        Text(errorEx.description, style: theme.textTheme.bodySmall),
      ]),
    );
  }
}
