import "dart:convert";
import "package:http/http.dart" as http;
import "package:http/http.dart";
import "package:isar/isar.dart";
import "package:json_annotation/json_annotation.dart";
import "package:riba/repositories/local/localization.dart";
import "package:riba/repositories/local/manga.dart";
import "package:riba/repositories/mangadex/tag.dart";
import "package:riba/repositories/rate_limiter.dart";
import "package:riba/utils/hash.dart";
import "general.dart";
import "mangadex.dart";

part "manga.g.dart";

typedef MDMangaEntity = MDEntityResponse<MangaAttributes>;
typedef MDMangaCollection = MDCollectionResponse<MangaAttributes>;

class MDMangaRepo {
  MDMangaRepo(this.client, this.rateLimiter, this.database) {
    rateLimiter.rates["/manga:GET"] = const Rate(4, Duration(seconds: 1));
  }

  final Client client;
  final RateLimiter rateLimiter;
  final Isar database;

  Future<Manga> getManga(String id) async {
    final inDB = await database.manga.get(fastHash(id));
    if (inDB != null) return inDB;

    await rateLimiter.wait("/manga:GET");
    final request = await http.get(MangaDex.url.resolve("/manga/$id"));
    final response = MDMangaEntity.fromJson(jsonDecode(request.body));
    final manga = response.data.toManga();

    if (response.result == "ok") {
      database.writeTxn(() => database.manga.put(manga));
    }

    return manga;
  }
}

@JsonSerializable(createToJson: false)
class MangaAttributes {
  final Map<String, String> title;
  final List<Map<String, String>> altTitles;
  final Map<String, String> description;
  final String originalLanguage;

  @JsonKey(fromJson: TagAttributes.fromList)
  final List<MDResponseData<TagAttributes>> tags;

  const MangaAttributes({
    required this.title,
    required this.altTitles,
    required this.description,
    required this.tags,
    required this.originalLanguage,
  });

  factory MangaAttributes.fromJson(Map<String, dynamic> json) => _$MangaAttributesFromJson(json);
}

extension ToManga on MDResponseData<MangaAttributes> {
  Manga toManga() {
    return Manga(
      id: id,
      titles: attributes.title.toLocalizations(),
      altTitles: attributes.altTitles.map((e) => e.toLocalizations()).toList(),
      description: attributes.description.toLocalizations(),
      authors: relationships.ofType(EntityType.author).map((e) => e.id).toList(),
      artists: relationships.ofType(EntityType.artist).map((e) => e.id).toList(),
      tags: attributes.tags.map((e) => e.id).toList(),
      originalLocale: attributes.originalLanguage.toLocale(),
    );
  }
}
