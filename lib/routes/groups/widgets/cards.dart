import "package:flutter/material.dart";
import "package:material_symbols_icons/symbols.dart";
import "package:riba/repositories/runtime/group.dart";
import "package:riba/utils/constants.dart";

class GroupCard extends StatelessWidget {
	const GroupCard({super.key, required this.groupData, this.onPress});

	final GroupData groupData;
	final VoidCallback? onPress;

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		final text = theme.textTheme;
		final colors = theme.colorScheme;

		return SizedBox(
			width: 125,
			height: 175,
			child: Column(mainAxisAlignment: MainAxisAlignment.end, crossAxisAlignment: CrossAxisAlignment.start, children: [
				SizedBox(width: 125, height: 125, child: Material(
					type: MaterialType.circle,
					color: colors.surface,
					surfaceTintColor: colors.primary,
					shadowColor: Colors.transparent,
					child: InkWell(
						onTap: onCardPress,
						borderRadius: Corners.allFull,
						child: Center(child: Icon(Symbols.group_rounded, size: 36, color: colors.onSurfaceVariant)),
					),
				)),
				const SizedBox(height: Edges.extraSmall),
				SizedBox(height: 46, child: Text(
					groupData.group.name,
					maxLines: 2,
					softWrap: true,
					overflow: TextOverflow.ellipsis,
					style: text.bodySmall,
				)),
			]),
		);
	}

	void onCardPress() {
		onPress?.call();
	}
}