import "dart:convert";
import "dart:developer";

import "package:http/http.dart";
import "package:isar/isar.dart";
import "package:riba/repositories/local/author.dart";
import "package:riba/repositories/local/cover_art.dart";
import "package:riba/repositories/local/localization.dart";
import "package:riba/repositories/local/manga.dart";
import "package:riba/repositories/local/statistics.dart";
import "package:riba/repositories/local/tag.dart";
import "package:riba/repositories/mangadex/author.dart";
import "package:riba/repositories/mangadex/chapter.dart";
import "package:riba/repositories/rate_limiter.dart";
import "package:riba/repositories/runtime/manga.dart";
import "package:riba/utils/hash.dart";

import "cover_art.dart";
import "general.dart";
import "mangadex.dart";
import "relationship.dart";
import "statistics.dart";
import "tag.dart";

typedef MDMangaEntity = MDEntityResponse<MangaAttributes>;
typedef MDMangaCollection = MDCollectionResponse<MangaAttributes>;

class MDMangaRepo {
  final Client client;
  final RateLimiter rateLimiter;
  final Isar database;

  MDMangaRepo(this.client, this.rateLimiter, this.database) {
    rateLimiter.rates["/manga:GET"] = const Rate(4, Duration(seconds: 1));
    rateLimiter.rates["/statistics/manga:GET"] = const Rate(4, Duration(seconds: 1));
  }

  final url = MangaDex.url.copyWith(pathSegments: ["manga"]);
  final statisticUrl = MangaDex.url.copyWith(pathSegments: ["statistics", "manga"]);

  final includes = [
    EntityType.artist.toJsonValue(),
    EntityType.author.toJsonValue(),
    EntityType.coverArt.toJsonValue(),
  ];

  Future<MangaData> get(String id, {bool checkDB = true}) async {
    log("get($id, $checkDB)", name: "MDMangaRepo");

    if (checkDB) {
      final inDB = await database.manga.get(fastHash(id));
      if (inDB != null) return _collectMeta(inDB);
    }

    await rateLimiter.wait("/manga:GET");
    final reqUrl = url.copy().addPathSegment(id).setParameter("includes[]", includes);
    final request = await client.get(reqUrl.toUri());

    final response = MDMangaEntity.fromMap(jsonDecode(request.body), url: reqUrl);
    final internalMangaData = response.data.toInternalMangaData();
    _insertMeta(internalMangaData);

    return internalMangaData.toMangaData();
  }

  Future<Aggregated> aggregate(
    String mangaId, {
    List<Locale> translatedLanguages = const [],
  }) async {
    log("aggregate($mangaId, $translatedLanguages)", name: "MDMangaRepo");

    await rateLimiter.wait("/manga:GET");
    final reqUrl = url
        .copy()
        .addPathSegment(mangaId)
        .addPathSegment("aggregate")
        .setParameter("translatedLanguage[]", translatedLanguages.map((e) => e.code).toList());
    final request = await client.get(reqUrl.toUri());

    return Aggregated.fromJson(request.body);
  }

  /// Get multiple manga at once.
  Future<Map<String, MangaData>> getMany(List<String> ids, {bool checkDB = true}) async {
    log("getMany($ids, $checkDB)", name: "MDMangaRepo");

    final Map<String, MangaData?> mapped = {for (var e in ids) e: null};

    if (checkDB) {
      final inDB = await database.manga.getAll(ids.map((e) => fastHash(e)).toList());
      for (final manga in inDB) {
        if (manga == null) continue;
        mapped[manga.id] = await _collectMeta(manga);
      }
    }

    final missing = mapped.entries.where((e) => e.value == null).map((e) => e.key).toList();
    if (missing.isEmpty) return mapped.cast();

    // To go around the 100 limit, we split the request into multiple ones.
    while (missing.isNotEmpty) {
      await rateLimiter.wait("/manga:GET");
      final reqUrl = url
          .copy()
          .setParameter("ids[]", missing.take(100).toList())
          .setParameter("includes[]", includes)
          .setParameter("limit", 100);
      final request = await client.get(reqUrl.toUri());

      final response = MDMangaCollection.fromMap(jsonDecode(request.body), url: reqUrl);
      for (final data in response.data) {
        final internalMangaData = data.toInternalMangaData();
        _insertMeta(internalMangaData);
        mapped[data.id] = internalMangaData.toMangaData();
      }

      missing.removeWhere((e) => mapped[e] != null);
    }

    return mapped.cast();
  }

