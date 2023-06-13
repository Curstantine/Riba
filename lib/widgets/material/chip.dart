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

class RawChipExt extends RawChip {
	const RawChipExt({
		super.key,
		super.padding = Edges.horizontalNone,
		super.visualDensity = VisualDensity.comfortable,
		super.defaultProperties,
		super.avatar,
		required super.label,
		super.labelStyle,
		super.labelPadding,
		super.deleteIcon,
		super.onDeleted,
		super.deleteIconColor,
		super.deleteButtonTooltipMessage,
		super.onPressed,
		super.onSelected,
		super.pressElevation,
		super.tapEnabled = true,
		super.selected = false,
		super.isEnabled = true,
		super.disabledColor,
		super.selectedColor,
		super.tooltip,
		super.side,
		super.shape,
		super.clipBehavior = Clip.none,
		super.focusNode,
		super.autofocus = false,
		super.backgroundColor,
		super.materialTapTargetSize,
		super.elevation,
		super.shadowColor,
		super.surfaceTintColor,
		super.iconTheme,
		super.selectedShadowColor,
		super.showCheckmark = true,
		super.checkmarkColor,
		super.avatarBorder = const CircleBorder(),
	});
}

class FilterChipExt extends FilterChip {
	const FilterChipExt({
		super.key,
		required super.label,
		required super.onSelected,
		super.padding = Edges.horizontalSmall,
		super.visualDensity = VisualDensity.comfortable,
		super.avatar,
		super.labelStyle,
		super.labelPadding,
		super.selected,
		super.pressElevation,
		super.disabledColor,
		super.selectedColor,
		super.tooltip,
		super.side,
		super.shape,
		super.clipBehavior,
		super.focusNode,
		super.autofocus,
		super.backgroundColor,
		super.materialTapTargetSize,
		super.elevation,
		super.shadowColor,
		super.surfaceTintColor,
		super.iconTheme,
		super.selectedShadowColor,
		super.showCheckmark,
		super.checkmarkColor,
		super.avatarBorder,
	});
}