import "package:flutter/material.dart";
import "package:riba/utils/constants.dart";
import "package:riba/utils/errors.dart";

class ErrorCard extends StatelessWidget {
	final Object? error;
	final EdgeInsets? margin;

	const ErrorCard({
		super.key,
		required this.error,
		this.margin,
	});

	@override
	Widget build(context) {
		final theme = Theme.of(context);
		final text = theme.textTheme;
		final colors = theme.colorScheme;

		final error = ErrorState.fromSource(this.error);

		return Card(
			margin: margin,
			color: colors.error,
			child: Padding(
				padding: Edges.allMedium,
				child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
					Text(error.title, style: text.labelLarge?.copyWith(color: colors.onError)),
					Text(error.description, style: text.bodySmall?.copyWith(color: colors.onError)),
				]),
			),
		);
	}
}