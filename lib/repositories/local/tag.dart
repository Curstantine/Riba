import "package:isar/isar.dart";
import "package:riba/repositories/local/localization.dart";
import "package:riba/repositories/mangadex/tag.dart";
import "package:riba/utils/hash.dart";

part "tag.g.dart";

@collection
class Tag {
  late String id;
  Id get isarId => fastHash(id);

  late Localizations name;
  late Localizations description;
  late int version;

  @Enumerated(EnumType.ordinal)
  late TagGroup group;

  Tag({
    required this.id,
    required this.name,
    required this.description,
    required this.group,
    required this.version,
  });
}
