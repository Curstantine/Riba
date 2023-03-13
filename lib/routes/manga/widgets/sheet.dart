import "dart:io";
import "dart:math";

import "package:fl_chart/fl_chart.dart";
import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:isar/isar.dart";
import "package:logging/logging.dart";
import "package:riba/repositories/local/cover_art.dart";
import "package:riba/repositories/local/manga.dart";
import "package:riba/repositories/local/statistics.dart";
import "package:riba/repositories/mangadex/mangadex.dart";
import "package:riba/repositories/runtime/cover_art.dart";
import "package:riba/repositories/runtime/manga.dart";
import "package:riba/settings/cache.dart";
import "package:riba/utils/constants.dart";
import "package:riba/utils/errors.dart";
import "package:riba/utils/lazy.dart";
import "package:riba/utils/theme.dart";
import "package:riba/widgets/material/card.dart";
import "package:riba/widgets/material/chip.dart";

class RatingDetailsSheet extends StatelessWidget {
  const RatingDetailsSheet({super.key, required this.rating, this.padding = Edges.allNone});

  final RatingStatistics rating;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    final totalRateCount = rating.distribution.reduce((x, y) => x + y);

    return Padding(
      padding: Edges.allLarge.add(padding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Ratings", style: textTheme.titleLarge),
          const SizedBox(height: Edges.small),
          SizedBox(height: 250, child: buildChart(textTheme, colorScheme, totalRateCount)),
          const SizedBox(height: Edges.large),
          SizedBox(
            height: 50,
            child: GridView.count(crossAxisCount: 3, addRepaintBoundaries: false, children: [
              buildGridItem("Average", rating.average.toStringAsFixed(2), textTheme),
              buildGridItem("Bayesian", rating.bayesian.toStringAsFixed(2), textTheme),
              buildGridItem("Total Votes", totalRateCount.toString(), textTheme),
            ]),
          ),
        ],
      ),
    );
  }

  Widget buildChart(TextTheme textTheme, ColorScheme colorScheme, int totalRateCount) {
    final maxValue = rating.distribution.reduce(max).toDouble();

    if (maxValue == 0) {
      return Center(
        child: Text("No data available yet!", style: textTheme.bodyMedium?.withColorOpacity(0.5)),
      );
    }

    return BarChart(
      BarChartData(
        maxY: maxValue,
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: colorScheme.primary,
            tooltipRoundedRadius: Corners.small.x,
            tooltipPadding: Edges.allSmall,
            getTooltipItem: (group, groupIndex, rod, rodIndex) => BarTooltipItem(
              rating.distribution[groupIndex].toString(),
              GoogleFonts.robotoFlex(color: colorScheme.onPrimary, fontSize: 12),
            ),
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 50,
              getTitlesWidget: (value, meta) => buildBottomTitle(value, textTheme, totalRateCount),
            ),
          ),
        ),
        barGroups: [
          for (final dist in rating.distribution.asMap().entries) ...[
            BarChartGroupData(
                x: dist.key + 1,
                barRods: [BarChartRodData(toY: dist.value.toDouble(), color: colorScheme.primary)]),
          ],
        ],
      ),
    );
  }

  SideTitleWidget buildBottomTitle(double value, TextTheme textTheme, int totalRateCount) {
    final muted = textTheme.labelSmall?.copyWith(fontSize: 9).withColorOpacity(0.5);
    final distribution = rating.distribution[value.toInt() - 1];
    final percentage = distribution / totalRateCount * 100;

    return SideTitleWidget(
      axisSide: AxisSide.bottom,
      child: Column(children: [
        Text(value.toStringAsFixed(0),
            style: textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold)),
        Text("${percentage.toStringAsFixed(0)}%", style: muted),
      ]),
    );
  }

  Widget buildGridItem(String title, String value, TextTheme textTheme) {
    return Column(children: [
      Text(title, style: textTheme.labelLarge),
      Text(value, style: textTheme.labelSmall?.withColorOpacity(0.75)),
    ]);
  }
}

class CoverSheet extends StatefulWidget {
  const CoverSheet({super.key, required this.mangaData, this.padding = Edges.allNone});

  final MangaData mangaData;
  final EdgeInsets padding;

  @override
  State<CoverSheet> createState() => _CoverSheetState();
}

