import "dart:io";

import "package:flutter/material.dart" hide Locale;
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:riba/material_symbols.dart";
import "package:riba/repositories/local/author.dart";
import "package:riba/repositories/local/localization.dart";
import "package:riba/repositories/mangadex/mangadex.dart";
import "package:riba/repositories/runtime/manga.dart";
import "package:riba/utils/errors.dart";
import "package:riba/settings/theme.dart";
import "package:riba/utils/constants.dart";

class MangaView extends ConsumerStatefulWidget {
  const MangaView({super.key, required this.id});

  final String id;

  @override
  ConsumerState<MangaView> createState() => _MangaViewState();
}

class _MangaViewState extends ConsumerState<MangaView> {
  final scrollController = ScrollController();
  bool showAppBar = false;

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
              floating: true,
              title: Row(children: [
                const Card(child: SizedBox(width: 40, height: 40, child: Placeholder())),
                const SizedBox(width: 8),
                Text(
                  snapshot.data!.manga.titles.getPreferred([Locale.en, Locale.ja]),
                  style: text.titleSmall,
                ),
              ]),
            ),
            SliverToBoxAdapter(
              child: Column(children: [
                detailsHeader(snapshot.data!),
                const SizedBox(height: 1000),
              ]),
            ),
          ]);
        },
      ),
    );
  }

  Widget detailsHeader(MangaData mangaData) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final media = MediaQuery.of(context);

    final title = mangaData.manga.titles.getPreferred([Locale.en, Locale.ja]);
    final authorList = (mangaData.authors + mangaData.artists.whereNotIn(mangaData.authors))
        .map((e) => e.name)
        .join(", ");

    return Stack(
      children: [
        Container(
          width: double.infinity,
          constraints: const BoxConstraints(minHeight: 200, maxHeight: 450),
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

              return Image.file(snapshot.data!, fit: BoxFit.cover);
            },
          ),
        ),
        Container(
          width: double.infinity,
          padding: Edges.horizontalMedium.copyWith(
            top: media.padding.top + 200,
            bottom: Edges.large,
          ),
          constraints: const BoxConstraints(minHeight: 200, maxHeight: 400),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: theme.textTheme.titleLarge),
            Text(authorList, style: theme.textTheme.labelMedium?.withColorAlpha(0.5)),
            const SizedBox(height: 25),
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
          ]),
        ),
      ],
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
              icon: const Icon(MaterialSymbols.check),
              label: const Text("Reading"))
          : FilledButton.icon(
              onPressed: () => changeFollowStatus(true),
              icon: const Icon(MaterialSymbols.add),
              label: const Text("Add to Library")),
    );
  }

  Widget buildTrackerButton() {
    return OutlinedButton.icon(
      onPressed: handleTrackerPress,
      icon: hasTrackers ? const Icon(MaterialSymbols.sync) : const Icon(MaterialSymbols.add),
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
    if (showAppBar && scrollController.offset < 300) setState(() => showAppBar = false);
    if (!showAppBar && scrollController.offset > 300) setState(() => showAppBar = true);
  }
}
