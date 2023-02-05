import "dart:convert";
import "dart:developer";

import "package:http/http.dart";
import "package:isar/isar.dart";
import "package:riba/repositories/local/cover_art.dart";
import "package:riba/repositories/local/localization.dart";
import "package:riba/repositories/local/manga.dart";
import "package:riba/repositories/local/author.dart";
import "package:riba/repositories/local/tag.dart";
import "package:riba/repositories/mangadex/author.dart";
import "package:riba/repositories/rate_limiter.dart";
import "package:riba/repositories/runtime/manga.dart";
import "package:riba/utils/hash.dart";

import "cover_art.dart";
import "general.dart";
import "mangadex.dart";
import "relationship.dart";
import "tag.dart";

typedef MDMangaEntity = MDEntityResponse<MangaAttributes>;
typedef MDMangaCollection = MDCollectionResponse<MangaAttributes>;

class MDMangaRepo {
  final Client client;
  final RateLimiter rateLimiter;
  final Isar database;

  MDMangaRepo(this.client, this.rateLimiter, this.database) {
    rateLimiter.rates["/manga:GET"] = const Rate(4, Duration(seconds: 1));
  }

  final url = MangaDex.url.copyWith(pathSegments: ["manga"]);
  final includes = [
    EntityType.artist.toJsonValue(),
    EntityType.author.toJsonValue(),
    EntityType.coverArt.toJsonValue(),
  ];

  Future<MangaData> get(String id) async {
    log("get($id)", name: "MDMangaRepo");

    final inDB = await database.manga.get(fastHash(id));
    if (inDB != null) {
      final data = await Future.wait([
        database.authors.getAll(inDB.artists.map((e) => fastHash(e)).toList()),
        database.authors.getAll(inDB.authors.map((e) => fastHash(e)).toList()),
        database.tags.getAll(inDB.tags.map((e) => fastHash(e)).toList()),
        inDB.usedCover != null
            ? database.covers.get(fastHash(inDB.usedCover!))
            : Future.value(null),
      ]);

      return MangaData(
        manga: inDB,
        authors: (data[0] as List<Author?>).cast(),
        artists: (data[1] as List<Author?>).cast(),
        tags: (data[2] as List<Tag?>).cast(),
        cover: data[3] as CoverArt?,
      );
    }

    await rateLimiter.wait("/manga:GET");
    final reqUrl = url.asRef().addPathSegment(id).setParameter("includes[]", includes);
    final request = await client.get(reqUrl.toUri());

    final response = MDMangaEntity.fromJson(jsonDecode(request.body), url: reqUrl);

    final internalMangaData = InternalMangaData(
        manga: response.data.toManga(),
        authors: response.data.relationships
            .ofType<AuthorAttributes>(EntityType.author)
            .map((e) => e.toAuthor())
            .toList(),
        artists: response.data.relationships
            .ofType<AuthorAttributes>(EntityType.artist)
            .map((e) => e.toAuthor())
            .toList(),
        covers: response.data.relationships
            .ofType<CoverArtAttributes>(EntityType.coverArt)
            .map((e) => e.toCoverArt())
            .toList(),
        tags: response.data.attributes.tags.map((e) => e.toTag()).toList());

    insertMeta(internalMangaData);

    return internalMangaData.toMangaData();
  }

  void insertMeta(InternalMangaData internalMangaData) {
    database.writeTxn(() async {
      database.authors.putAll(internalMangaData.authors + internalMangaData.artists);
      database.covers.putAll(internalMangaData.covers);
      database.tags.putAll(internalMangaData.tags);
      database.manga.put(internalMangaData.manga);
    });
  }
}

class MangaAttributes {
  final Map<String, String> title;
  final List<Map<String, String>> altTitles;
  final Map<String, String> description;
  final String originalLanguage;
  final List<MDResponseData<TagAttributes>> tags;
  final int version;

  const MangaAttributes({
    required this.title,
    required this.altTitles,
    required this.description,
    required this.tags,
    required this.originalLanguage,
    required this.version,
  });

  factory MangaAttributes.fromMap(Map<String, dynamic> map) {
    return MangaAttributes(
      title: (map["title"] as Map<String, dynamic>).cast(),
      altTitles: (map["altTitles"] as List)
          .map((e) => (e as Map<String, dynamic>).cast<String, String>())
          .toList(),
      description: (map["description"] as Map<String, dynamic>).cast(),
      originalLanguage: map["originalLanguage"] as String,
      tags: (map["tags"] as List<dynamic>)
          .map((e) => MDResponseData<TagAttributes>.fromMap(e))
          .toList(),
      version: map["version"] as int,
    );
  }
}

extension ToManga on MDResponseData<MangaAttributes> {
  Manga toManga() {
    final covers = relationships.ofType<CoverArtAttributes>(EntityType.coverArt).map((e) => e.id);

    return Manga(
      id: id,
      titles: Localizations.fromMap(attributes.title),
      altTitles: attributes.altTitles.map(Localizations.fromMap).toList(),
      description: Localizations.fromMap(attributes.description),
      authors: relationships.ofType(EntityType.author).map((e) => e.id).toList(),
      artists: relationships.ofType(EntityType.artist).map((e) => e.id).toList(),
      covers: covers.toList(),
      usedCover: covers.isEmpty ? null : covers.first,
      tags: attributes.tags.map((e) => e.id).toList(),
      originalLocale: Locale.fromJsonValue(attributes.originalLanguage),
      version: attributes.version,
    );
  }
}

enum MangaStatus {
  ongoing,
  completed,
  hiatus,
  cancelled;

  static Map<MangaStatus, String> get jsonValues => {
        ongoing: "ongoing",
        completed: "completed",
        hiatus: "hiatus",
        cancelled: "cancelled",
      };

  factory MangaStatus.fromJsonValue(String str) {
    return jsonValues.entries.firstWhere((e) => e.value == str).key;
  }

  String getJsonValue() => jsonValues[this]!;
}

enum MangaPublicationDemographic {
  shounen,
  shoujo,
  josei,
  seinen;

  static Map<MangaPublicationDemographic, String> get jsonValues => {
        shounen: "shounen",
        shoujo: "shoujo",
        josei: "josei",
        seinen: "seinen",
      };

  factory MangaPublicationDemographic.fromJsonValue(String str) {
    return jsonValues.entries.firstWhere((e) => e.value == str).key;
  }

  String getJsonValue() => jsonValues[this]!;
}
