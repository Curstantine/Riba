// ignore_for_file: public_member_api_docs, sort_constructors_first
import "package:isar/isar.dart";
import "package:riba/utils/hash.dart";
import "localization.dart";

part "manga.g.dart";

/// Manga model to be stored in the local database.
///
/// ### Note
/// This model doesn't implement an eq operator, as it is impossible to do that
/// without losing performance. Instead, use the [isLooselyEqual] method.
@Collection(accessor: "manga")
class Manga {
  late String id;
  Id get isarId => fastHash(id);

  late Localizations titles;
  late Localizations description;
  late List<Localizations> altTitles;
  late List<String> authors;
  late List<String> artists;
  late List<String> tags;
  late List<String> covers;
  late String? usedCover;
  late Locale originalLocale;
  late int version;

  Manga({
    required this.id,
    required this.titles,
    required this.description,
    required this.altTitles,
    required this.authors,
    required this.artists,
    required this.tags,
    required this.covers,
    required this.usedCover,
    required this.originalLocale,
    required this.version,
  });

  /// Checks if the given [Manga] has the same [id] and the [version] as this.
  bool isLooselyEqual(Manga other) {
    return id == other.id && version == other.version;
  }

  @override
  // ignore: hash_and_equals
  operator ==(Object other) {
    throw UnimplementedError();
  }
}
