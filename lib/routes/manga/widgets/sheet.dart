import "dart:io";
import "dart:math";

import "package:fl_chart/fl_chart.dart";
import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:isar/isar.dart";
import "package:riba/repositories/local/cover_art.dart";
import "package:riba/repositories/local/statistics.dart";
import "package:riba/repositories/mangadex/mangadex.dart";
import "package:riba/repositories/runtime/cover_art.dart";
import "package:riba/repositories/runtime/manga.dart";
import "package:riba/utils/constants.dart";
import "package:riba/utils/errors.dart";
import "package:riba/utils/theme.dart";
import "package:riba/widgets/material/card.dart";

class RatingDetailsSheet extends StatelessWidget {
  const RatingDetailsSheet({super.key, required this.rating});

  final RatingStatistics rating;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    final totalRateCount = rating.distribution.reduce((x, y) => x + y);

    return Padding(
      padding: Edges.allLarge,
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
  const CoverSheet({super.key, required this.mangaData});

  final MangaData mangaData;

  @override
  State<CoverSheet> createState() => _CoverSheetState();
}

class _CoverSheetState extends State<CoverSheet> {
  Future<List<CoverArtData>>? coverDataFuture;
  Future<File?>? coverFileFuture;

  late String? selectedCoverId = widget.mangaData.manga.usedCover;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  void initialize() {
    final localCovers = MangaDex.instance.database.covers
        .filter()
        .mangaEqualTo(widget.mangaData.manga.id)
        .findAllSync();

    if (localCovers.length >= 2) {
      coverDataFuture = MangaDex.instance.covers
          .getMany(localCovers.map((e) => e.id).toList())
          .then((e) => e.values.toList());
    } else {
      coverDataFuture = MangaDex.instance.covers.getForManga(widget.mangaData.manga.id);
    }

    if (selectedCoverId != null && coverDataFuture != null) {
      coverDataFuture?.then((value) {
        final selected = value.firstWhere((e) => e.cover.id == selectedCoverId);
        coverFileFuture =
            MangaDex.instance.covers.getImage(widget.mangaData.manga.id, selected.cover);
        // coverFileFuture = Future.value(null);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = theme.textTheme;
    final colors = theme.colorScheme;

    return FutureBuilder<List<CoverArtData>>(
      future: coverDataFuture,
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
                onPressed: () => setState(() => initialize()),
                child: const Text("Retry"),
              ),
            ]),
          );
        }

        return ListView(
          padding: Edges.allLarge,
          children: [
            Text("Covers", style: text.titleLarge),
            const SizedBox(height: Edges.large),
            Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 150, maxHeight: 350),
                child: OutlinedCard(
                  child: AnimatedSize(
                    duration: Durations.slow,
                    child: buildSelectedPreview(text, colors),
                  ),
                ),
              ),
            ),
            const Text("Select a cover"),
          ],
        );
      },
    );
  }

  Widget buildSelectedPreview(TextTheme text, ColorScheme colors) {
    return Stack(
      children: [
        FutureBuilder<File?>(
          future: coverFileFuture,
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
                Icon(Icons.broken_image_outlined, size: 56, color: colors.onSurfaceVariant),
                const SizedBox(height: Edges.small),
                Text("No cover available!", style: text.bodyMedium),
              ];
            }

            if (children != null) {
              return SizedBox(
                width: 250,
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: children),
              );
            }

            return InkWell(
              onTap: () => showDialog(
                context: context,
                builder: (context) => buildZoomablePreview(context, snapshot.data!),
              ),
              child: Image.file(
                snapshot.data!,
                fit: BoxFit.cover,
                filterQuality: FilterQuality.high,
              ),
            );
          },
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: Edges.allSmall,
            child: Wrap(
              spacing: Edges.small,
              children: [
                ActionChip(label: const Text("Vol 2"), onPressed: () {}),
              ],
            ),
          ),
        )
      ],
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
