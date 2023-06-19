import "package:flutter/material.dart";
import "package:material_symbols_icons/symbols.dart";
import "package:riba/utils/constants.dart";

class FullScreenDialog extends StatelessWidget {
	const FullScreenDialog({
		super.key,
		required this.title,
		required this.description,
		required this.sliver,
		required this.onConfirm,
		this.onReset,
	});


	final String title;
	final String description;
	final Widget sliver;

	final void Function() onConfirm;
	final void Function()? onReset;

	@override
	Widget build(context) {
		final theme = Theme.of(context);
		final text = theme.textTheme;
		final colors = theme.colorScheme;

		return Scaffold(
			body: CustomScrollView(slivers: [
				SliverAppBar.medium(
					title: Text(title, overflow: TextOverflow.visible, maxLines: 1),
					leading: IconButton(
						icon: const Icon(Symbols.close_rounded),
						onPressed: () => Navigator.pop(context),
					),
					actions: [	
						IconButton(
							onPressed: onReset == null ? null : () => handleReset.call(context),
							icon: const Icon(Symbols.restore_rounded),
						),
						IconButton(
							onPressed: () => handleConfirm.call(context),
							icon: const Icon(Symbols.check_rounded),
						),
					],
				),
				SliverToBoxAdapter(child: Padding(
					padding: Edges.horizontalLarge.copyWith(bottom: Edges.medium),
					child: Text(description, style: text.bodyMedium?.copyWith(color: colors.onSurfaceVariant)),
				)),
			    sliver,
			]),
		);
	}

	void handleReset(BuildContext context) {
		onReset?.call();
		Navigator.pop(context);
	}

	void handleConfirm(BuildContext context) {
		onConfirm.call();
	}
}

final class ListItemData {
	final String title;
	final String? subtitle;
	final bool isThreeLine;

	const ListItemData(this.title, {this.subtitle, this.isThreeLine = false});
}