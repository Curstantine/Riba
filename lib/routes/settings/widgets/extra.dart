import "package:flutter/material.dart";
import "package:riba/utils/constants.dart";

class SegmentTitle extends StatelessWidget {
	const SegmentTitle({super.key, required this.title});
	
	final String title;
	
	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		final text = theme.textTheme;
		final colors = theme.colorScheme;

		return Padding(
			padding: Edges.leftLarge.copyWith(top: Edges.medium, bottom: Edges.extraSmall),
			child: Text(
				title,
				style: text.titleSmall?.copyWith(color: colors.primary, fontWeight: FontWeight.w600),
			),
		);
	}
}