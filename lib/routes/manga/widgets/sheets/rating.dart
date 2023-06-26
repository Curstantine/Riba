// ignore_for_file: public_member_api_docs, sort_constructors_first
import "dart:math";

import "package:fl_chart/fl_chart.dart";
import "package:flutter/material.dart";
import "package:riba/repositories/local/models/statistics.dart";
import "package:riba/utils/constants.dart";
import "package:riba/utils/theme.dart";

class RatingDetailsSheet extends StatelessWidget {
	const RatingDetailsSheet({super.key, required this.rating, this.padding = Edges.allNone});

	final RatingStatistics rating;
	final EdgeInsets padding;

	@override
	Widget build(context) {
		final theme = Theme.of(context);
		final text = theme.textTheme;
		final colors = theme.colorScheme;

		final totalRateCount = rating.distribution.reduce((x, y) => x + y);

		return Padding(
			padding: Edges.allLarge.copyWith(top: Edges.extraLarge).add(padding),
			child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
				Text("Ratings", style: text.titleMedium),
				const SizedBox(height: Edges.small),
				SizedBox(height: 250, child: _Chart(rating: rating, totalRateCount: totalRateCount)),
				const SizedBox(height: Edges.large),
				SizedBox(height: 50, child: GridView.count(crossAxisCount: 3, addRepaintBoundaries: false, children: [
					buildGridItem(text, colors, "Average", rating.average.toStringAsFixed(2)),
					buildGridItem(text, colors, "Bayesian", rating.bayesian.toStringAsFixed(2)),
					buildGridItem(text, colors, "Total Votes", totalRateCount.toString()),
				])),
			]),
		);
	}


	Widget buildGridItem(TextTheme textTheme, ColorScheme colors, String title, String value) {
		return Column(children: [
			Text(title, style: textTheme.labelLarge),
			Text(value, style: textTheme.labelSmall?.copyWith(color: colors.onSurfaceVariant)),
		]);
	}
}

class _Chart extends StatelessWidget {
	const _Chart({required this.rating, required this.totalRateCount});

	final RatingStatistics rating;
	final int totalRateCount;

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		final colors = theme.colorScheme;
		final text = theme.textTheme;

		final maxValue = rating.distribution.reduce(max).toDouble();

		if (maxValue == 0) {
			return Center(
				child: Text("No data available yet!", style: text.bodyMedium?.copyWith(color: colors.onSurfaceVariant)),
			);
		}

		return BarChart(BarChartData(
			maxY: maxValue,
			gridData: const FlGridData(show: false),
			borderData: FlBorderData(show: false),
			barTouchData: BarTouchData(
				enabled: true,
				touchTooltipData: BarTouchTooltipData(
					tooltipBgColor: colors.primary,
					tooltipRoundedRadius: Corners.small.x,
					tooltipPadding: Edges.allSmall,
					getTooltipItem: (group, groupIndex, rod, rodIndex) => BarTooltipItem(
						rating.distribution[groupIndex].toString(),
						text.labelSmall!.copyWith(color: colors.onPrimary),
					),
				),
			),
			titlesData: FlTitlesData(
				show: true,
				leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
				rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
				topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
				bottomTitles: AxisTitles(
					sideTitles: SideTitles(
						showTitles: true,
						reservedSize: 50,
						getTitlesWidget: (value, _) => buildBottomTitle(value, text),
					),
				),
			),
			barGroups: rating.distribution
				.asMap()
				.entries
				.map((dist) => BarChartGroupData(
					x: dist.key + 1,
					barRods: [BarChartRodData(toY: dist.value.toDouble(), color: colors.primary)]),
				)
				.toList()	
		));
	}

	SideTitleWidget buildBottomTitle(double value, TextTheme textTheme) {
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
}