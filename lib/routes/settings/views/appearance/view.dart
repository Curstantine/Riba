import "package:flutter/material.dart" hide Locale;
import "package:riba/repositories/local/models/localization.dart";
import "package:riba/routes/settings/widgets/dialogs/general.dart";
import "package:riba/routes/settings/widgets/dialogs/list_sortable.dart";
import "package:riba/routes/settings/widgets/extra.dart";
import "package:riba/routes/settings/widgets/list_tile.dart";
import "package:riba/routes/settings/widgets/lists/color_preview_list.dart";
import "package:riba/settings/appearance/controller.dart";
import "package:riba/settings/settings.dart";
import "package:riba/utils/constants.dart";

class SettingsAppearanceView extends StatefulWidget {
	const SettingsAppearanceView({super.key});

  @override
  State<SettingsAppearanceView> createState() => _SettingsAppearanceViewState();
}

class _SettingsAppearanceViewState extends State<SettingsAppearanceView> {
	AppearanceSettingsController get controller => Settings.instance.appearance;

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			body: CustomScrollView(
				slivers: [
					const SliverAppBar(title: Text("Appearance")),
					ColorPreviewList(brightness: Brightness.light, handleSchemeIdSelection: controller.setSchemeId),
					ColorPreviewList(brightness: Brightness.dark, handleSchemeIdSelection: controller.setSchemeId),
					const SliverToBoxAdapter(child: SizedBox(height: Edges.large)),
					const SliverToBoxAdapter(child: SegmentTitle(title: "General")),
					SliverToBoxAdapter(
						child: ValueListenableListTile(
							valueListenable: controller.preferredDisplayLocales,
							title: "Preferred display locales",
							subtitle: "Order of precedence locales should take when displaying textual content.",
							onTap: showPreferredDisplayLocalesDialog,
						)
					)
				],
			),
		);
	}

	Future<void> showPreferredDisplayLocalesDialog(BuildContext context, List<Locale> locales) async {
		final newLocales = await showDialog<List<Locale>>(
			context: context,
			useSafeArea: false,
			builder: (context) => ListSortableDialog<Locale>(
				title: "Preferred Display Locales",
				description: "The locales that should take precedence when displaying textual content.",
				currentValue: locales,
				values: Locale.values,
				itemBuilder: (locale) => ListItemData(
					locale.language.asHumanReadable(),
					subtitle: locale.romanized ? "Romanized" : "Native",
				),
				onReset: controller.resetPreferredDisplayLocales,
			),
		);

		if (newLocales == null) return;
		return controller.setPreferredDisplayLocales(newLocales);
	}
}

