import "package:flutter/material.dart";
import "package:riba/routes/settings/widgets/cards/color_scheme_preview.dart";
import "package:riba/routes/settings/widgets/extra.dart";
import "package:riba/settings/appearance.dart";
import "package:riba/utils/constants.dart";

class ColorPreviewList extends StatelessWidget {
	const ColorPreviewList({super.key, required this.brightness, required this.handleSchemeIdSelection});

	final Brightness brightness;
	final void Function(SchemeId, Brightness) handleSchemeIdSelection;

	@override
	Widget build(BuildContext context) {
		final title = "${brightness == Brightness.light ? "Light" : "Dark"} Color Scheme";

		return SliverList.list(children: [
			SegmentTitle(title: title),
			SingleChildScrollView(
				scrollDirection: Axis.horizontal,
				padding: Edges.horizontalMedium,
				child: Row(children: [
					for (final schemeId in SchemeId.values) ColorSchemePreviewCard(
						id: schemeId,
						brightness: brightness,
						onSelect: () => handleSchemeIdSelection(schemeId, brightness),
					)
				]),
		)
		]);
	}
}