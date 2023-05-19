import "package:flutter/material.dart";
import "package:riba/routes/settings/widgets/cards/color_scheme_preview.dart";
import "package:riba/routes/settings/widgets/extra.dart";
import "package:riba/settings/appearance.dart";
import "package:riba/utils/constants.dart";

class SettingsAppearanceView extends StatelessWidget {
	const SettingsAppearanceView({super.key});

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			body: CustomScrollView(
				slivers: [
					const SliverAppBar(title: Text("Appearance")),
					const SliverToBoxAdapter(child: SegmentTitle(title: "Light Color Scheme")),
					SliverToBoxAdapter(child: buildColorSchemeCards(Brightness.light)),
					const SliverToBoxAdapter(child: SegmentTitle(title: "Dark Color Scheme")),
					SliverToBoxAdapter(child: buildColorSchemeCards(Brightness.dark))
				],
			),
		);
	}

	Widget buildColorSchemeCards(Brightness brightness) {
		return SingleChildScrollView(
				scrollDirection: Axis.horizontal,
				padding: Edges.horizontalMedium,
				child: Row(children: [
					for (final schemeId in SchemeId.values) ColorSchemePreviewCard(
						id: schemeId,
						brightness: brightness,
						onSelect: () => handleSchemeIdSelection(schemeId, brightness),
					)
				]),
		);
	}

	Future<void> handleSchemeIdSelection(SchemeId id, Brightness brightness) => AppearanceSettings.ref.isar.writeTxn(() async {
		final current = (await AppearanceSettings.ref.getByKey(AppearanceSettings.isarKey))!;
		
		AppearanceSettings newSettings;
		switch (brightness) {
			case Brightness.light:
				newSettings = current.copyWith.lightSchemeId(id);
				break;
			case Brightness.dark:
				newSettings = current.copyWith.darkSchemeId(id);
				break;
		}

		await AppearanceSettings.ref.put(newSettings);
	});
}