  Future<void> _insertMeta(InternalMangaData internalMangaData) async {
    await database.writeTxn(() async {
      await Future.wait([
        database.authors.putAll(internalMangaData.authors + internalMangaData.artists),
        database.covers.putAll(internalMangaData.covers),
        database.tags.putAll(internalMangaData.tags),
        database.manga.put(internalMangaData.manga),
      ]);
    });
  }

  Future<MangaData> _collectMeta(Manga manga) async {
    final data = await Future.wait([
      database.authors.getAll(manga.artists.map((e) => fastHash(e)).toList()),
      database.authors.getAll(manga.authors.map((e) => fastHash(e)).toList()),
      database.tags.getAll(manga.tags.map((e) => fastHash(e)).toList()),
      manga.usedCover != null
          ? database.covers.get(fastHash(manga.usedCover!))
          : Future.value(null),
    ]);

    return MangaData(
      manga: manga,
      authors: (data[0] as List<Author?>).cast(),
      artists: (data[1] as List<Author?>).cast(),
      tags: (data[2] as List<Tag?>).cast(),
      cover: data[3] as CoverArt?,
    );
  }

  Future<Statistics> getStatistics(String id, {bool checkDB = true}) async {
    log("getStatistics($id)", name: "MDMangaRepo");

    if (checkDB) {
      final inDB = await database.statistics.get(fastHash(id));
      if (inDB != null) return inDB;
    }

    await rateLimiter.wait("/statistics/manga:GET");
    final reqUrl = statisticUrl.copy().addPathSegment(id);
    final request = await client.get(reqUrl.toUri());

    final response = MDStatistics.fromMap(
      jsonDecode(request.body),
      type: EntityType.manga,
      url: reqUrl,
    );

    final statistic = response.statistics[id]!.toStatistics();
    database.writeTxn(() async => await database.statistics.put(statistic));

    return statistic;
  }
}

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
enum MangaStatus {
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

  factory MangaStatus.fromJsonValue(String str) {
    return jsonValues[str]!;
  }

  String get humanReadable => name.substring(0, 1).toUpperCase() + name.substring(1);
}

// CAUTION: DO NOT CHANGE THE ORDER OF THE ENUM
enum MangaPublicationDemographic {
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

  factory MangaPublicationDemographic.fromJsonValue(String str) {
    return jsonValues[str]!;
  }

  String get humanReadable => name.substring(0, 1).toUpperCase() + name.substring(1);
}

// CAUTION: DO NOT CHANGE THE ORDER OF THE ENUM
enum MangaContentRating {
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

  factory MangaContentRating.fromJsonValue(String str) {
    return jsonValues[str]!;
  }

  String get humanReadable => name.substring(0, 1).toUpperCase() + name.substring(1);
}

extension on MDResponseData<MangaAttributes> {
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
      authors: relationships.ofType(EntityType.author).map((e) => e.id).toList(),
      artists: relationships.ofType(EntityType.artist).map((e) => e.id).toList(),
      usedCover: usedCover.isEmpty ? null : usedCover,
      tags: attributes.tags.map((e) => e.id).toList(),
      originalLocale: Locale.fromJsonValue(attributes.originalLanguage),
      contentRating: attributes.contentRating,
      publicationDemographic:
          attributes.publicationDemographic ?? MangaPublicationDemographic.unknown,
      status: attributes.status,
      version: attributes.version,
    );
  }

  InternalMangaData toInternalMangaData() {
    return InternalMangaData(
      manga: toManga(),
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