class _CoverSheetState extends State<CoverSheet> {
  final logger = Logger("MangaCoverSheet");
  final selectedCoverId = ValueNotifier<String?>(null);

  Future<List<CoverArtData>>? coverDataFuture;
  Manga get manga => widget.mangaData.manga;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  void initialize() async {
    selectedCoverId.value = manga.usedCover;

    try {
      final covers = await MangaDex.instance.covers.getForManga(manga.id);
      coverDataFuture = Future.value(covers);
    } catch (e) {
      final localCovers =
          await MangaDex.instance.database.covers.filter().mangaEqualTo(manga.id).findAll();

      coverDataFuture = MangaDex.instance.covers
          .getMany(localCovers.map((e) => e.id).toList())
          .then((e) => e.values.toList());
    }

    setState(() => {});
  }

  void reloadData() => setState(() {
        coverDataFuture = MangaDex.instance.covers.getForManga(manga.id);
      });

  void setUsedCover() async {
    final id = selectedCoverId.value;

    try {
      await MangaDex.instance.database.writeTxn(() async {
        await MangaDex.instance.database.manga.put(manga..usedCover = id);
      });

      if (mounted) Navigator.pop(context);
    } catch (e) {
      final message = "Failed to set cover for manga ${manga.id}";
      logger.severe(message, e);
      if (mounted) showLazyBar(context, message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = theme.textTheme;
    final colors = theme.colorScheme;

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(padding: widget.padding),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Covers"),
          actions: [
            IconButton(icon: const Icon(Icons.refresh), onPressed: reloadData),
            ValueListenableBuilder<String?>(
              valueListenable: selectedCoverId,
              builder: (context, selectedId, child) => IconButton(
                icon: const Icon(Icons.check_rounded),
                onPressed: selectedId != manga.usedCover ? setUsedCover : null,
              ),
            ),
          ],
        ),
        body: FutureBuilder<List<CoverArtData>>(
          future: coverDataFuture,
          builder: (context, snapshot) {
            Widget? child;

            if (snapshot.connectionState != ConnectionState.done) {
              child = const Center(child: CircularProgressIndicator());
            }

            if ((snapshot.hasError || !snapshot.hasData) &&
                snapshot.connectionState == ConnectionState.done) {
              final error = handleError(snapshot.error ?? "Data was null without errors.");

              child = Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(error.title, style: theme.textTheme.titleLarge),
                Text(error.description, style: theme.textTheme.bodyMedium),
                const SizedBox(height: Edges.small),
                OutlinedButton(
                  onPressed: () => setState(() => initialize()),
                  child: const Text("Retry"),
                ),
              ]);
            }

            if (snapshot.hasData && snapshot.data!.isEmpty) {
              child = Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Icon(Icons.image_search_rounded, size: 36),
                const SizedBox(height: Edges.small),
                Text("Couldn't find any covers for this title!",
                    style: theme.textTheme.titleMedium),
              ]);
            }

            if (child != null) {
              return Center(child: child);
            }

