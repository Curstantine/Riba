import "package:flutter/material.dart" hide SearchBar;
import "package:riba/utils/constants.dart";

class SearchBar extends StatelessWidget {
	/// Reimplemented M3 search bar.
	const SearchBar({
		super.key,
		required this.controller,
		this.hintText = "Search",
		this.trailing,
	}) : assert(trailing == null || trailing.length <= 2);

	final SearchController controller;
	final String hintText;
	final List<Widget>? trailing;

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		final text = theme.textTheme;
		final colors = theme.colorScheme;

		return Material(
			color: colors.surface,
			surfaceTintColor: colors.surfaceTint,
			borderRadius: Corners.allFull,
			elevation: 3,
			shadowColor: Colors.transparent,
			child: InkWell(
				onTap: () => controller.openView(),
				borderRadius: Corners.allFull,
				child: Container(
					height: 56,
					width: double.infinity,
					decoration: const BoxDecoration(borderRadius: Corners.allFull),
					constraints: const BoxConstraints(minWidth: 360, maxHeight: 720),
					child: Row(children: [
						Padding(
							padding: Edges.horizontalLarge,
							child: Icon(Icons.search_rounded, size: 24, color: colors.onSurface)),
						Expanded(
							child: TextField(
								readOnly: true,
								controller: controller,
								onTap: () => controller.openView(),
								decoration: InputDecoration(									
									hintText: hintText,
									hintStyle: text.bodyLarge?.copyWith(color: colors.onSurfaceVariant),
									border: InputBorder.none,
								),
							),
						),
						if (trailing != null) ...[
							const SizedBox(width: Edges.large),
							...trailing!,
							const SizedBox(width: Edges.small),
						],
					]),
				),
			),
		);
	}
}