import "package:flutter/material.dart";
import "package:riba/utils/constants.dart";

class TinyChip extends StatelessWidget {
  const TinyChip({
    super.key,
    required this.label,
    this.elevation,
    this.labelColor,
    this.surfaceTintColor,
    this.outlineColor,
    this.onPressed,
  });

  final String label;
  final double? elevation;
  final Color? labelColor;
  final Color? surfaceTintColor;
  final Color? outlineColor;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final color = theme.colorScheme;

    return SizedBox(
      height: 24,
      child: ActionChip(
        elevation: elevation,
        padding: Edges.bottomSmall,
        surfaceTintColor: surfaceTintColor,
        label: Text(label),
        labelStyle: textTheme.labelSmall?.copyWith(color: labelColor),
        side: BorderSide(
          color: outlineColor ?? (surfaceTintColor?.withOpacity(0.5) ?? color.outline),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
