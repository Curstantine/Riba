import "package:riba/repositories/local/localization.dart";
import "package:riba/repositories/local/manga.dart";
import "package:riba/repositories/mangadex/utils/enum.dart";
import "package:riba/repositories/runtime/manga.dart";

import "author.dart";
import "cover_art.dart";
import "general.dart";
import "relationship.dart";
import "tag.dart";

typedef MangaEntity = MDEntityResponse<MangaAttributes>;
typedef MangaCollection = MDCollectionResponse<MangaAttributes>;

class MangaAttributes {
  final Map<String, String> title;
  final List<Map<String, String>> altTitles;
  final Map<String, String> description;
  final String originalLanguage;
  final MangaPublicationDemographic? publicationDemographic;
  final MangaStatus status;
  final MangaContentRating contentRating;
  final List<MDResponseData<TagAttributes>> tags;
  final int version;

  const MangaAttributes({
    required this.title,
    required this.altTitles,
    required this.description,
    required this.tags,
    required this.originalLanguage,
    required this.publicationDemographic,
    required this.status,
    required this.contentRating,
    required this.version,
  });

  factory MangaAttributes.fromMap(Map<String, dynamic> map) {
    final demographic = map["publicationDemographic"] as String?;

    return MangaAttributes(
      title: (map["title"] as Map<String, dynamic>).cast(),
      altTitles: (map["altTitles"] as List)
          .map((e) => (e as Map<String, dynamic>).cast<String, String>())
          .toList(),
      description: (map["description"] as Map<String, dynamic>).cast(),
      originalLanguage: map["originalLanguage"] as String,
      publicationDemographic:
          demographic == null ? null : MangaPublicationDemographic.fromJsonValue(demographic),
      status: MangaStatus.fromJsonValue(map["status"] as String),
      contentRating: MangaContentRating.fromJsonValue(map["contentRating"] as String),
      tags: (map["tags"] as List<dynamic>)
          .map((e) => MDResponseData<TagAttributes>.fromMap(e))
          .toList(),
      version: map["version"] as int,
    );
  }
}

// CAUTION: DO NOT CHANGE THE ORDER OF THE ENUM
enum MangaStatus implements TwoWayEnumSerde {
  ongoing,
  completed,
  hiatus,
  cancelled;

  static Map<String, MangaStatus> get jsonValues => {
        "ongoing": ongoing,
        "completed": completed,
        "hiatus": hiatus,
        "cancelled": cancelled,
      };

  String get humanReadable => name.substring(0, 1).toUpperCase() + name.substring(1);

  @override
  factory MangaStatus.fromJsonValue(String str) => jsonValues[str]!;

  @override
  String toJsonValue() => jsonValues.entries.firstWhere((e) => e.value == this).key;
}

// CAUTION: DO NOT CHANGE THE ORDER OF THE ENUM
enum MangaPublicationDemographic implements TwoWayEnumSerde {
  unknown,
  shounen,
  shoujo,
  josei,
  seinen;

  static Map<String, MangaPublicationDemographic> get jsonValues => {
        "shounen": shounen,
        "shoujo": shoujo,
        "josei": josei,
        "seinen": seinen,
      };

  String get humanReadable => name.substring(0, 1).toUpperCase() + name.substring(1);

  @override
  factory MangaPublicationDemographic.fromJsonValue(String str) => jsonValues[str]!;

  @override
  String toJsonValue() => jsonValues.entries.firstWhere((e) => e.value == this).key;
}

// CAUTION: DO NOT CHANGE THE ORDER OF THE ENUM
enum MangaContentRating implements TwoWayEnumSerde {
  safe,
  suggestive,
  erotica,
  pornographic;

  static Map<String, MangaContentRating> get jsonValues => {
        "safe": safe,
        "suggestive": suggestive,
        "erotica": erotica,
        "pornographic": pornographic,
      };

  String get humanReadable => name.substring(0, 1).toUpperCase() + name.substring(1);

  @override
  factory MangaContentRating.fromJsonValue(String str) => jsonValues[str]!;

  @override
  String toJsonValue() => jsonValues.entries.firstWhere((e) => e.value == this).key;
}

extension ToManga on MDResponseData<MangaAttributes> {
  Manga toManga({String? usedCoverId}) {
    final String usedCover = relationships
        .ofType<CoverArtAttributes>(EntityType.coverArt)
        .map((e) => e.id)
        .firstWhere((e) => usedCoverId != null ? e == usedCoverId : true, orElse: () => "");

    return Manga(
      id: id,
      titles: Localizations.fromMap(attributes.title),
      altTitles: attributes.altTitles.map(Localizations.fromMap).toList(),
      description: Localizations.fromMap(attributes.description),
      authorIds: relationships.ofType(EntityType.author).map((e) => e.id).toList(),
      artistIds: relationships.ofType(EntityType.artist).map((e) => e.id).toList(),
      usedCoverId: usedCover.isEmpty ? null : usedCover,
      tagsIds: attributes.tags.map((e) => e.id).toList(),
      originalLocale: Locale.fromJsonValue(attributes.originalLanguage),
      contentRating: attributes.contentRating,
      publicationDemographic:
          attributes.publicationDemographic ?? MangaPublicationDemographic.unknown,
      status: attributes.status,
      version: attributes.version,
    );
  }

  InternalMangaData toInternalMangaData({String? usedCoverId}) {
    return InternalMangaData(
      manga: toManga(usedCoverId: usedCoverId),
      authors: relationships
          .ofType<AuthorAttributes>(EntityType.author)
          .map((e) => e.toAuthor())
          .toList(),
      artists: relationships
          .ofType<AuthorAttributes>(EntityType.artist)
          .map((e) => e.toAuthor())
          .toList(),
      covers: relationships
          .ofType<CoverArtAttributes>(EntityType.coverArt)
          .map((e) => e.toCoverArt(id))
          .toList(),
      tags: attributes.tags.map((e) => e.toTag()).toList(),
    );
  }
}