            return ListView(
              shrinkWrap: true,
              padding: Edges.allLarge.add(EdgeInsets.only(bottom: widget.padding.bottom)),
              children: [
                OutlinedCard(
                  child: AnimatedSize(
                    duration: Durations.normal,
                    curve: Curves.easeInOut,
                    child: buildBigPicture(text, colors, snapshot.requireData),
                  ),
                ),
                const SizedBox(height: Edges.medium),
                Text("Select a cover", style: text.titleMedium),
                const SizedBox(height: Edges.small),
                if (snapshot.data!.length > 1)
                  SizedBox(
                    height: 175,
                    child: ListView.separated(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data!.length,
                      separatorBuilder: (context, _) => const SizedBox(width: Edges.medium),
                      itemBuilder: (context, i) {
                        return buildPreview(text, colors, snapshot.requireData[i]);
                      },
                    ),
                  )
                else
                  SizedBox(
                    height: 200,
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Icon(Icons.image_search_rounded, size: 32, color: colors.onSurfaceVariant),
                      const SizedBox(height: Edges.small),
                      Text("No other covers found!",
                          style: text.bodyMedium?.copyWith(color: colors.onSurfaceVariant)),
                    ]),
                  ),
                const SizedBox(height: Edges.medium),
                Row(
                  children: [
                    Icon(Icons.info_outline_rounded, size: 24, color: colors.primary),
                    const SizedBox(width: Edges.large),
                    Expanded(
                      child: Text(
                        "Selecting a cover and applying it will update the cover used for this title throughout the app.\n"
                        "This update will be only be reflected after either the app or the title is reloaded.",
                        softWrap: true,
                        style: text.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
                      ),
                    ),
                  ],
                )
              ],
            );
          },
        ),
      ),
    );
  }

  Widget buildBigPicture(TextTheme text, ColorScheme colors, List<CoverArtData> covers) {
    return ValueListenableBuilder(
      valueListenable: selectedCoverId,
      builder: (context, selectedId, _) {
        final selectedCover = covers.firstWhere((e) => e.cover.id == selectedId).cover;

        return Stack(
          alignment: Alignment.bottomRight,
          children: [
            FutureBuilder<File?>(
              future: MangaDex.instance.covers
                  .getImage(manga.id, selectedCover, size: CacheSettings.instance.fullSize),
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
                  children = [
                    Icon(Icons.image_not_supported_rounded,
                        size: 48, color: colors.onSurfaceVariant),
                    const SizedBox(height: Edges.small),
                    Text("No cover available!", style: text.bodyMedium),
                  ];
                }

                if (children != null) {
                  return SizedBox(
                    height: 300,
                    width: double.infinity,
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: children),
                  );
                }

                return InkWell(
                  onTap: () => showDialog(
                    context: context,
                    builder: (context) => buildZoomablePreview(context, snapshot.data!),
                  ),
                  child: Image.file(snapshot.data!, fit: BoxFit.fitWidth, width: double.infinity),
                );
              },
            ),
            Padding(
              padding: Edges.horizontalSmall.copyWithSelf(Edges.verticalMedium),
              child: Wrap(
                spacing: Edges.extraSmall,
                children: [
                  if (selectedCover.volume != null)
                    TinyChip(label: "Vol ${selectedCover.volume}", onPressed: () => {}),
                  if (selectedCover.locale != null)
                    TinyChip(label: selectedCover.locale!.language.human, onPressed: () => {}),
                ],
              ),
            )
          ],
        );
      },
    );
  }

  Widget buildPreview(TextTheme text, ColorScheme colors, CoverArtData coverData) {
    return SizedBox(
      width: 100,
      height: 175,
      child: FutureBuilder<File>(
        future: MangaDex.instance.covers
            .getImage(manga.id, coverData.cover, size: CacheSettings.instance.previewSize),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            final error = handleError(snapshot.error!);
            return Center(
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(Icons.image_not_supported_rounded, size: 32, color: colors.error),
                const SizedBox(height: Edges.small),
                Text(error.description, style: text.bodySmall)
              ]),
            );
          }

          return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            ValueListenableBuilder(
              valueListenable: selectedCoverId,
              builder: (context, selectedId, child) {
                final isMain = coverData.cover.id == manga.usedCover;
                final isSelected = selectedId == coverData.cover.id;

                return Card(
                  margin: Edges.allNone,
                  clipBehavior: Clip.antiAlias,
                  elevation: isSelected ? 4 : 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: Corners.allMedium,
                    side: isMain ? BorderSide(width: 2, color: colors.primary) : BorderSide.none,
                  ),
                  child: child!,
                );
              },
              child: InkWell(
                onTap: () => selectedCoverId.value = coverData.cover.id,
                child: Image.file(
                  snapshot.data!,
                  fit: BoxFit.fitWidth,
                  width: double.infinity,
                  filterQuality: FilterQuality.high,
                ),
              ),
            ),
            if (coverData.cover.volume != null) ...[
              const SizedBox(height: Edges.extraSmall),
              Text("Vol ${coverData.cover.volume}", style: text.labelSmall),
            ]
          ]);
        },
      ),
    );
  }

  InteractiveViewer buildZoomablePreview(BuildContext context, File image) {
    return InteractiveViewer(
      maxScale: 2,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => Navigator.pop(context),
        child: Container(
          alignment: Alignment.center,
          margin: Edges.horizontalMedium,
          child: Image.file(image, fit: BoxFit.fitWidth, filterQuality: FilterQuality.high),
        ),
      ),
    );
  }
}
