import "package:isar/isar.dart";
import "package:riba/repositories/local/models/cover_art.dart";

part "cache.g.dart";

@Collection(accessor: "coverCacheSettings")
class CoverCacheSettings {
  final Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  final String key = "cacheCoverSettings";

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
}

@Collection(accessor: "chapterCacheSettings")
class ChapterCacheSettings {
  final Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  final String key = "cacheChapterSettings";

  late bool enabled;

  ChapterCacheSettings({
    required this.enabled,
  });
}
