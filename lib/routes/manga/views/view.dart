import "dart:io";

import "package:flutter/material.dart" hide Locale;
import "package:flutter/services.dart";
import "package:riba/repositories/local/author.dart";
import "package:riba/repositories/local/localization.dart";
import "package:riba/repositories/local/manga.dart";
import "package:riba/repositories/local/statistics.dart";
import "package:riba/repositories/mangadex/mangadex.dart";
import "package:riba/repositories/runtime/manga.dart";
import "package:riba/routes/manga/widgets/button.dart";
import "package:riba/routes/manga/widgets/chip.dart";
import "package:riba/routes/manga/widgets/sheet.dart";
import "package:riba/settings/cache.dart";
import "package:riba/utils/constants.dart";
import "package:riba/utils/errors.dart";
import "package:riba/utils/lazy.dart";
import "package:riba/utils/theme.dart";

class MangaView extends StatefulWidget {
  const MangaView({super.key, required this.id});

  final String id;

  @override
  State<MangaView> createState() => _MangaViewState();
}

class _MangaViewState extends State<MangaView> {
  final expandedAppBarHeight = 500.0;
  final scrollController = ScrollController();
  final preferredLocales = [Locale.en, Locale.ja];

  bool showAppBar = false;
  bool expandDescription = false;

  Future<MangaData>? mangaFuture;
  Future<Statistics>? statisticsFuture;
  Future<File?>? coverFuture;

  bool isFollowed = false;
  bool hasTrackers = false;
  bool hasCustomLists = false;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(onScroll);

