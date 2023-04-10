import "package:json_annotation/json_annotation.dart";
import "package:riba/repositories/local/localization.dart";
import "package:riba/repositories/local/manga.dart";
import "package:riba/repositories/mangadex/utils/enum.dart";
import "package:riba/repositories/runtime/manga.dart";
import "package:riba/repositories/utils/exception.dart";

import "author.dart";
import "cover_art.dart";
import "general.dart";
import "relationship.dart";
import "tag.dart";

part "manga.g.dart";

typedef MangaEntity = MDEntityResponse<MangaAttributes>;
typedef MangaCollection = MDCollectionResponse<MangaAttributes>;

@JsonSerializable(createToJson: false)
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

  factory MangaAttributes.fromJson(Map<String, dynamic> source) =>
      _$MangaAttributesFromJson(source);
}

// CAUTION: DO NOT CHANGE THE ORDER OF THE ENUM
@JsonEnum(alwaysCreate: true)
enum MangaStatus implements TwoWayEnumSerde {
  ongoing,
  completed,
  hiatus,
  cancelled;

  @override
  factory MangaStatus.fromJsonValue(String source) => $enumDecode(_$MangaStatusEnumMap, source);

  @override
  String toJson() => _$MangaStatusEnumMap[this]!;

  @override
  String asHumanReadable() {
    switch (this) {
      case MangaStatus.ongoing:
        return "Ongoing";
      case MangaStatus.completed:
        return "Completed";
      case MangaStatus.hiatus:
        return "Hiatus";
      case MangaStatus.cancelled:
        return "Cancelled";
    }
  }
}

// CAUTION: DO NOT CHANGE THE ORDER OF THE ENUM
@JsonEnum(alwaysCreate: true)
enum MangaPublicationDemographic implements TwoWayEnumSerde {
  unknown,
  shounen,
  shoujo,
  josei,
  seinen;

  @override
  factory MangaPublicationDemographic.fromJsonValue(String source) =>
      $enumDecode(_$MangaPublicationDemographicEnumMap, source);

  @override
  String toJson() => _$MangaPublicationDemographicEnumMap[this]!;

  @override
  String asHumanReadable() {
    switch (this) {
      case MangaPublicationDemographic.unknown:
        return "Unknown";
      case MangaPublicationDemographic.shounen:
        return "Shounen";
      case MangaPublicationDemographic.shoujo:
        return "Shoujo";
      case MangaPublicationDemographic.josei:
        return "Josei";
      case MangaPublicationDemographic.seinen:
        return "Seinen";
    }
  }
}

// CAUTION: DO NOT CHANGE THE ORDER OF THE ENUM
@JsonEnum(alwaysCreate: true)
enum MangaContentRating implements TwoWayEnumSerde {
  safe,
  suggestive,
  erotica,
  pornographic;

  @override
  factory MangaContentRating.fromJsonValue(String source) =>
      $enumDecode(_$MangaContentRatingEnumMap, source);

  @override
  String toJson() => _$MangaContentRatingEnumMap[this]!;

  @override
  String asHumanReadable() {
    switch (this) {
      case MangaContentRating.safe:
        return "Safe";
      case MangaContentRating.suggestive:
        return "Suggestive";
      case MangaContentRating.erotica:
        return "Erotica";
      case MangaContentRating.pornographic:
        return "Pornographic";
    }
  }
}

extension ToManga on MDResponseData<MangaAttributes> {
  /// Converts the response data into a [Manga] object.
  ///
  /// Will throw a [LanguageNotSupportedException] if the [Manga.originalLanguage] is not supported.
  Manga toManga({String? preferredCoverId}) {
    final covers = relationships.ofType<CoverArtAttributes>(EntityType.coverArt).map((e) => e.id);
    final usedCover = preferredCoverId == null
        ? covers.first
        : covers.firstWhere((e) => e == preferredCoverId, orElse: () => covers.first);

    return Manga(
      id: id,
      titles: Localizations.fromMap(attributes.title),
      altTitles: attributes.altTitles.map(Localizations.fromMap).toList(),
      description: Localizations.fromMap(attributes.description),
      authorIds: relationships.ofType(EntityType.author).map((e) => e.id).toList(),
      artistIds: relationships.ofType(EntityType.artist).map((e) => e.id).toList(),
      defaultCoverId: usedCover,
      preferredCoverId: usedCover != preferredCoverId ? null : preferredCoverId,
      tagsIds: attributes.tags.map((e) => e.id).toList(),
      originalLanguage: Language.fromIsoCode(attributes.originalLanguage),
      contentRating: attributes.contentRating,
      publicationDemographic:
          attributes.publicationDemographic ?? MangaPublicationDemographic.unknown,
      status: attributes.status,
      version: attributes.version,
    );
  }

  /// Converts the response data into a [Manga] object.
  ///
  /// Will throw a [LanguageNotSupportedException] if the [Manga.originalLanguage] is not supported.
  InternalMangaData toInternalMangaData({String? usedCoverId}) {
    return InternalMangaData(
      manga: toManga(preferredCoverId: usedCoverId),
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
