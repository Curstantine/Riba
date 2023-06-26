import "package:flutter/material.dart";
import "package:riba/utils/constants.dart";

class TinyButton extends StatelessWidget {
	const TinyButton({
		super.key,
		this.enabled = true,
		required this.label,
		this.leadingIcon,
		this.onTap,
	});
	
	final bool enabled;
	final String label;
	final IconData? leadingIcon;
	final GestureTapCallback? onTap;

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		final colors = theme.colorScheme;
		final textTheme = theme.textTheme;

		final primary = colors.primary.withOpacity(enabled ? 1 : 0.33);

		return InkWell(
			onTap: onTap,
			child: Row(mainAxisSize: MainAxisSize.min, children: [
				if (leadingIcon != null) ...[
					Icon(leadingIcon, color: primary, size: 20),
					const SizedBox(width: Edges.extraSmall),
				],
				Text(label, style: textTheme.labelLarge?.copyWith(color: primary)),
			]),
		);
	}
}
