import "package:flutter/material.dart";
import "package:isar/isar.dart";

import "settings.dart";

part "theme.g.dart";

@Collection(accessor: "themeSettings")
class ThemeSettings {
	static final ref = Settings.instance.themeSettings;
	static const isarKey = "themeSettings";

	final Id id = Isar.autoIncrement;

	@Index(unique: true, replace: true)
	final String key = isarKey;

	@Enumerated(EnumType.ordinal)
	late ThemeId themeId;

	@Enumerated(EnumType.ordinal)
	late ThemeMode themeMode;

	ThemeSettings({
		required this.themeId,
		required this.themeMode,
	});

	ThemeSettings copyWith({
		ThemeId? themeId,
		ThemeMode? themeMode,
	}) {
		return ThemeSettings(
			themeId: themeId ?? this.themeId,
			themeMode: themeMode ?? this.themeMode,
		);
	}

	static final defaultSettings = ThemeSettings(
		themeId: ThemeId.dynamic,
		themeMode: ThemeMode.system,
	);
}

/// NOTE: DO NOT CHANGE THE ORDER OF THE ENUM
enum ThemeId {
	dynamic,
	lavender,
}
