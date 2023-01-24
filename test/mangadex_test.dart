import "package:isar/isar.dart";
import "package:flutter_test/flutter_test.dart";
import "package:riba/repositories/local/manga.dart";
import "package:riba/repositories/mangadex/mangadex.dart";

void main() async {
  await Isar.initializeIsarCore(download: true);

  final database = await Isar.open([MangaSchema]);
  final mangaDex = MangaDex(database: database);

  test("MangaDex.getManga", () async {
    final manga = await mangaDex.manga.getManga("f9c33607-9180-4ba6-b85c-e4b5faee7192");
    expect(manga.id, "f9c33607-9180-4ba6-b85c-e4b5faee7192");
  });
}
