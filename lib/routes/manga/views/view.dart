import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riba/repositories/mangadex/mangadex.dart';
import 'package:riba/utils/theme.dart';
import 'package:riba/utils/constants.dart';

class MangaView extends ConsumerStatefulWidget {
  const MangaView({super.key});

  @override
  ConsumerState<MangaView> createState() => _MangaViewState();
}

class _MangaViewState extends ConsumerState<MangaView> {
  final scrollController = ScrollController();
  final image = const NetworkImage(
    "https://cdn.discordapp.com/attachments/403905762692431872/1066705519592607824/9F2FDACC-D07C-418C-A392-BAF23458CBC9.jpg",
  );

  bool isStatusBarDarkened = true;

  @override
  void initState() {
    super.initState();
    ThemeManager.instance.preventSystemOverlaySync = true;
    ThemeManager.instance.addListener(onThemeChange);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      log("Running post frame hook.", name: "MangaView");
      _darkenStatusBar();
    });

    scrollController.addListener(_changeSystemOverlayStyles);
  }

  @override
  void dispose() {
    ThemeManager.instance.preventSystemOverlaySync = false;
    ThemeManager.instance.setSystemOverlayStyles();
    ThemeManager.instance.removeListener(onThemeChange);

    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mangadex = ref.read(mangaDexPod);
    final theme = Theme.of(context);
    final media = MediaQuery.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: FutureBuilder<dynamic>(
          future: mangadex.manga.getManga("f9c33607-9180-4ba6-b85c-e4b5faee7192"),
          builder: (context, snapshot) {
            log(
              "FutureBuilder: ${snapshot.connectionState}\n" "\tdata: ${snapshot.data}",
              name: "MangaView",
            );

            return SingleChildScrollView(
              controller: scrollController,
              child: Column(
                children: [
                  detailsHeader(theme, media),
                  const SizedBox(height: 1000),
                ],
              ),
            );
          }),
    );
  }

  Widget detailsHeader(ThemeData theme, MediaQueryData media) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          constraints: const BoxConstraints(minHeight: 200, maxHeight: 450),
          foregroundDecoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: const [0, 0.5, 0.75, 1],
              colors: [
                theme.colorScheme.background.withOpacity(0),
                theme.colorScheme.background.withOpacity(0.85),
                theme.colorScheme.background.withOpacity(0.95),
                theme.colorScheme.background,
              ],
            ),
          ),
          child: Image(
            fit: BoxFit.fitWidth,
            image: image,
            errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
            loadingBuilder: (context, child, loadingProgress) {
              final progress = loadingProgress?.expectedTotalBytes != null
                  ? loadingProgress!.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                  : null;

              return AnimatedSwitcher(
                duration: Durations.normal,
                child: progress == null
                    ? SizedBox.expand(child: child)
                    : SizedBox(
                        height: media.padding.top + 200,
                        child: Center(child: CircularProgressIndicator(value: progress))),
              );
            },
          ),
        ),
        Container(
          width: double.infinity,
          padding:
              Edges.horizontalMedium.copyWith(top: media.padding.top + 200, bottom: Edges.large),
          constraints: const BoxConstraints(minHeight: 200, maxHeight: 400),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("Title that's long enough to make Kizuna happy",
                style: theme.textTheme.titleLarge),
            Text("Kizuna AI", style: theme.textTheme.labelMedium?.withColorAlpha(0.5))
          ]),
        ),
      ],
    );
  }

  void onThemeChange() {
    log("Platform brightness changed.", name: "MangaView");
    _changeSystemOverlayStyles(force: true);
  }

  void _changeSystemOverlayStyles({bool force = false}) {
    log(
      "Changing system overlay style.\n"
      "\tforce: $force\n"
      "\tisStatusBarDarkened: $isStatusBarDarkened\n"
      "\tBrightness: ${WidgetsBinding.instance.window.platformBrightness}\n"
      "\tSchemeBrightness: ${ThemeManager.instance.scheme.brightness}",
      name: "MangaView",
    );

    if ((force || !isStatusBarDarkened) && scrollController.offset < 300) _darkenStatusBar();
    if ((force || isStatusBarDarkened) && scrollController.offset > 300) _lightenStatusBar();
  }

  void _darkenStatusBar() {
    var statusBarColor = ThemeManager.instance.scheme.background.withOpacity(0.75);

    isStatusBarDarkened = true;
    ThemeManager.instance.setSystemOverlayStyles(statusBarColor: statusBarColor);
  }

  void _lightenStatusBar() {
    isStatusBarDarkened = false;
    ThemeManager.instance.setSystemOverlayStyles();
  }
}
