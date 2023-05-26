import "package:flutter/material.dart";
import "package:riba/utils/constants.dart";

class TextSkeleton extends StatelessWidget {
	const TextSkeleton({
		super.key,
		this.width = 150,
		required this.style,
	});

	final double width;
	final TextStyle style;

	@override
	Widget build(context) {
		final theme = Theme.of(context);

		return Container(
			height: style.fontSize,
			width: width,
			decoration: BoxDecoration(
				color: theme.colorScheme.surface,
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
			color: colors.surface,
			shape: BoxShape.circle,
		),
	);
}
