import "package:isar/isar.dart";
import "package:riba/repositories/mangadex/models/tag.dart";
import "package:riba/utils/hash.dart";

import "localization.dart";

part "tag.g.dart";

/// Tag model to be stored in the local database.
///
/// ### Note
/// This model doesn't implement an eq operator, as it is impossible to do that
/// without losing performance. Instead, use the [isLooselyEqual] method.
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

  /// Checks if the given [Tag] has the same [id] and the [version] as this.
  bool isLooselyEqual(Tag other) {
    return id == other.id && version == other.version;
  }

  @override
  // ignore: hash_and_equals
  operator ==(Object other) {
    throw UnimplementedError();
  }
}
