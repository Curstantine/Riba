import "package:flutter/material.dart";
import "package:isar/isar.dart";

part "theme.g.dart";

@Collection(accessor: "themeSettings")
class ThemeSettings {
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
}

/// NOTE: DO NOT CHANGE THE ORDER OF THE ENUM
enum ThemeId {
  dynamic,
  lavender,
}
