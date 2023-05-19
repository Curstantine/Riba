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
	final SchemeId schemeId;

	@Enumerated(EnumType.ordinal)
	final ThemeMode themeMode;

	AppearanceSettings({
		required this.schemeId,
		required this.themeMode,
	});

	static final defaultSettings = AppearanceSettings(
		schemeId: SchemeId.dynamic,
		themeMode: ThemeMode.system,
	);
}

/// NOTE: DO NOT CHANGE THE ORDER OF THE ENUM
enum SchemeId {
	dynamic,
	lavender;

	String asHumanReadable() {
		switch (this) {
			case SchemeId.dynamic:
				return "Dynamic";
			case SchemeId.lavender:
				return "Lavender";
		}
	}
}
