import "dart:async";

import "package:flutter/material.dart";
import "package:riba/settings/theme.dart";
import "package:riba/utils/constants.dart";
import "package:riba/utils/theme.dart";

class SettingsAppearanceView extends StatelessWidget {
	const SettingsAppearanceView({super.key});

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(title: const Text("Appearance")),
			body: ListView(children: [
				SingleChildScrollView(child: Row(children: [
					for (final themeId in ThemeId.values)
						ColorSchemePreviewCard(
							key: ValueKey(themeId),
							name: themeId.toHumanReadable(),
							colorScheme: ThemeManager.getColorScheme(
								themeId,
								ThemeManager.instance.pref.value.themeMode.asBrightness(),
							),
							onSelect: () => ThemeSettings.ref.isar.writeTxn(() async {
								final current = (await ThemeSettings.ref.getByKey(ThemeSettings.isarKey))!;
								await ThemeSettings.ref.put(current.copyWith.themeId(themeId));
							}),
						)							
					]),
				)
			]),
		);
	}
}

class ColorSchemePreviewCard extends StatelessWidget {
	final String name;
	final FutureOr<ColorScheme> colorScheme;
	final bool isSelected;
	final void Function() onSelect;

  	const ColorSchemePreviewCard({
		super.key,
		required this.name,
		required this.colorScheme,
		this.isSelected = false,
		required this.onSelect,
	});

	@override
	Widget build(context) {
		return FutureBuilder<ColorScheme>(
			future: colorScheme is Future<ColorScheme> ? colorScheme as Future<ColorScheme> : null,
			initialData: colorScheme is ColorScheme ? colorScheme as ColorScheme : null,
			builder: (context, snapshot) {
				if (snapshot.hasData) {
					return buildCard(snapshot.requireData);
				} else {
					return const SizedBox.shrink();
				}
			}
		);
	}

	Widget buildCard(ColorScheme scheme) {
		return GestureDetector(
			onTap: onSelect,
			child: Padding(
				padding: const EdgeInsets.symmetric(horizontal: 5),
				child: Column(
					mainAxisSize: MainAxisSize.min,					
					children: [
						Container(
							width: 120,
							height: 170,
							padding: const EdgeInsets.all(5),
							decoration: BoxDecoration(
								color: scheme.background,
								// border: Border.all(color: borderColor, width: borderWidth),
								borderRadius: Corners.allSmall),
						child: Column(
							children: [
							Column(
								crossAxisAlignment: CrossAxisAlignment.start,
								children: [
								Container(
									height: 10,
									width: 60,
									decoration: BoxDecoration(
									color: scheme.onBackground,
									borderRadius: Corners.allExtraLarge,
									),
								),
								const SizedBox(height: 10),
								Container(
									height: 40,
									padding: const EdgeInsets.all(5),
									decoration: BoxDecoration(
									color: scheme.surfaceVariant,
									// borderRadius: Consts.borderRadiusMin,
									),
									child: Column(
									crossAxisAlignment: CrossAxisAlignment.start,
									children: [
										Container(
										height: 8,
										width: 40,
										decoration: BoxDecoration(
											color: scheme.surfaceVariant,
											// borderRadius: Consts.borderRadiusMax,
										),
										),
										const SizedBox(height: 5),
										Container(
										height: 6,
										width: 110,
										decoration: BoxDecoration(
											color: scheme.onSurfaceVariant,
											// borderRadius: Consts.borderRadiusMax,
										),
										),
									],
									),
								),
								],
							),
							const Spacer(),
							Row(
								mainAxisAlignment: MainAxisAlignment.end,
								children: [
								Container(
									width: 16,
									height: 16,
									margin: const EdgeInsets.only(right: 7, bottom: 7),
									decoration: BoxDecoration(
									shape: BoxShape.circle,
									color: scheme.primary,
									),
									child: Center(
									child: Container(
										width: 6,
										height: 2,
										decoration: BoxDecoration(
										shape: BoxShape.rectangle,
										// borderRadius: Consts.borderRadiusMin,
										color: scheme.onPrimary,
										),
									),
									),
								),
								],
							),
							SizedBox(
								height: 15,
								child: Row(
								mainAxisAlignment: MainAxisAlignment.spaceEvenly,
								children: [
									Container(
									height: 8,
									width: 8,
									decoration: BoxDecoration(
										color: scheme.primary,
										shape: BoxShape.rectangle,
									),
									),
									Container(
									height: 8,
									width: 8,
									decoration: BoxDecoration(
										color: scheme.surfaceVariant,
										shape: BoxShape.circle,
									),
									),
									Container(
									height: 8,
									width: 8,
									decoration: BoxDecoration(
										color: scheme.surfaceVariant,
										shape: BoxShape.circle,
									),
									),
								],
								),
							)
							],
						),
						),
						Text(name),
					],
				),
			),
		);
	}
}