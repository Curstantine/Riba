import "dart:async";
import "dart:io";

import "package:dash_flags/dash_flags.dart" as flags;
import "package:flutter/material.dart" hide Locale;
import "package:flutter/services.dart";
import "package:hive_flutter/hive_flutter.dart";
import "package:intl/intl.dart" show DateFormat;
import "package:logging/logging.dart";
import "package:riba/repositories/local/author.dart";
import "package:riba/repositories/local/localization.dart";
import "package:riba/repositories/local/manga.dart";
import "package:riba/repositories/local/statistics.dart";
import "package:riba/repositories/mangadex/mangadex.dart";
import "package:riba/repositories/runtime/chapter.dart";
import "package:riba/repositories/runtime/manga.dart";
import "package:riba/routes/manga/widgets/button.dart";
import "package:riba/routes/manga/widgets/chip.dart";
import "package:riba/routes/manga/widgets/sheet.dart";
import "package:riba/settings/cache.dart";
import "package:riba/settings/filter.dart";
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
  final logger = Logger("MangaView");
  final scrollController = ScrollController();
  final preferredLocales = [Locale.en, Locale.ja];
  final cacheSettings = CacheSettings.instance;
  final filterSettings = FilterSettings.instance;

  final showAppBar = ValueNotifier(false);
  final expandDescription = ValueNotifier(false);
  final filtersApplied = ValueNotifier(false);

  late Future<MangaData> mangaFuture;
  late Future<Statistics> statisticsFuture;
  late Future<File?> coverFuture;

  late StreamController<List<ChapterData>> chapterStreamController =
      StreamController<List<ChapterData>>.broadcast(
    onListen: () => logger.info("Chapter stream opened"),
  );
  Stream<List<ChapterData>> get chapterStream => chapterStreamController.stream;

  /// TODO: migrate to ValueNotifier with user login and etc.
  bool isFollowed = false;
  bool hasTrackers = false;
  bool hasCustomLists = false;

  late final colors = Theme.of(context).colorScheme;
  late final text = Theme.of(context).textTheme;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(onScroll);

    fetchMangaData();
  }

  @override
  void dispose() {
    chapterStreamController.close();
    scrollController.removeListener(onScroll);
    scrollController.dispose();
    super.dispose();
  }

  void fetchMangaData({bool reload = false}) {
    mangaFuture = MangaDex.instance.manga.get(widget.id, checkDB: !reload);
    statisticsFuture = MangaDex.instance.manga.getStatistics(widget.id, checkDB: !reload);
    coverFuture = mangaFuture.then((data) {
      if (data.cover == null) return Future.value(null);

      return MangaDex.instance.covers.getImage(
        widget.id,
        data.cover!,
        size: cacheSettings.fullSize,
        cache: cacheSettings.cacheCovers,
      );
    });

    chapterStreamController.addStream(fetchChapters(reload: reload).asStream());
  }

  Future<List<ChapterData>> fetchChapters({bool reload = false, int offset = 0}) async {
    final filters = await filterSettings.mangaFilters.get(widget.id) ?? MangaFilterData.defaults();
    final data = await MangaDex.instance.chapter.getFeed(
      widget.id,
      checkDB: !reload,
      langs: preferredLocales,
      excludedGroups: filters.excludedGroupIds,
    );

    return data;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final media = MediaQuery.of(context);
    final textScale = media.textScaleFactor;

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: FutureBuilder(
        // Lol. Don't setState for anything other than fetchMangaData.
        // Shit will break, badly.
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
                  onPressed: () => setState(() => fetchMangaData(reload: true)),
                  child: const Text("Retry"),
                ),
              ]),
            );
          }

          final mangaData = snapshot.requireData;

          return RefreshIndicator(
            onRefresh: () async {
              setState(() => fetchMangaData(reload: true));
            },
            child: CustomScrollView(controller: scrollController, slivers: [
              buildAppBar(text, colors, media, mangaData),
              SliverToBoxAdapter(child: buildDescription(textScale, mangaData.manga)),
              SliverToBoxAdapter(child: buildReadButton()),
              SliverToBoxAdapter(child: buildChapterHeader()),
              buildChapters(),
            ]),
          );
        },
      ),
    );
  }

  Widget buildAppBar(
      TextTheme text, ColorScheme colors, MediaQueryData media, MangaData mangaData) {
    return SliverAppBar(
      pinned: true,
      expandedHeight: expandedAppBarHeight,
      title: ValueListenableBuilder(
        valueListenable: showAppBar,
        child: Text(mangaData.manga.titles.getPreferred(preferredLocales), style: text.titleMedium),
        builder: (context, value, child) => AnimatedOpacity(
          opacity: value ? 1 : 0,
          duration: Durations.normal,
          child: child,
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        background: buildDetailsHeader(text, colors, media, mangaData),
        titlePadding: Edges.allNone,
      ),
    );
  }

  Widget buildReadButton() {
    return Padding(
      padding: Edges.horizontalLarge.copyWithSelf(Edges.verticalMedium),
      child: FilledButton.tonal(
        onPressed: () {},
        child: const Text("Start Reading"),
      ),
    );
  }

  Widget buildDetailsHeader(
      TextTheme text, ColorScheme colors, MediaQueryData media, MangaData mangaData) {
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
                colors.background.withOpacity(0),
                colors.background.withOpacity(0.85),
                colors.background.withOpacity(0.95),
                colors.background,
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

  Widget buildDescription(double textScaleFactor, Manga manga) {
    final span = TextSpan(
      text: manga.description.getPreferred(preferredLocales),
      style: text.bodyMedium,
    );

    return Padding(
      padding: Edges.horizontalMedium,
      child: LayoutBuilder(builder: (context, constraints) {
        final minTp = TextPainter(
            text: span,
            maxLines: 4,
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

        return ValueListenableBuilder(
          valueListenable: expandDescription,
          builder: (context, value, child) {
            return Stack(
              children: [
                AnimatedContainer(
                  height: value ? maxTp.height + Edges.extraLarge : minTp.height,
                  curve: Curves.easeInOutCubic,
                  duration: Durations.slow,
                  clipBehavior: Clip.hardEdge,
                  decoration: const BoxDecoration(),
                  foregroundDecoration: BoxDecoration(
                    gradient: value
                        ? null
                        : LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: const [0, 0.5, 0.75, 1],
                            colors: [
                              colors.background.withOpacity(0),
                              colors.background.withOpacity(0.75),
                              colors.background.withOpacity(0.95),
                              colors.background,
                            ],
                          ),
                  ),
                  child: content,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: IconButton(
                    isSelected: value,
                    icon: AnimatedRotation(
                      duration: Durations.slow,
                      turns: value ? 0.5 : 0,
                      curve: Curves.easeInOutCubic,
                      child: const Icon(Icons.expand_more_rounded),
                    ),
                    visualDensity: VisualDensity.compact,
                    tooltip: value ? "Collapse" : "Expand",
                    onPressed: () => expandDescription.value = !expandDescription.value,
                    style: IconButton.styleFrom(
                        backgroundColor: value ? colors.primaryContainer : null,
                        foregroundColor: value ? colors.onPrimaryContainer : null),
                  ),
                ),
              ],
            );
          },
        );
      }),
    );
  }

  LayoutBuilder buildTags(MangaData mangaData) {
    final tags = mangaData.tags.map(
      (tag) => SizedBox(
        height: 32,
        child: ActionChip(
            padding: Edges.allNone,
            labelStyle: text.labelSmall?.withColorOpacity(0.75),
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

  /// Handles both the filter and loading indicator for chapters.
  Widget buildChapterHeader() {
    return StreamBuilder<List<ChapterData>>(
        stream: chapterStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.none) {
            return const SizedBox.shrink();
          }

          final chapters = snapshot.data;
          final chapterCount = chapters?.length ?? 0;

          return Container(
            height: 40,
            padding: Edges.horizontalMedium,
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text("$chapterCount Chapters",
                  style: text.titleMedium?.withColorOpacity(chapters != null ? 1 : 0.5)),
              ValueListenableBuilder(
                valueListenable: filterSettings.mangaFilters.listenable(keys: [widget.id]),
                child: const SizedBox.square(
                  dimension: 24,
                  child: Center(child: CircularProgressIndicator(strokeWidth: 3)),
                ),
                builder: (context, value, loadingChild) {
                  return FutureBuilder<MangaFilterData?>(
                    future: value.get(widget.id),
                    builder: (context, filterSnapshot) {
                      if (!snapshot.hasData ||
                          filterSnapshot.connectionState != ConnectionState.done) {
                        return loadingChild!;
                      }

                      final filterData = filterSnapshot.data ?? MangaFilterData.defaults();

                      return IconButton(
                        isSelected: !filterData.isDefault,
                        icon: const Icon(Icons.filter_list_rounded),
                        selectedIcon: Icon(Icons.filter_list_rounded, color: colors.primary),
                        visualDensity: VisualDensity.comfortable,
                        onPressed: () =>
                            chapters == null ? null : showFilterSheet(chapters, filterData),
                      );
                    },
                  );
                },
              )
            ]),
          );
        });
  }

  Widget buildChapters() {
    return StreamBuilder<List<ChapterData>>(
      stream: chapterStream,
      builder: (context, snapshot) {
        // Since the loading indicator is in the header, we don't need to handle other states here.
        if (snapshot.connectionState != ConnectionState.active && !snapshot.hasData) {
          return const SliverToBoxAdapter(child: SizedBox.shrink());
        }

        if (snapshot.hasError) {
          final error = handleError(snapshot.error!);

          return SliverToBoxAdapter(
            child: SizedBox(
              height: 150,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(error.title, style: text.titleLarge?.copyWith(color: colors.error)),
                  const SizedBox(height: 8),
                  Text(error.description, style: text.bodySmall),
                ],
              ),
            ),
          );
        }

        if (snapshot.data!.isEmpty) {
          return const SliverToBoxAdapter(
            child: SizedBox(height: 100, child: Center(child: Text("No chapters found"))),
          );
        }

        final chapters = snapshot.requireData;

        return SliverList(
          delegate: SliverChildBuilderDelegate(
            childCount: chapters.length,
            (context, index) {
              final data = chapters[index];

              late String title;
              final groups =
                  data.groups.isEmpty ? "No group" : data.groups.map((e) => e.name).join(", ");

              if (data.chapter.chapter != null && data.chapter.volume != null) {
                title = "Vol. ${data.chapter.volume} Ch. ${data.chapter.chapter} ";
              } else if (data.chapter.chapter != null) {
                title = "Chapter ${data.chapter.chapter}";
              } else {
                title = "Oneshot";
              }

              if (data.chapter.title != null) {
                title += "- ${data.chapter.title!}";
              }

              return ListTile(
                onTap: () {},
                title: Text(title, style: text.bodyMedium),
                leading: SizedBox.square(
                  dimension: 40,
                  child: Center(
                    child: flags.LanguageFlag(
                      height: 18,
                      language: data.chapter.translatedLanguage.language.flagLanguage,
                    ),
                  ),
                ),
                subtitle: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: DateFormat.yMMMd().format(data.chapter.createdAt)),
                      const TextSpan(text: "  -  "),
                      TextSpan(text: data.uploader.username),
                      const TextSpan(text: " • "),
                      TextSpan(text: groups),
                    ],
                    style: text.bodySmall?.withColorOpacity(0.75),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
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

  void showFilterSheet(List<ChapterData> chapters, MangaFilterData filterData) {
    final media = MediaQuery.of(context);
    final groupMap = {for (final e in chapters.map((e) => e.groups).expand((e) => e)) e.id: e};
    final dedupedGroupIds = groupMap.keys.toSet();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => ChapterFilterSheet(
        onApply: (newFilter) {
          filterSettings.mangaFilters.put(widget.id, newFilter);
          Navigator.pop(context);
        },
        padding: EdgeInsets.only(bottom: media.padding.bottom),
        data: ChapterFilterSheetData(
          mangaId: widget.id,
          filter: filterData,
          groups: dedupedGroupIds.map((e) => groupMap[e]!).toList(),
        ),
      ),
    );
  }

  Future<void> changeFollowStatus(bool follow) async {
    setState(() => isFollowed = follow);
  }

  Future<void> handleTrackerPress() async {
    setState(() => hasTrackers = !hasTrackers);
  }

  void onScroll() {
    final height = expandedAppBarHeight - kToolbarHeight;

    if (showAppBar.value && scrollController.offset < height) {
      showAppBar.value = false;
    } else if (!showAppBar.value && scrollController.offset > height) {
      showAppBar.value = true;
    }
  }
}
