import "package:isar/isar.dart";
import "package:riba/repositories/mangadex/models/manga.dart";
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

  @Index(type: IndexType.hashElements)
  late List<String> authorIds;

  @Index(type: IndexType.hashElements)
  late List<String> artistIds;

  @Index(type: IndexType.hashElements)
  late List<String> tagsIds;

  /// The cover id defaulted by the provider.
  late String? defaultCoverId;

  /// The cover id preferred by the user.
  late String? preferredCoverId;

  late int version;

  @Enumerated(EnumType.ordinal)
  late Language originalLanguage;

  @Enumerated(EnumType.ordinal)
  late MangaStatus status;

  @Enumerated(EnumType.ordinal)
  late MangaPublicationDemographic publicationDemographic;

  @Enumerated(EnumType.ordinal)
  late ContentRating contentRating;

  Manga({
    required this.id,
    required this.titles,
    required this.description,
    required this.altTitles,
    required this.authorIds,
    required this.artistIds,
    required this.tagsIds,
    required this.defaultCoverId,
    required this.preferredCoverId,
    required this.originalLanguage,
    required this.version,
    required this.status,
    required this.publicationDemographic,
    required this.contentRating,
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
