import "package:flutter/material.dart";
import "package:riba/settings/appearance/store.dart";
import "package:riba/settings/settings.dart";
import "package:riba/utils/constants.dart";
import "package:riba/utils/theme.dart";

class ColorSchemePreviewCard extends StatelessWidget {
	final SchemeId id;
	final Brightness brightness;
	final void Function() onSelect;

  	const ColorSchemePreviewCard({
		super.key,
		required this.id,
		required this.brightness,
		required this.onSelect,
	});

	@override
	Widget build(context) {
		final theme = Theme.of(context);
		final text = theme.textTheme;
		final colors = theme.colorScheme;

		return FutureBuilder<ColorScheme>(
			future: ThemeManager.getColorScheme(id, brightness),
			builder: (context, snapshot) => Column(mainAxisSize: MainAxisSize.min,children: [
				AnimatedSwitcher(
					duration: LocalDurations.emphasized,
					switchInCurve: LocalEasing.emphasized,
					switchOutCurve: LocalEasing.emphasized,
					child: snapshot.hasData
						? buildCard(text, snapshot.requireData)
						: buildSkeletonCard(colors),
				),
				Text(id.asHumanReadable(), style: text.bodySmall?.withColorOpacity(snapshot.hasData ? 1 : 0.5)),
			]),
		);
	}

	Widget buildCard(TextTheme text, ColorScheme scheme) {
		final listenable = brightness == Brightness.light
			? Settings.instance.appearance.lightSchemeId
			: Settings.instance.appearance.darkSchemeId;
		
		return ValueListenableBuilder(
			valueListenable: listenable,
			builder: (context, selectedSchemeId, child) {
				final isSelected = selectedSchemeId == id;

				return Card(
					elevation: isSelected ? 2 : 0,
					color: scheme.surface,
					surfaceTintColor: Colors.transparent,
					shape: RoundedRectangleBorder(
						borderRadius: Corners.allLarge,
						side: BorderSide(color: scheme.primary, width: isSelected ? 2 : 0)
					),
					child: child,
				);
			},
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
		);
	}

	Widget buildSkeletonCard(ColorScheme scheme) {
		return Card(
			elevation: 0,
			color: scheme.surface,
			surfaceTintColor: Colors.transparent,
			shape: RoundedRectangleBorder(
				borderRadius: Corners.allLarge,
				side: BorderSide(color: scheme.primary.withOpacity(0.5), width: 0)
			),
			child: SizedBox(
				width: 110,
				height: 150,
				child: Column(children: [
					const Spacer(),
					buildNavigationBar(scheme, isLoading: true),
				]),
			),
		);
	}

	Widget buildNavigationBar(ColorScheme scheme, {bool isLoading = false}) {
		return Material(
			elevation: 2,
			color: scheme.surface.withOpacity(0.5),
			shadowColor: Colors.transparent,
			surfaceTintColor: scheme.surfaceTint,
			shape: const RoundedRectangleBorder(
				borderRadius: Corners.bottomLarge,
			),
			child: SizedBox(
				height: 32,
				child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
					createShape(scheme, usePrimary: true, isLoading: isLoading),
					createShape(scheme, isLoading: isLoading),
					createShape(scheme, isLoading: isLoading),
				]),
			),
		);
	}

	Widget createShape(ColorScheme scheme, {bool usePrimary = false, bool isLoading = false}) {
		final color = isLoading ? (
			usePrimary ? scheme.primary.withOpacity(0.25) : scheme.primary.withOpacity(0.1)
		) : (
			usePrimary ? scheme.primary : scheme.primary.withOpacity(0.25)
		);

		return Container(
			width: 12,
			height: 12,
			decoration: BoxDecoration(color: color, borderRadius: Corners.allExtraLarge),
			child: const SizedBox.expand(),
		);
	}
}
