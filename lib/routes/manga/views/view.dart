import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:riba/utils/theme.dart';
import 'package:riba/utils/constants.dart';

class MangaView extends StatefulWidget {
  const MangaView({super.key});

  @override
  State<MangaView> createState() => _MangaViewState();
}

class _MangaViewState extends State<MangaView> {
  bool isStatusBarDarkened = true;

  final scrollController = ScrollController();
  final image = const NetworkImage(
    "https://cdn.discordapp.com/attachments/403905762692431872/1066705519592607824/9F2FDACC-D07C-418C-A392-BAF23458CBC9.jpg",
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      log("Running post frame hook.", name: "MangaView");
      ThemeManager.instance.setSystemOverlayStyles(
        statusBarColor: Theme.of(context).colorScheme.background.withOpacity(0.75),
      );
    });

    scrollController.addListener(() {
      final statusBarColor = Theme.of(context).colorScheme.background.withOpacity(0.75);

      if (!isStatusBarDarkened && scrollController.offset < 150) {
        isStatusBarDarkened = true;
        ThemeManager.instance.setSystemOverlayStyles(statusBarColor: statusBarColor);
      }

      if (isStatusBarDarkened && scrollController.offset > 150) {
        isStatusBarDarkened = false;
        ThemeManager.instance.setSystemOverlayStyles();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final media = MediaQuery.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          children: [
            detailsHeader(theme, media),
            const SizedBox(height: 1000),
          ],
        ),
      ),
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
                Colors.transparent,
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
                        height: 200,
                        child: Center(child: CircularProgressIndicator(value: progress))),
              );
            },
          ),
        ),
        Container(
          width: double.infinity,
          padding:
              Edges.horizontalMedium.copyWith(top: media.padding.top + 150, bottom: Edges.large),
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
}
