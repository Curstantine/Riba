import "package:flutter/material.dart";
import "package:riba/utils/constants.dart";

class TinyButton extends StatelessWidget {
  final bool enabled;
  final String text;
  final IconData? icon;
  final GestureTapCallback? onPressed;

  const TinyButton({super.key, this.enabled = true, required this.text, this.icon, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final primary = colorScheme.primary.withOpacity(enabled ? 1 : 0.33);
    final label = textTheme.labelLarge?.copyWith(color: primary);

    return InkWell(
      onTap: onPressed,
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        if (icon != null) ...[
          Icon(icon, color: primary, size: 20),
          const SizedBox(width: Edges.extraSmall),
        ],
        Text(text, style: label),
      ]),
    );
  }
}
