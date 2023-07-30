import "package:flutter/material.dart";
import "package:material_symbols_icons/symbols.dart";
import "package:riba/repositories/local/models/author.dart";
import "package:riba/utils/constants.dart";

class AuthorCard extends StatelessWidget {
	const AuthorCard({super.key, required this.author, this.onPress, this.elevation = 0});

	final double elevation;
	final Author author;
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
					elevation:  elevation,
					child: InkWell(
						onTap: onCardPress,
						borderRadius: Corners.allFull,
						splashColor: colors.primary.withOpacity(0.1),
						child: Center(child: Icon(Symbols.person_rounded, size: 36, color: colors.onSurfaceVariant)),
					),
				)),
				const SizedBox(height: Edges.extraSmall),
				SizedBox(height: 46, child: Text(
					author.name,
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