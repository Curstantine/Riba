import "dart:io";
import "dart:math";

import "package:fl_chart/fl_chart.dart";
import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:isar/isar.dart";
import "package:riba/repositories/local/cover_art.dart";
import "package:riba/repositories/local/manga.dart";
import "package:riba/repositories/local/statistics.dart";
import "package:riba/repositories/mangadex/mangadex.dart";
import "package:riba/repositories/runtime/cover_art.dart";
import "package:riba/repositories/runtime/manga.dart";
import "package:riba/utils/constants.dart";
import "package:riba/utils/errors.dart";
import "package:riba/utils/theme.dart";
import "package:riba/widgets/material/card.dart";
import "package:riba/widgets/material/chip.dart";

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

  late String? selectedCoverId = widget.mangaData.manga.usedCover;

  Manga get manga => widget.mangaData.manga;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  void initialize() async {
    final localCovers =
        await MangaDex.instance.database.covers.filter().mangaEqualTo(manga.id).findAll();

    if (localCovers.isNotEmpty) {
      coverDataFuture = MangaDex.instance.covers
          .getMany(localCovers.map((e) => e.id).toList())
          .then((e) => e.values.toList());
    } else {
      coverDataFuture = MangaDex.instance.covers.getForManga(manga.id);
    }

    setState(() => {});
  }

  void reloadData() => setState(() {
        coverDataFuture = MangaDex.instance.covers.getForManga(manga.id);
      });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = theme.textTheme;
    final colors = theme.colorScheme;

    return FutureBuilder<List<CoverArtData>>(
      future: coverDataFuture,
      builder: (context, snapshot) {
        Widget? child;

        if (snapshot.connectionState != ConnectionState.done) {
          child = const Center(child: CircularProgressIndicator());
        }

        if ((snapshot.hasError || !snapshot.hasData) &&
            snapshot.connectionState == ConnectionState.done) {
          final error = handleError(snapshot.error ?? "Data was null without errors.");

          child = Center(
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(error.title, style: theme.textTheme.titleLarge),
              Text(error.description, style: theme.textTheme.bodyMedium),
              const SizedBox(height: Edges.small),
              OutlinedButton(
                onPressed: () => setState(() => initialize()),
                child: const Text("Retry"),
              ),
            ]),
          );
        }

        if (snapshot.hasData && snapshot.data!.isEmpty) {
          child = Center(
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Icon(Icons.image_search_rounded, size: 36),
              const SizedBox(height: Edges.small),
              Text("Couldn't find any covers for this title!", style: theme.textTheme.titleMedium),
            ]),
          );
        }

        if (child != null) {
          return SizedBox(height: 300, child: child);
        }

        final selectedCover = snapshot.data!.firstWhere((e) => e.cover.id == selectedCoverId);

        return ListView(
          padding: Edges.allLarge,
          shrinkWrap: true,
          children: [
            Text("Covers", style: text.titleLarge),
            const SizedBox(height: Edges.small),
            OutlinedCard(
              child: AnimatedSize(
                duration: Durations.normal,
                child: buildSelectedPreview(text, colors, selectedCover),
              ),
            ),
            const SizedBox(height: Edges.small),
            Text("Select a cover", style: text.labelLarge),
            const SizedBox(height: Edges.small),
            OutlinedButton(onPressed: reloadData, child: const Text("Reload")),
          ],
        );
      },
    );
  }

  Widget buildSelectedPreview(TextTheme text, ColorScheme colors, CoverArtData coverData) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        FutureBuilder<File?>(
          future: MangaDex.instance.covers.getImage(manga.id, coverData.cover),
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
                Icon(Icons.image_not_supported_rounded, size: 48, color: colors.onSurfaceVariant),
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
              child: Image.file(
                snapshot.data!,
                fit: BoxFit.fitWidth,
                width: double.infinity,
                filterQuality: FilterQuality.high,
              ),
            );
          },
        ),
        Padding(
          padding: Edges.allSmall.copyWith(bottom: Edges.medium),
          child: Wrap(
            children: [
              if (coverData.cover.volume != null)
                TinyChip(label: "Vol ${coverData.cover.volume}", onPressed: () => {}),
              if (coverData.cover.locale != null)
                TinyChip(label: coverData.cover.locale!.language.human, onPressed: () => {}),
            ],
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
