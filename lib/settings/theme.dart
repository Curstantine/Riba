// ignore_for_file: public_member_api_docs, sort_constructors_first
import "package:flutter/material.dart";
import "package:isar/isar.dart";

import "settings.dart";

part "theme.g.dart";

@Collection(accessor: "themeSettings")
class ThemeSettings {
  static final ref = Settings.instance.database.themeSettings;

  final Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  final String key = "themeSettings";

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
}

/// NOTE: DO NOT CHANGE THE ORDER OF THE ENUM
enum ThemeId {
  dynamic,
  lavender,
}
