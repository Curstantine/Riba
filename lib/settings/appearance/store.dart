import "package:copy_with_extension/copy_with_extension.dart";
import "package:flutter/material.dart" hide Locale;
import "package:isar/isar.dart";
import "package:riba/repositories/local/models/localization.dart";

part "store.g.dart";

@CopyWith()
@Collection(accessor: "appearanceSettings")
class AppearanceSettingsStore {
	final Id id = 1;

	@Enumerated(EnumType.ordinal)
	final SchemeId lightSchemeId;

	@Enumerated(EnumType.ordinal)
	final SchemeId darkSchemeId;

	@Enumerated(EnumType.ordinal)
	final ThemeMode themeMode;

	@Enumerated(EnumType.ordinal)
	final List<Locale> preferredDisplayLocales;

	const AppearanceSettingsStore({
		required this.lightSchemeId,
		required this.darkSchemeId,
		required this.themeMode,
		required this.preferredDisplayLocales,
	});

	static final defaultSettings = AppearanceSettingsStore(
		lightSchemeId: SchemeId.dynamic,
		darkSchemeId: SchemeId.dynamic,
		themeMode: ThemeMode.system,
		preferredDisplayLocales: [Locale.en, Locale.jaRo],
	);
}

/// NOTE: DO NOT CHANGE THE ORDER OF THE ENUM
enum SchemeId {
	dynamic,
	brittlePink;

	String asHumanReadable() {
		switch (this) {
			case SchemeId.dynamic:
				return "Dynamic";
			case SchemeId.brittlePink:
				return "Brittle Pink";
		}
	}
}
