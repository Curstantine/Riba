// ignore_for_file: public_member_api_docs, sort_constructors_first
import "dart:developer";

import "package:hive/hive.dart";
import "package:riba/settings/settings.dart";

class CachingSettings extends SettingsController<CachingSettingsData> {
  @override
  final String id = "caching";

  @override
  late final Box box;

  @override
  CachingSettingsData get defaultValue => const CachingSettingsData(cacheCovers: true);

  @override
  Future<void> init() async {
    box = await Hive.openBox(id);
  }

  @override
  CachingSettingsData get() {
    return CachingSettingsData(
      cacheCovers: box.get("cacheCovers", defaultValue: defaultValue.cacheCovers),
    );
  }

  @override
  void save(CachingSettingsData data) {
    log("Saving caching settings: $data", name: "CachingSettings");
    box.put("cacheCovers", data.cacheCovers);
  }
}

class CachingSettingsData {
  final bool cacheCovers;

  const CachingSettingsData({required this.cacheCovers});

  CachingSettingsData copyWith({bool? cacheCovers}) {
    return CachingSettingsData(
      cacheCovers: cacheCovers ?? this.cacheCovers,
    );
  }

  @override
  String toString() {
    return "CachingSettingsData(cacheCovers: $cacheCovers)";
  }
}