    fetchMangaData();
  }

  @override
  void dispose() {
    scrollController.removeListener(onScroll);
    scrollController.dispose();
    super.dispose();
  }

  void fetchMangaData() {
    mangaFuture = MangaDex.instance.manga.get(widget.id);
    statisticsFuture = MangaDex.instance.manga.getStatistics(widget.id);
    coverFuture = mangaFuture?.then((data) {
      if (data.cover == null) return Future.value(null);
      return MangaDex.instance.covers
          .getImage(widget.id, data.cover!, size: CacheSettings.instance.fullSize);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final media = MediaQuery.of(context);
    final text = theme.textTheme;

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: FutureBuilder<MangaData>(
        future: mangaFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || !snapshot.hasData) {
            final error = handleError(snapshot.error ?? "Data was null without errors.");

            return Center(
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(error.title, style: theme.textTheme.titleLarge),
                Text(error.description, style: theme.textTheme.bodyMedium),
                const SizedBox(height: Edges.large),
                ElevatedButton(
                  onPressed: () => setState(() => fetchMangaData()),
                  child: const Text("Retry"),
                ),
              ]),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              setState(() => fetchMangaData());
            },
            child: CustomScrollView(controller: scrollController, slivers: [
              SliverAppBar(
                pinned: true,
                expandedHeight: expandedAppBarHeight,
                title: AnimatedOpacity(
                  opacity: showAppBar ? 1 : 0,
                  duration: Durations.normal,
                  child: Text(snapshot.data!.manga.titles.getPreferred(preferredLocales),
                      style: text.titleMedium),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  background: detailsHeader(snapshot.data!),
                  titlePadding: Edges.allNone,
                ),
              ),
              SliverToBoxAdapter(
                  child: buildDescription(theme, media.textScaleFactor, snapshot.data!.manga)),
              SliverToBoxAdapter(child: buildContents(theme, snapshot.data!))
            ]),
          );
        },
      ),
    );
  }

  Widget detailsHeader(MangaData mangaData) {
    final theme = Theme.of(context);
    final media = MediaQuery.of(context);
    final text = theme.textTheme;
    final colors = theme.colorScheme;

    final title = mangaData.manga.titles.getPreferred(preferredLocales);
    final authorList = (mangaData.authors + mangaData.artists.whereNotIn(mangaData.authors))
        .map((e) => e.name)
        .join(", ");

    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: expandedAppBarHeight + media.padding.top,
          foregroundDecoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: const [0, 0.5, 0.65, 1],
              colors: [
                theme.colorScheme.background.withOpacity(0),
                theme.colorScheme.background.withOpacity(0.85),
                theme.colorScheme.background.withOpacity(0.95),
                theme.colorScheme.background,
              ],
            ),
          ),
          child: FutureBuilder<File?>(
            future: coverFuture,
            builder: (context, snapshot) {
              List<Widget>? children;

              if (snapshot.connectionState != ConnectionState.done) {
                children = [const CircularProgressIndicator()];
              }

              if (snapshot.hasError) {
                final error = handleError(snapshot.error!);
                children = [
                  Text(error.title, style: text.titleMedium?.copyWith(color: colors.error)),
                  Text(error.description)
                ];
              }

              if (!snapshot.hasData &&
                  !snapshot.hasError &&
                  snapshot.connectionState == ConnectionState.done) {
                children = [Icon(Icons.broken_image_outlined, size: 72, color: colors.secondary)];
              }

              if (children != null) {
                return Align(
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    height: expandedAppBarHeight - 100 + media.padding.top,
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: children),
                  ),
                );
              }

              return Padding(
                padding: Edges.bottomSmall,
                child: Image.file(
                  snapshot.data!,
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                ),
              );
            },
          ),
        ),
        Container(
          width: double.infinity,
          height: expandedAppBarHeight + media.padding.top,
          padding: Edges.horizontalMedium.copyWith(bottom: Edges.large),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: InkWell(onTap: () => showCoverSheet(mangaData))),
              Text(title, style: text.titleLarge),
              Text(authorList, style: text.labelMedium?.withColorOpacity(0.5)),
              const SizedBox(height: Edges.small),
              SizedBox(
                height: 25,
                child: FutureBuilder<Statistics>(
                  future: statisticsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      final error = handleError(snapshot.error!);
                      final label = text.bodyMedium?.copyWith(color: colors.error);

                      return InkWell(
                        onLongPress: () {
                          Clipboard.setData(ClipboardData(text: error.toString()));
                          showLazyBar(context, "Error copied to clipboard.");
                        },
                        child: ListView(scrollDirection: Axis.horizontal, children: [
                          Text(error.title, style: label),
                          const SizedBox(width: Edges.small),
                          Text(error.description, style: label?.withColorOpacity(0.75)),
                        ]),
                      );
                    }

                    final rating = snapshot.data?.rating?.bayesian ?? 0.0;
                    final follows = snapshot.data?.follows ?? 0;
                    final comments = snapshot.data?.comments?.total ?? 0;

                    return Row(children: [
                      TinyButton(
                        enabled: snapshot.data?.rating != null,
                        text: rating.toStringAsFixed(2),
                        icon: Icons.star_border_rounded,
                        onTap: () => snapshot.data?.rating == null
                            ? null
                            : showRatingStatisticSheet(snapshot.data!.rating!),
                      ),
                      const SizedBox(width: Edges.small),
                      TinyButton(
                        enabled: snapshot.data?.follows != null,
                        text: follows.toString(),
                        icon: Icons.bookmark_border_rounded,
                      ),
                      const SizedBox(width: Edges.small),
                      TinyButton(
                        enabled: snapshot.data?.comments != null,
                        text: comments.toString(),
                        icon: Icons.comment_outlined,
                      ),
                    ]);
                  },
                ),
              ),
              const SizedBox(height: Edges.small),
              Wrap(
                spacing: Edges.extraSmall,
                runSpacing: Edges.small,
                children: [
                  ContentRatingChip(contentRating: mangaData.manga.contentRating),
                  DemographicChip(demographic: mangaData.manga.publicationDemographic),
                  for (final tag in mangaData.tags)
                    TagChip(tag: tag, preferredLocales: preferredLocales),
                ],
              ),
              const SizedBox(height: Edges.large),
              SizedBox(
                height: 40,
                child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  children: [
                    buildFollowButton(),
                    if (isFollowed) ...[const SizedBox(width: 8), buildTrackerButton()],
                    const SizedBox(width: 8),
                    OutlinedButton(onPressed: () => {}, child: const Text("Custom Lists")),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildDescription(ThemeData theme, double textScaleFactor, Manga manga) {
    final span = TextSpan(
      text: manga.description.getPreferred(preferredLocales),
      style: theme.textTheme.bodyMedium,
    );

    return Padding(
      padding: Edges.horizontalMedium,
      child: LayoutBuilder(builder: (context, constraints) {
        final minTp = TextPainter(
            text: span,
            maxLines: 5,
            textDirection: TextDirection.ltr,
            textScaleFactor: textScaleFactor,
            strutStyle: StrutStyle.fromTextStyle(span.style!))
          ..layout(maxWidth: constraints.maxWidth, minWidth: constraints.minWidth);

        final maxTp = TextPainter(
          text: span,
          textDirection: TextDirection.ltr,
          strutStyle: StrutStyle.fromTextStyle(span.style!),
          textScaleFactor: textScaleFactor,
        )..layout(maxWidth: constraints.maxWidth, minWidth: constraints.minWidth);

        final content = Text.rich(span);

        if (!minTp.didExceedMaxLines) {
          return content;
        }

        return Stack(
          children: [
            AnimatedContainer(
              height: expandDescription ? maxTp.height : minTp.height,
              curve: Curves.easeInOutCubic,
              duration: Durations.slow,
              clipBehavior: Clip.hardEdge,
              decoration: const BoxDecoration(),
              foregroundDecoration: BoxDecoration(
                gradient: expandDescription
                    ? null
                    : LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: const [0, 0.5, 0.75, 1],
                        colors: [
                          theme.colorScheme.background.withOpacity(0),
                          theme.colorScheme.background.withOpacity(0.75),
                          theme.colorScheme.background.withOpacity(0.95),
                          theme.colorScheme.background,
                        ],
                      ),
              ),
              child: content,
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: IconButton(
                isSelected: expandDescription,
                icon: AnimatedRotation(
                  duration: Durations.slow,
                  turns: expandDescription ? 0.5 : 0,
                  curve: Curves.easeInOutCubic,
                  child: const Icon(Icons.expand_more_rounded),
                ),
                visualDensity: VisualDensity.compact,
                tooltip: expandDescription ? "Collapse" : "Expand",
                onPressed: () => setState(() => expandDescription = !expandDescription),
                style: IconButton.styleFrom(
                    backgroundColor: expandDescription ? theme.colorScheme.primaryContainer : null,
                    foregroundColor:
                        expandDescription ? theme.colorScheme.onPrimaryContainer : null,
                    highlightColor: theme.colorScheme.surfaceTint),
              ),
            ),
          ],
        );
      }),
    );
  }

  LayoutBuilder buildTags(MangaData mangaData, ThemeData theme) {
    final tags = mangaData.tags.map(
      (tag) => SizedBox(
        height: 32,
        child: ActionChip(
            padding: Edges.allNone,
            labelStyle: theme.textTheme.labelSmall?.withColorOpacity(0.75),
            label: Text(tag.name.getPreferred(preferredLocales)),
            onPressed: () => {}),
      ),
    );

    return LayoutBuilder(builder: (context, constraints) {
      return ConstrainedBox(
        constraints: BoxConstraints(maxWidth: constraints.maxWidth),
        child: Wrap(
          runSpacing: Edges.extraSmall,
          spacing: Edges.extraSmall,
          children: tags.toList(),
        ),
      );
    });
  }

  Widget buildContents(ThemeData theme, MangaData mangaData) {
    return Column(children: const [
      SizedBox(height: 10000),
    ]);
  }

  Widget buildFollowButton() {
    return AnimatedSize(
      duration: Durations.slow,
      curve: Curves.easeInOut,
      alignment: Alignment.centerLeft,
      child: isFollowed
          ? FilledButton.icon(
              onPressed: () => changeFollowStatus(false),
              icon: const Icon(Icons.check_rounded),
              label: const Text("Reading"))
          : FilledButton.icon(
              onPressed: () => changeFollowStatus(true),
              icon: const Icon(Icons.add_rounded),
              label: const Text("Add to Library")),
    );
  }

  Widget buildTrackerButton() {
    return OutlinedButton.icon(
      onPressed: handleTrackerPress,
      icon: hasTrackers ? const Icon(Icons.sync_rounded) : const Icon(Icons.add_rounded),
      label: hasTrackers ? const Text("Tracking") : const Text("Track"),
    );
  }

  void showRatingStatisticSheet(RatingStatistics rating) {
    final media = MediaQuery.of(context);

    showModalBottomSheet(
      context: context,
      builder: (context) => RatingDetailsSheet(
          rating: rating, padding: EdgeInsets.only(bottom: media.padding.bottom)),
    );
  }

  void showCoverSheet(MangaData mangaData) {
    final media = MediaQuery.of(context);

    showModalBottomSheet(
      context: context,
      shape: Shapes.none,
      isScrollControlled: true,
      builder: (context) => CoverSheet(
          mangaData: mangaData,
          padding: EdgeInsets.only(top: media.padding.top, bottom: media.padding.bottom)),
    );
  }

  Future<void> changeFollowStatus(bool follow) async {
    setState(() => isFollowed = follow);
  }

  Future<void> handleTrackerPress() async {
    setState(() => hasTrackers = !hasTrackers);
  }

  void onScroll() {
    final height = expandedAppBarHeight - 52;

    if (showAppBar && scrollController.offset < height) {
      setState(() => showAppBar = false);
    } else if (!showAppBar && scrollController.offset > height) {
      setState(() => showAppBar = true);
    }
  }
}
