import "package:isar/isar.dart";
import "package:riba/utils/hash.dart";
import "localization.dart";

part "cover_art.g.dart";

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
}
