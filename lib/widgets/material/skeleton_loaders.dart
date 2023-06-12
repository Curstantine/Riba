import "package:flutter/material.dart";
import "package:riba/utils/constants.dart";

class TextSkeleton extends StatelessWidget {
	const TextSkeleton({
		super.key,
		this.color,
		this.width = 150,
		required this.style,
	});

	final double width;
	final TextStyle style;
	final Color? color;

	@override
	Widget build(context) {
		final theme = Theme.of(context);

		return Container(
			width: width,
			height: style.fontSize,
			constraints: BoxConstraints(maxWidth: width),
			decoration: BoxDecoration(
				color: color ?? theme.colorScheme.surfaceVariant,
				borderRadius: Corners.allFull,
			),
		);
	}
}

class ListTileSkeleton extends StatelessWidget {
	const ListTileSkeleton({
		super.key,
		this.useLeadingIcon = false,
		this.useTrailingIcon = false,
		this.useTitle = true,
		this.color,
	});
	
	final bool useLeadingIcon;
	final bool useTrailingIcon;
	final bool useTitle;
	final Color? color;

	@override
	Widget build(context) {
		final theme = Theme.of(context);
		final text = theme.textTheme;
		final colors = theme.colorScheme;

		return ListTile(
			leading: !useLeadingIcon ? null : buildCircle(colors),
			trailing: !useTrailingIcon ? null : buildCircle(colors),
			title: !useTitle ? null : TextSkeleton(style: text.bodyLarge!, width: double.infinity, color: color),
		);
	}

	Widget buildCircle(ColorScheme colors, [double size = 24]) => Container(
		height: size,
		width: size,
		decoration: BoxDecoration(
			color: color ?? colors.surfaceVariant,
			shape: BoxShape.circle,
		),
	);
}

class MangaCardSkeleton extends StatelessWidget {
	const MangaCardSkeleton({super.key, this.color});

	final Color? color;

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		final colors = theme.colorScheme;
		final text = theme.textTheme;

		final color = this.color ?? colors.surfaceVariant;

		return SizedBox(
			width: 150,
			height: 250,
			child: Column(
				mainAxisAlignment: MainAxisAlignment.end,
				crossAxisAlignment: CrossAxisAlignment.start,
				children: [
					Expanded(child: Container(
						width: 150,
						margin: Edges.verticalSmall,
						decoration: BoxDecoration(
							color: color.withOpacity(0.75),
							borderRadius: Corners.allMedium,
						),
						// child: const Placeholder(),
					)),
					TextSkeleton(style: text.bodyLarge!, color: color.withOpacity(0.5)),
				],
			),
		);
	}
}