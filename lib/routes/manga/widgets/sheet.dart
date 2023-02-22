import "dart:math";

import "package:fl_chart/fl_chart.dart";
import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:riba/repositories/local/statistics.dart";
import "package:riba/utils/constants.dart";
import "package:riba/utils/theme.dart";

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
          SizedBox(height: 250, child: buildChart(textTheme, totalRateCount, colorScheme)),
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

  BarChart buildChart(TextTheme textTheme, int totalRateCount, ColorScheme colorScheme) {
    return BarChart(
      BarChartData(
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
        maxY: rating.distribution.reduce(max).toDouble(),
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
