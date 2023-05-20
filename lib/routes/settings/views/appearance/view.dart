import "package:flutter/material.dart" hide Locale;
import "package:isar/isar.dart";
import "package:riba/repositories/local/models/localization.dart";
import "package:riba/routes/settings/widgets/dialogs/list_selection.dart";
import "package:riba/routes/settings/widgets/extra.dart";
import "package:riba/routes/settings/widgets/list_tile.dart";
import "package:riba/routes/settings/widgets/lists/color_preview_list.dart";
import "package:riba/settings/appearance.dart";
import "package:riba/utils/constants.dart";

class SettingsAppearanceView extends StatefulWidget {
	const SettingsAppearanceView({super.key});

  @override
  State<SettingsAppearanceView> createState() => _SettingsAppearanceViewState();
}

class _SettingsAppearanceViewState extends State<SettingsAppearanceView> {
	final preferredLocaleStream = AppearanceSettings.ref
		.where()
		.keyEqualTo(AppearanceSettings.isarKey)
		.preferredLocalesProperty()
		.watch(fireImmediately: true)
		.asyncMap((e) => e.first);

	
	Future<AppearanceSettings> get settingsFuture => AppearanceSettings.ref
		.getByKey(AppearanceSettings.isarKey)
		.then((e) => e as AppearanceSettings);

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			body: CustomScrollView(
				slivers: [
					const SliverAppBar(title: Text("Appearance")),
					ColorPreviewList(brightness: Brightness.light, handleSchemeIdSelection: handleSchemeIdSelection),
					ColorPreviewList(brightness: Brightness.dark, handleSchemeIdSelection: handleSchemeIdSelection),
					const SliverToBoxAdapter(child: SizedBox(height: Edges.large)),
					const SliverToBoxAdapter(child: SegmentTitle(title: "General")),
					SliverToBoxAdapter(
						child: StreamingListTile(
							title: "Preferred display locales",
							subtitle: "Order of precedence locales should take when displaying textual content.",
							stream: preferredLocaleStream,
							onTap: showPreferredDisplayLocalesDialog,
						)
					)
				],
			),
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

	Future<void> showPreferredDisplayLocalesDialog(BuildContext context, List<Locale> locales) async {
		final newLocales = await showDialog<List<Locale>>(
			context: context,
			useSafeArea: false,
			builder: (context) => ListSelectionDialog<Locale>(
				title: "Preferred Display Locales",
				description: "The locales that should take precedence when displaying textual content.",
				currentValue: locales,
				values: Locale.values,
			),
		);

		if (newLocales == null) return;
		await AppearanceSettings.ref.isar.writeTxn(() async {
			final newSettings = (await settingsFuture).copyWith.preferredLocales(newLocales);
			await AppearanceSettings.ref.put(newSettings);
		});
	}
}

