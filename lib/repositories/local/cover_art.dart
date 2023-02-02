import "package:isar/isar.dart";
import "package:riba/utils/hash.dart";
import "localization.dart";

part "cover_art.g.dart";

/// CoverArt model to be stored in the local database.
///
/// ### Note
/// This model doesn't implement an eq operator, as it is impossible to do that
/// without losing performance. Instead, use the [isLooselyEqual] method.
@Collection(accessor: "covers")
class CoverArt {
  late String id;
  Id get isarId => fastHash(id);

  late String? volume;
  late String fileName;
  late String? description;
  late Locale? locale;
  late DateTime createdAt;
  late DateTime updatedAt;
  late int version;

  CoverArt({
    required this.id,
    required this.volume,
    required this.fileName,
    required this.description,
    required this.locale,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
  });

  /// Checks if the given [CoverArt] has the same [id] and the [version] as this.
  bool isLooselyEqual(CoverArt other) {
    return id == other.id && version == other.version;
  }

  @override
  // ignore: hash_and_equals
  operator ==(Object other) {
    throw UnimplementedError();
  }
}
