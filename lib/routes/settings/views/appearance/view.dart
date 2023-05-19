import "dart:async";

import "package:flutter/material.dart";
import "package:riba/routes/settings/widgets/extra.dart";
import "package:riba/settings/appearance.dart";
import "package:riba/utils/constants.dart";
import "package:riba/utils/theme.dart";

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
		final children = SchemeId.values.map((themeId) => ColorSchemePreviewCard(
			id: themeId,
			brightness: brightness,
			onSelect: () => handleSchemeIdSelection(themeId, brightness),
		));

		return Padding(
			padding: Edges.horizontalMedium,
			child: SingleChildScrollView(child: Row(children:children.toList())),
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

class ColorSchemePreviewCard extends StatelessWidget {
	final SchemeId id;
	final Brightness brightness;
	final bool isSelected;
	final void Function() onSelect;

  	const ColorSchemePreviewCard({
		super.key,
		required this.id,
		required this.brightness,
		this.isSelected = false,
		required this.onSelect,
	});

	@override
	Widget build(context) {
		final text = Theme.of(context).textTheme;
		final colorScheme = ThemeManager.getColorScheme(id, brightness);

		return FutureBuilder<ColorScheme>(
			future: colorScheme,
			builder: (context, snapshot) {
				if (snapshot.hasData) {
					return buildCard(text, snapshot.requireData);
				} else {
					return const SizedBox.shrink();
				}
			}
		);
	}

	Widget buildCard(TextTheme text, ColorScheme scheme) {
		return Column(mainAxisSize: MainAxisSize.min,children: [
			Card(
				elevation: 0,
				color: scheme.background,
				shape: RoundedRectangleBorder(
					borderRadius: Corners.allLarge,
					side: BorderSide(color: scheme.primary, width: 2)
				),
				child: InkWell(
				  onTap: onSelect,
				  borderRadius: Corners.allLarge,
				  splashColor: scheme.primary.withOpacity(0.25),
				  child: SizedBox(
				    width: 110,
				    height: 150,
				    child: Column(children: [
						const Spacer(),
						buildNavigationBar(scheme),
					]),
				  ),
				),
			),
			Text(id.asHumanReadable(), style: text.bodySmall),
		]);
	}

	Widget buildNavigationBar(ColorScheme scheme) {
		return Material(
			elevation: 2,
			color: scheme.background,
			surfaceTintColor: scheme.surfaceTint,
			shape: const RoundedRectangleBorder(
				borderRadius: Corners.bottomLarge,
			),
			child: SizedBox(
				height: 32,
				child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
					createShape(scheme, usePrimary: true),
					createShape(scheme),
					createShape(scheme),
				]),
			),
		);
	}

	Widget createShape(ColorScheme scheme, {bool usePrimary = false}) {
		return Container(
			width: 12,
			height: 12,
			decoration: BoxDecoration(
				color: usePrimary ? scheme.primary : scheme.primary.withOpacity(0.25),
				borderRadius: Corners.allExtraLarge,
			),
			child: const SizedBox.expand(),
		);
	}
}