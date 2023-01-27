import "dart:convert";

import "package:http/http.dart";
import "package:isar/isar.dart";
import "package:riba/repositories/local/localization.dart";
import "package:riba/repositories/local/manga.dart";
import "package:riba/repositories/rate_limiter.dart";
import "package:riba/utils/hash.dart";

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

  Future<Manga> getManga(String id) async {
    final inDB = await database.manga.get(fastHash(id));
    if (inDB != null) return inDB;

    await rateLimiter.wait("/manga:GET");
    final reqUrl = url.addPathSegment(id).setParameter("includes[]", includes);
    final request = await client.get(reqUrl.toUri());

    final response = MDMangaEntity.fromJson(jsonDecode(request.body));
    final manga = response.data.toManga();

    if (response.result == "ok") insertMeta(response, manga);
    return manga;
  }

  void insertMeta(MDMangaEntity response, Manga manga) {
    final authorRels = response.data.relationships.ofType(EntityType.author) +
        response.data.relationships.ofType(EntityType.artist);

    database.writeTxn(() async {
      database.manga.put(manga);
    });
  }
}

class MangaAttributes {
  final Map<String, String> title;
  final List<Map<String, String>> altTitles;
  final Map<String, String> description;
  final String originalLanguage;
  final List<MDResponseData<TagAttributes>> tags;

  const MangaAttributes({
    required this.title,
    required this.altTitles,
    required this.description,
    required this.tags,
    required this.originalLanguage,
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
    );
  }
}

extension ToManga on MDResponseData<MangaAttributes> {
  Manga toManga() {
    return Manga(
      id: id,
      titles: Localizations.fromMap(attributes.title),
      altTitles: attributes.altTitles.map(Localizations.fromMap).toList(),
      description: Localizations.fromMap(attributes.description),
      authors: relationships.ofType(EntityType.author).map((e) => e.id).toList(),
      artists: relationships.ofType(EntityType.artist).map((e) => e.id).toList(),
      tags: attributes.tags.map((e) => e.id).toList(),
      originalLocale: Locale.fromJsonValue(attributes.originalLanguage),
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
