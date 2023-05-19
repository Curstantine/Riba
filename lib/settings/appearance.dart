import "package:copy_with_extension/copy_with_extension.dart";
import "package:flutter/material.dart";
import "package:isar/isar.dart";

import "settings.dart";

part "appearance.g.dart";

@CopyWith()
@Collection(accessor: "appearanceSettings")
class AppearanceSettings {
	static final ref = Settings.instance.themeSettings;
	static const isarKey = "themeSettings";

	final Id id = Isar.autoIncrement;

	@Index(unique: true, replace: true)
	final String key = isarKey;

	@Enumerated(EnumType.ordinal)
	final SchemeId lightSchemeId;

	@Enumerated(EnumType.ordinal)
	final SchemeId darkSchemeId;

	@Enumerated(EnumType.ordinal)
	final ThemeMode themeMode;

	AppearanceSettings({
		required this.lightSchemeId,
		required this.darkSchemeId,
		required this.themeMode,
	});

	static final defaultSettings = AppearanceSettings(
		lightSchemeId: SchemeId.dynamic,
		darkSchemeId: SchemeId.dynamic,
		themeMode: ThemeMode.system,
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
