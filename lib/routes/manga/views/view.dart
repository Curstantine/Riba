import "dart:io";

import "package:flutter/material.dart" hide Locale;
import "package:riba/repositories/local/author.dart";
import "package:riba/repositories/local/localization.dart";
import "package:riba/repositories/local/manga.dart";
import "package:riba/repositories/mangadex/mangadex.dart";
import "package:riba/repositories/runtime/manga.dart";
import "package:riba/settings/theme.dart";
import "package:riba/utils/constants.dart";
import "package:riba/utils/errors.dart";

class MangaView extends StatefulWidget {
  const MangaView({super.key, required this.id});

  final String id;

  @override
  State<MangaView> createState() => _MangaViewState();
}

class _MangaViewState extends State<MangaView> {
  final expandedAppBarHeight = 350.0;
  final scrollController = ScrollController();
  final preferredLocales = [Locale.en, Locale.ja];

  bool showAppBar = false;
  bool expandedDescription = false;

  Future<MangaData>? mangaData;
  Future<File>? coverArt;

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
    mangaData = MangaDex.instance.manga.get(widget.id);
    coverArt = mangaData?.then((data) {
      return MangaDex.instance.covers.get(widget.id, data.cover!.fileName);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final media = MediaQuery.of(context);

    final colors = theme.colorScheme;
    final text = theme.textTheme;

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: FutureBuilder<MangaData>(
        future: mangaData,
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
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => setState(() => fetchMangaData()),
                  child: const Text("Retry"),
                ),
              ]),
            );
          }

          return CustomScrollView(controller: scrollController, slivers: [
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
            SliverToBoxAdapter(child: buildDescription(theme, snapshot.data!.manga)),
            SliverToBoxAdapter(child: buildContents(theme, snapshot.data!))
          ]);
        },
      ),
    );
  }

  Widget detailsHeader(MangaData mangaData) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final media = MediaQuery.of(context);

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
          child: FutureBuilder<File>(
            future: coverArt,
            builder: (context, snapshot) {
              Widget? child;

              if (snapshot.connectionState == ConnectionState.waiting) {
                child = const CircularProgressIndicator();
              }

              if (snapshot.hasError) {
                child = Text(snapshot.error.toString());
              }

              if (child != null) {
                return SizedBox(height: media.padding.top + 200, child: Center(child: child));
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
              Text(title, style: theme.textTheme.titleLarge),
              Text(authorList, style: theme.textTheme.labelMedium?.withColorAlpha(0.5)),
              const SizedBox(height: Edges.large),
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 40),
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

  Widget buildDescription(ThemeData theme, Manga manga) {
    return Padding(
      padding: Edges.horizontalMedium,
      child: Column(
        children: [
          AnimatedSize(
            duration: Durations.slow,
            alignment: Alignment.topCenter,
            child: Container(
              height: expandedDescription ? null : 100,
              clipBehavior: Clip.hardEdge,
              decoration: const BoxDecoration(),
              foregroundDecoration: BoxDecoration(
                color: theme.colorScheme.background,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [expandedDescription ? 1 : 0, 1],
                  colors: [
                    theme.colorScheme.background.withOpacity(0),
                    theme.colorScheme.background,
                  ],
                ),
              ),
              // TODO: Add markdown support.
              child: Text(manga.description.getPreferred(preferredLocales)),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              isSelected: expandedDescription,
              icon: const Icon(Icons.expand_more_rounded),
              selectedIcon: const Icon(Icons.expand_less_rounded),
              tooltip: expandedDescription ? "Collapse" : "Expand",
              onPressed: () => setState(() => expandedDescription = !expandedDescription),
            ),
          ),
        ],
      ),
    );
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
