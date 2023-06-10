import "package:flutter/material.dart";
import "package:riba/utils/constants.dart";

class TextSkeleton extends StatelessWidget {
	const TextSkeleton({
		super.key,
		this.width = 150,
		this.color,
		required this.style,
	});

	final double width;
	final TextStyle style;
	final Color? color;

	@override
	Widget build(context) {
		final theme = Theme.of(context);

		return Container(
			height: style.fontSize,
			width: width,
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
	});
	
	final bool useLeadingIcon;
	final bool useTrailingIcon;
	final bool useTitle;

	@override
	Widget build(context) {
		final theme = Theme.of(context);
		final text = theme.textTheme;
		final colors = theme.colorScheme;

		return ListTile(
			leading: !useLeadingIcon ? null : buildCircle(colors),
			trailing: !useTrailingIcon ? null : buildCircle(colors),
			title: !useTitle ? null : TextSkeleton(style: text.bodyLarge!, width: double.infinity),
		);
	}

	Widget buildCircle(ColorScheme colors, [double size = 24]) => Container(
		height: size,
		width: size,
		decoration: BoxDecoration(
			color: colors.surfaceVariant,
			shape: BoxShape.circle,
		),
	);
}
