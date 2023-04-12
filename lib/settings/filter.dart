// ignore_for_file: public_member_api_docs, sort_constructors_first
import "package:isar/isar.dart";
import "package:riba/utils/hash.dart";

part "filter.g.dart";

@Collection(accessor: "mangaFilterSettings")
class MangaFilterSettings {
  final String id;
  Id get isarId => fastHash(id);

  late List<String> excludedGroupIds;

  bool get isDefault => excludedGroupIds.isEmpty;

  MangaFilterSettings({
    required this.id,
    required this.excludedGroupIds,
  });
}
