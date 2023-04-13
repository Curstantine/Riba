// ignore_for_file: public_member_api_docs, sort_constructors_first
import "dart:math";

import "package:fl_chart/fl_chart.dart";
import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:logging/logging.dart";
import "package:riba/repositories/local/models/statistics.dart";
import "package:riba/repositories/mangadex/mangadex.dart";
import "package:riba/repositories/mangadex/utils/service.dart";
import "package:riba/settings/filter.dart";
import "package:riba/utils/constants.dart";
import "package:riba/utils/errors.dart";
import "package:riba/utils/theme.dart";

class RatingDetailsSheet extends StatelessWidget {
  const RatingDetailsSheet({super.key, required this.rating, this.padding = Edges.allNone});

  final RatingStatistics rating;
  final EdgeInsets padding;

  @override
  Widget build(context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    final totalRateCount = rating.distribution.reduce((x, y) => x + y);

    return Padding(
      padding: Edges.allLarge.copyWith(top: Edges.extraLarge).add(padding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Ratings", style: textTheme.titleMedium),
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

class ChapterFilterSheet extends StatefulWidget {
  const ChapterFilterSheet({
    super.key,
    required this.padding,
    required this.data,
    required this.onApply,
  });

  final EdgeInsets padding;
  final ChapterFilterSheetData data;
  final void Function(MangaFilterSettings) onApply;

  @override
  State<ChapterFilterSheet> createState() => _ChapterFilterSheetState();
}

class _ChapterFilterSheetState extends State<ChapterFilterSheet> {
  final logger = Logger("ChapterFilterSheet");

  late final Map<String, ValueNotifier<bool>> _groupValues = {
    for (final id in widget.data.groupIds)
      id: ValueNotifier(!widget.data.filterSettings.excludedGroupIds.contains(id))
  };

  late final groupFuture = MangaDex.instance.group
      .getManyAsSingle(overrides: MangaDexGenericQueryFilter(ids: widget.data.groupIds));

  @override
  Widget build(context) {
    final theme = Theme.of(context);
    final text = theme.textTheme;
    final colors = theme.colorScheme;

    return ListView(
      padding: Edges.horizontalLarge.copyWith(top: Edges.extraLarge).add(widget.padding),
      shrinkWrap: true,
      children: [
        ...buildChapterGroups(text, colors),
        const SizedBox(height: Edges.large),
        Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          FilledButton.tonal(onPressed: apply, child: const Text("Apply")),
        ])
      ],
    );
  }

  List<Widget> buildChapterGroups(TextTheme text, ColorScheme colors) {
    return [
      Text("Chapter Groups", style: text.titleMedium),
      Text("Select which groups to include in the chapter list",
          style: text.bodySmall?.copyWith(color: colors.onSurfaceVariant)),
      const SizedBox(height: Edges.small),
      FutureBuilder(
        future: groupFuture,
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

          final groups = snapshot.requireData;

          return Column(mainAxisSize: MainAxisSize.min, children: [
            for (final group in groups.values)
              ValueListenableBuilder(
                valueListenable: _groupValues[group.id]!,
                builder: (context, value, _) {
                  return CheckboxListTile(
                    dense: true,
                    value: value,
                    onChanged: (value) => _groupValues[group.id]!.value = value!,
                    title: Text(group.name, style: text.bodyMedium),
                  );
                },
              ),
          ]);
        },
      ),
    ];
  }

  void apply() {
    logger.info("Applying manga filter changes. (${widget.data.mangaId})");

    final newFilter = widget.data.filterSettings.copyWith(
      excludedGroupIds: _groupValues.entries
          .where((entry) => !entry.value.value)
          .map((entry) => entry.key)
          .toList(),
    );

    widget.onApply.call(newFilter);
  }
}

class ChapterFilterSheetData {
  final String mangaId;

  /// Group IDs belonging to the chapter list.
  /// Regardless of whether they are excluded or not.
  final List<String> groupIds;
  final MangaFilterSettings filterSettings;

  const ChapterFilterSheetData({
    required this.filterSettings,
    required this.groupIds,
    required this.mangaId,
  });
}
