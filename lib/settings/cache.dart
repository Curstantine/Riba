import "package:isar/isar.dart";
import "package:riba/repositories/local/cover_art.dart";

@Collection(accessor: "cache")
class CacheSettings {
  final Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  final String key = "cache";

  late CacheCoverSettings coverSettings;
  late CacheChapterSettings chapterSettings;
}

@embedded
class CacheCoverSettings {
  late bool enabled;
  late CoverSize previewSize;
  late CoverSize fullSize;

  CacheCoverSettings({
    required this.enabled,
    required this.previewSize,
    required this.fullSize,
  });
}

@embedded
class CacheChapterSettings {
  late bool enabled;

  CacheChapterSettings({
    required this.enabled,
  });
}
