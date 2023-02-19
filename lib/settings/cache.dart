import "package:hive/hive.dart";
import "package:riba/repositories/local/cover_art.dart";
import "package:riba/settings/settings.dart";

class CacheSettings extends SettingsController<CacheSettingsData> {
  static final CacheSettings instance = Settings.instance.caching;

  @override
  final String id = "cache";

  @override
  late final Box box;

  @override
  CacheSettingsData get defaultValue => const CacheSettingsData(
        cacheCovers: true,
        fullSize: CoverSize.original,
        previewSize: CoverSize.small,
      );

  @override
  Future<void> init() async {
    Hive.registerAdapter(CoverSizeAdapter());
    box = await Hive.openBox(id);
  }

  bool get cacheCovers => box.get(
        CacheSettingKeys.cacheCovers,
        defaultValue: defaultValue.cacheCovers,
      );

  CoverSize get previewSize => box.get(
        CacheSettingKeys.previewSize,
        defaultValue: defaultValue.previewSize,
      );

  CoverSize get fullSize => box.get(
        CacheSettingKeys.fullSize,
        defaultValue: defaultValue.fullSize,
      );
}

class CacheSettingsData {
  final bool cacheCovers;
  final CoverSize previewSize;
  final CoverSize fullSize;

  const CacheSettingsData({
    required this.cacheCovers,
    required this.previewSize,
    required this.fullSize,
  });

  CacheSettingsData copyWith({
    bool? cacheCovers,
    CoverSize? previewSize,
    CoverSize? fullSize,
  }) {
    return CacheSettingsData(
      cacheCovers: cacheCovers ?? this.cacheCovers,
      previewSize: previewSize ?? this.previewSize,
      fullSize: fullSize ?? this.fullSize,
    );
  }

  @override
  String toString() =>
      "CacheSettingsData(cacheCovers: $cacheCovers, previewSize: $previewSize, fullSize: $fullSize)";
}

class CacheSettingKeys {
  static const cacheCovers = "cacheCovers";
  static const fullSize = "fullSize";
  static const previewSize = "previewSize";
}
