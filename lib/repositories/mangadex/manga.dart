import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:riba/repositories/rate_limiter.dart';
import 'general.dart';
import 'mangadex.dart';

part 'manga.g.dart';

class MDMangaRepo {
  MDMangaRepo(this.client, this.rateLimiter) {
    rateLimiter.rates["/manga:GET"] = const Rate(4, Duration(seconds: 1));
  }

  final Client client;
  final RateLimiter rateLimiter;

  Future<MDResponse<EntityData<MangaAttributes>>> getManga(String id) async {
    await rateLimiter.wait("/manga:GET");
    final response = await http.get(MangaDex.url.resolve("/manga/$id"));
    return MDResponse.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
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
