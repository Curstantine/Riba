// ignore_for_file: public_member_api_docs, sort_constructors_first
import "package:isar/isar.dart";
import "package:riba/repositories/local/models/cover_art.dart";
import "package:riba/settings/settings.dart";

part "cache.g.dart";

@Collection(accessor: "coverCacheSettings")
class CoverCacheSettings {
  static final ref = Settings.instance.database.coverCacheSettings;

  final Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  final String key = "coverCacheSettings";

  late bool enabled;

  @Enumerated(EnumType.ordinal)
  late CoverSize previewSize;

  @Enumerated(EnumType.ordinal)
  late CoverSize fullSize;

  CoverCacheSettings({
    required this.enabled,
    required this.previewSize,
    required this.fullSize,
  });

  CoverCacheSettings copyWith({
    bool? enabled,
    CoverSize? previewSize,
    CoverSize? fullSize,
  }) {
    return CoverCacheSettings(
      enabled: enabled ?? this.enabled,
      previewSize: previewSize ?? this.previewSize,
      fullSize: fullSize ?? this.fullSize,
    );
  }
}

@Collection(accessor: "chapterCacheSettings")
class ChapterCacheSettings {
  static final ref = Settings.instance.database.chapterCacheSettings;

  final Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  final String key = "chapterCacheSettings";

  late bool enabled;

  ChapterCacheSettings({
    required this.enabled,
  });

  ChapterCacheSettings copyWith({
    bool? enabled,
  }) {
    return ChapterCacheSettings(
      enabled: enabled ?? this.enabled,
    );
  }
}
