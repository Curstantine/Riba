import "package:flutter/material.dart";
import "package:riba/utils/constants.dart";

class FilledCard extends StatelessWidget {
  const FilledCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(elevation: 0, color: theme.colorScheme.surfaceVariant, child: child);
  }
}

class OutlinedCard extends StatelessWidget {
  const OutlinedCard({
    super.key,
    required this.child,
    this.clipBehavior = Clip.antiAlias,
    this.margin,
  });

  final Clip clipBehavior;
  final Widget child;
  final EdgeInsets? margin;

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
