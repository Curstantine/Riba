// ignore_for_file: public_member_api_docs, sort_constructors_first
import "package:isar/isar.dart";
import "package:riba/utils/hash.dart";

import "settings.dart";

part "filter.g.dart";

@Collection(accessor: "mangaFilterSettings")
class MangaFilterSettings {
  static final ref = Settings.instance.database.mangaFilterSettings;

  /// The manga id
  final String id;
  Id get isarId => fastHash(id);

  late List<String> excludedGroupIds;

  bool get isDefault => excludedGroupIds.isEmpty;

  MangaFilterSettings({
    required this.id,
    required this.excludedGroupIds,
  });

  MangaFilterSettings copyWith({
    String? id,
    List<String>? excludedGroupIds,
  }) {
    return MangaFilterSettings(
      id: id ?? this.id,
      excludedGroupIds: excludedGroupIds ?? this.excludedGroupIds,
    );
  }
}
