import "dart:async";

import "package:flutter/material.dart";
import "package:logging/logging.dart";
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
					const SliverToBoxAdapter(child: SegmentTitle(title: "Color Scheme")),
					SliverToBoxAdapter(child: buildColorSchemeCards())
				],
			),
		);
	}

	Widget buildColorSchemeCards() {
		final children = SchemeId.values.map((themeId) => ColorSchemePreviewCard(
			id: themeId,
			onSelect: () => AppearanceSettings.ref.isar.writeTxn(() async {
				final current = (await AppearanceSettings.ref.getByKey(AppearanceSettings.isarKey))!;
				await AppearanceSettings.ref.put(current.copyWith.schemeId(themeId));
			}),
		));

		return Padding(
			padding: Edges.horizontalMedium,
			child: SingleChildScrollView(child: Row(children:children.toList())),
		);
	}
}

class ColorSchemePreviewCard extends StatelessWidget {
	final SchemeId id;
	final bool isSelected;
	final void Function() onSelect;

  	const ColorSchemePreviewCard({
		super.key,
		required this.id,
		this.isSelected = false,
		required this.onSelect,
	});

	@override
	Widget build(context) {
	Logger.root.warning("start id: $id");
		final text = Theme.of(context).textTheme;

		return ValueListenableBuilder(
			valueListenable: ThemeManager.instance.themeMode,
			builder: (context, mode, child) {
				final colorScheme = ThemeManager.getAccompanyingColorSchemes(id);
				
				return FutureBuilder<AccompanyingColorSchemes>(
					future: colorScheme is Future<AccompanyingColorSchemes> ? colorScheme : null,
					initialData: colorScheme is AccompanyingColorSchemes ? colorScheme : null,
					builder: (context, snapshot) {
						if (snapshot.hasData) {
							return buildCard(text, snapshot.requireData, mode);
						} else {
							return const SizedBox.shrink();
						}
					}
				);
			},
		);
	}

	Widget buildCard(TextTheme text, AccompanyingColorSchemes schemes, ThemeMode mode) {
		final scheme = schemes.ofBrightness(mode.asBrightness());

	Logger.root.warning("buildcard id: $id");
		return Card(
			elevation: 0,
			color: scheme.background,
			shape: RoundedRectangleBorder(
				borderRadius: Corners.allLarge,
				side: BorderSide(
					color: scheme.primary,
					width: 2,
				),
			),
			child: SizedBox(
				width: 110,
				height: 150,
				child: InkWell(
					onTap: onSelect,
					borderRadius: Corners.allLarge,
					splashColor: scheme.primary.withOpacity(0.25),
					child: Column(children: [
						Text(id.asHumanReadable(), style: text.bodySmall),
						const Spacer(),
						buildNavigationBar(scheme),
					]),
				),
			),
		);
	}

	Widget buildNavigationBar(ColorScheme scheme) {
		return Material(
			elevation: 2,
			color: scheme.background,
			surfaceTintColor: scheme.surfaceTint,
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