import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';
import 'general.dart';

part 'manga.g.dart';

class MDMangaRepo {
  final url = Uri.https("api.mangadex.org");

  Future<MDResponse<EntityData<MangaAttributes>>> getManga(String id) async {
    final response = await http.get(url.resolve("/manga/$id"));
    return MDResponse.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }
}

@JsonSerializable()
class MangaAttributes {
  final Map<String, String?> titles;
  final Map<String, String?> description;
  final List<Map<String, String?>> authors;
  final String originalLanguage;

  const MangaAttributes({
    required this.titles,
    required this.description,
    required this.authors,
    required this.originalLanguage,
  });
  factory MangaAttributes.fromJson(Map<String, dynamic> json) => _$MangaAttributesFromJson(json);
}
