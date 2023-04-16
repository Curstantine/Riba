import "package:flutter/material.dart";
import "package:riba/utils/constants.dart";

class FilledCard extends StatelessWidget {
	const FilledCard({
		super.key,
		this.margin,
		this.clipBehavior = Clip.antiAlias,
		this.shape,
		required this.child,
	});

	final Widget child;
	final EdgeInsets? margin;
	final ShapeBorder? shape;
	final Clip? clipBehavior;

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);

		return Card(
			margin: margin,
			shape: shape,
			clipBehavior: clipBehavior,
			color: theme.colorScheme.surfaceVariant,
			child: child,
		);
	}
}

class OutlinedCard extends StatelessWidget {
  const OutlinedCard({
    super.key,
    required this.child,
    this.margin,
    this.clipBehavior = Clip.antiAlias,
  });

  final Widget child;
  final EdgeInsets? margin;
  final Clip clipBehavior;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      shape: Shapes.outlinedCard(theme),
      clipBehavior: clipBehavior,
      margin: margin,
      child: child,
    );
  }
}
