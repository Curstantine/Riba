import "package:isar/isar.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:path_provider/path_provider.dart";
import "package:riba/repositories/local/manga.dart";
import "package:riba/repositories/local/author.dart";
import "package:riba/repositories/local/tag.dart";

final isarPod = FutureProvider((ref) async {
  final dir = await getApplicationDocumentsDirectory();
  return Isar.open([MangaSchema, AuthorSchema, TagSchema], directory: dir.path);
});
