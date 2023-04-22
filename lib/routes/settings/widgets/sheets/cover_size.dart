import "package:flutter/material.dart";
import "package:riba/repositories/local/models/cover_art.dart";
import "package:riba/utils/constants.dart";

class CoverSizeSheet extends StatelessWidget {
	const CoverSizeSheet({
		super.key,
		required this.title,
		required this.currentValue,
		required this.onChanged,
	});

	final String title;
	final CoverSize currentValue;
	final ValueChanged<CoverSize> onChanged;

	@override
	Widget build(BuildContext context) {
		final text = Theme.of(context).textTheme;

		return SizedBox(
			child: Padding(
				padding: Edges.verticalMedium,
				child: Column(
					mainAxisSize: MainAxisSize.min,
					crossAxisAlignment: CrossAxisAlignment.start,
					children: [
						Padding(
							padding: Edges.horizontalExtraLarge.copyWithSelf(Edges.verticalLarge),
							child: Text(title, style: text.titleMedium),
						),
						for (final size in CoverSize.values)
							RadioListTile<CoverSize>(
								value: size,
								key: ValueKey(size.name),
								groupValue: currentValue,
								title: Text(size.asHumanReadable()),
								secondary:
									size.size == null ? null : Text("${size.size}x", style: text.labelSmall),
									onChanged: (value) {
									Navigator.pop(context, value);
									if (value != null) onChanged.call(value);
								},
							),
					],
				),
			),
		);
	}
}