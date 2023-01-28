import "package:isar/isar.dart";
import "package:flutter_test/flutter_test.dart";
import "package:riba/repositories/database.dart";
import "package:riba/repositories/mangadex/mangadex.dart";

void main() async {
  await Isar.initializeIsarCore(download: true);

  final database = await openDatabase();
  final mangaDex = MangaDex(database: database, userAgent: "Riba/test-runner");

  test("MangaDex.getManga", () async {
    final mangaData = await mangaDex.manga.getManga("f9c33607-9180-4ba6-b85c-e4b5faee7192");
    expect(mangaData.manga.id, "f9c33607-9180-4ba6-b85c-e4b5faee7192");

    final dbMangaData = await mangaDex.manga.getManga(mangaData.manga.id);
    expect(dbMangaData.manga.id, mangaData.manga.id);

    database.writeTxn(() async => await database.clear());
  });
}
