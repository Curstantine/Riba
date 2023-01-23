import "dart:convert";
import "package:http/http.dart" as http;
import "package:http/http.dart";
import "package:isar/isar.dart";
import "package:json_annotation/json_annotation.dart";
import "package:riba/repositories/local/localization.dart";
import "package:riba/repositories/local/manga.dart";
import "package:riba/repositories/rate_limiter.dart";
import "general.dart";
import "mangadex.dart";

part "manga.g.dart";

class MDMangaRepo {
  MDMangaRepo(this.client, this.rateLimiter, this.database) {
    rateLimiter.rates["/manga:GET"] = const Rate(4, Duration(seconds: 1));
  }

  final Client client;
  final RateLimiter rateLimiter;
  final Isar database;

  Future<EntityData<MangaAttributes>> getManga(String id) async {
    await rateLimiter.wait("/manga:GET");
    final request = await http.get(MangaDex.url.resolve("/manga/$id"));
    final response = MDResponse.fromJson(jsonDecode(request.body) as Map<String, dynamic>);
    final data = response.data as EntityData<MangaAttributes>;

    if (response.result == "ok") {
      final manga = data.toManga();
      database.writeTxn(() => database.manga.put(manga));
    }

    return data;
  }
}

@JsonSerializable()
class MangaAttributes {
  final Map<String, String> title;
  final List<Map<String, String>> altTitles;
  final Map<String, String> description;
  final String originalLanguage;

  const MangaAttributes({
    required this.title,
    required this.altTitles,
    required this.description,
    required this.originalLanguage,
  });
  factory MangaAttributes.fromJson(Map<String, dynamic> json) => _$MangaAttributesFromJson(json);
}

extension ToManga on EntityData<MangaAttributes> {
  Manga toManga() {
    return Manga(
      id: id,
      titles: attributes.title.toLocalizations(),
      altTitles: attributes.altTitles.map((e) => e.toLocalizations()).toList(),
      description: attributes.description.toLocalizations(),
      authors: relationships.ofType(EntityType.author).map((e) => e.id).toList(),
      originalLocale: attributes.originalLanguage.toLocale(),
    );
  }
}
