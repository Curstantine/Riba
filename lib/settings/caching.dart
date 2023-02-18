import "package:hive/hive.dart";
import "package:riba/settings/settings.dart";

class CachingSettingsController extends SettingsController<CachingSettingsData> {
  @override
  final String id = "caching";

  @override
  late final Box box;

  @override
  CachingSettingsData get defaultValue => CachingSettingsData(cacheCovers: true);

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
    box.put("cacheCovers", data.cacheCovers);
  }
}

class CachingSettingsData {
  final bool cacheCovers;

  CachingSettingsData({required this.cacheCovers});
}
