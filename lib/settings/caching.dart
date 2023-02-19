import "dart:developer";

import "package:hive/hive.dart";
import "package:riba/repositories/local/cover_art.dart";
import "package:riba/settings/settings.dart";

class CachingSettings extends SettingsController<CachingSettingsData> {
  @override
  final String id = "caching";

  @override
  late final Box box;

  @override
  CachingSettingsData get defaultValue => const CachingSettingsData(
        cacheCovers: true,
        fullSize: CoverSize.original,
        previewSize: CoverSize.small,
      );

  @override
  Future<void> init() async {
    Hive.registerAdapter(CoverSizeAdapter());
    box = await Hive.openBox(id);
  }

  @override
  CachingSettingsData get() {
    return CachingSettingsData(
      cacheCovers: box.get("cacheCovers", defaultValue: defaultValue.cacheCovers),
      fullSize: box.get("fullSize", defaultValue: defaultValue.fullSize),
      previewSize: box.get("previewSize", defaultValue: defaultValue.previewSize),
    );
  }

  @override
  void save(CachingSettingsData data) {
    log("Saving caching settings: $data", name: "CachingSettings");

    box.put("cacheCovers", data.cacheCovers);
    box.put("fullSize", data.fullSize);
    box.put("previewSize", data.previewSize);
  }
}

class CachingSettingsData {
  final bool cacheCovers;
  final CoverSize previewSize;
  final CoverSize fullSize;

  const CachingSettingsData({
    required this.cacheCovers,
    required this.previewSize,
    required this.fullSize,
  });

  CachingSettingsData copyWith({
    bool? cacheCovers,
    CoverSize? previewSize,
    CoverSize? fullSize,
  }) {
    return CachingSettingsData(
      cacheCovers: cacheCovers ?? this.cacheCovers,
      previewSize: previewSize ?? this.previewSize,
      fullSize: fullSize ?? this.fullSize,
    );
  }

  @override
  String toString() =>
      "CachingSettingsData(cacheCovers: $cacheCovers, previewSize: $previewSize, fullSize: $fullSize)";
}
