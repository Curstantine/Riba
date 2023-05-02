import "package:isar/isar.dart";
import "package:riba/repositories/mangadex/models/custom_list.dart";
import "package:riba/utils/hash.dart";

part "custom_list.g.dart";

@collection
class CustomList {
  late String id;
  Id get isarId => fastHash(id);

  late String name;
  @Enumerated(EnumType.ordinal)
  late CustomListVisibility visibility;

  late String userId;
  late List<String> mangaIds;

  late int version;

  CustomList({
    required this.id,
    required this.name,
    required this.userId,
    required this.mangaIds,
    required this.version,
    required this.visibility,
  });

  /// Checks if the given [CustomList] has the same [id] and the [version] as this.
  bool isLooselyEqual(CustomList other) {
    return id == other.id && version == other.version;
  }

  @override
  // ignore: hash_and_equals
  operator ==(Object other) {
    throw UnimplementedError();
  }
}
