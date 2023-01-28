import "dart:io";

import "package:isar/isar.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:path_provider/path_provider.dart";
import "package:riba/repositories/local/cover_art.dart";
import "package:riba/repositories/local/manga.dart";
import "package:riba/repositories/local/author.dart";
import "package:riba/repositories/local/tag.dart";

Future<Isar> openDatabase({Directory? dir}) {
  return Isar.open([MangaSchema, AuthorSchema, CoverArtSchema, TagSchema], directory: dir?.path);
}

final isarPod = FutureProvider((ref) async {
  final dir = await getApplicationDocumentsDirectory();
  return openDatabase(dir: dir);
});
