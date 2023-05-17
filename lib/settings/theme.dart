import "package:copy_with_extension/copy_with_extension.dart";
import "package:flutter/material.dart";
import "package:isar/isar.dart";

import "settings.dart";

part "theme.g.dart";

@CopyWith()
@Collection(accessor: "themeSettings")
class ThemeSettings {
	static final ref = Settings.instance.themeSettings;
	static const isarKey = "themeSettings";

	final Id id = Isar.autoIncrement;

	@Index(unique: true, replace: true)
	final String key = isarKey;

	@Enumerated(EnumType.ordinal)
	final ThemeId themeId;

	@Enumerated(EnumType.ordinal)
	final ThemeMode themeMode;

	ThemeSettings({
		required this.themeId,
		required this.themeMode,
	});

	static final defaultSettings = ThemeSettings(
		themeId: ThemeId.dynamic,
		themeMode: ThemeMode.system,
	);
}

/// NOTE: DO NOT CHANGE THE ORDER OF THE ENUM
enum ThemeId {
	dynamic,
	lavender;

	String toHumanReadable() {
		switch (this) {
			case ThemeId.dynamic:
				return "Dynamic";
			case ThemeId.lavender:
				return "Lavender";
		}
	}
}
