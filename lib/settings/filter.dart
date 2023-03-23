// ignore_for_file: public_member_api_docs, sort_constructors_first
import "package:hive/hive.dart";
import "package:riba/settings/settings.dart";
import "package:riba/utils/constants.dart";

part "filter.g.dart";

class FilterSettings extends SettingsController<FilterSettingsData> {
  static final FilterSettings instance = Settings.instance.filter;

  @override
  final String id = "filter";

  @override
  late final Box box;

  /// Box containing all the filters needed to filter out data related to a specific manga.
  /// e.g. excluded groups, and etc.
  ///
  /// The key is the manga ID.
  late final LazyBox<MangaFilterData> mangaFilters;

  @override
  FilterSettingsData get defaultValue => const FilterSettingsData();

  @override
  Future<void> init() async {
    Hive.registerAdapter(MangaFilterDataAdapter());

    final futures = await Future.wait([
      Hive.openBox(id),
      Hive.openLazyBox<MangaFilterData>(FilterSettingKeys.mangaFilters),
    ]);

    box = futures[0] as Box;
    mangaFilters = futures[1] as LazyBox<MangaFilterData>;
  }
}

class FilterSettingKeys {
  static const String mangaFilters = "mangaFilters";
}

class FilterSettingsData {
  const FilterSettingsData();
}

@HiveType(typeId: TypeAdapterIds.mangaFilterAdapter)
class MangaFilterData extends HiveObject {
  @HiveField(0)
  late List<String> excludedGroupIds;

  MangaFilterData();

  factory MangaFilterData.defaults({List<String> excludedGroupIds = const []}) =>
      MangaFilterData()..excludedGroupIds = excludedGroupIds;

  /// Returns whether this filter is the same as default.
  bool get isDefault => excludedGroupIds.isEmpty;

  MangaFilterData copyWith({List<String>? excludedGroupIds}) {
    return MangaFilterData.defaults(
      excludedGroupIds: excludedGroupIds ?? this.excludedGroupIds,
    );
  }
}
