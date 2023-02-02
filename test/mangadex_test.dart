import "dart:developer";
import "dart:io";

import "package:isar/isar.dart";
import "package:flutter_test/flutter_test.dart";
import "package:logging/logging.dart";
import "package:riba/repositories/database.dart";
import "package:riba/repositories/mangadex/cover_art.dart";
import "package:riba/repositories/mangadex/mangadex.dart";

void main() async {
  await Isar.initializeIsarCore(download: true);

  final database = await openDatabase();
  final tempDirectory = Directory("./tmp/mangadex");
  final mangaDex = MangaDex(
    database: database,
    userAgent: "Riba/test-runner",
    directory: tempDirectory,
  );

  tearDown(() async {
    await database.writeTxn(() async => await database.clear());
    try {
      // await tempDirectory.delete(recursive: true);
    } on FileSystemException {
      log("Failed to delete the temp directory", name: "MangaDexTest", level: Level.SHOUT.value);
    }
  });

  const mangaId = "f9c33607-9180-4ba6-b85c-e4b5faee7192";
  const coverFile = "c18da525-e34f-4128-a696-4477b6ce6827.png";

  group("MangaDex.Manga", () {
    test("Manga.getManga", () async {
      final mangaData = await mangaDex.manga.getManga(mangaId);
      expect(mangaData.manga.id, mangaId);

      final dbMangaData = await mangaDex.manga.getManga(mangaData.manga.id);
      expect(dbMangaData.manga.id, mangaData.manga.id);
    });
  });

  group("MangaDex.CoverArt", () {
    test("CoverArt.getFileName", () {
      final original = mangaDex.covers.getFileName(coverFile, CoverSize.original);
      final medium = mangaDex.covers.getFileName(coverFile, CoverSize.medium);
      final small = mangaDex.covers.getFileName(coverFile, CoverSize.small);

      expect(original, coverFile);
      expect(medium, "$coverFile.512.jpg");
      expect(small, "$coverFile.256.jpg");
    });
    test("CoverArt.getCoverArt", () async {
      final cover = await mangaDex.covers.getCoverArt(mangaId, coverFile);

      final mediumCover = await mangaDex.covers.getCoverArt(
        mangaId,
        coverFile,
        size: CoverSize.medium,
      );

      final smallCover = await mangaDex.covers.getCoverArt(
        mangaId,
        coverFile,
        size: CoverSize.small,
      );

      expect(cover, isNotNull);
      expect(cover.existsSync(), true);
      expect(cover.statSync().type, FileSystemEntityType.file);

      expect(mediumCover, isNotNull);
      expect(mediumCover.existsSync(), true);
      expect(mediumCover.statSync().type, FileSystemEntityType.file);

      expect(smallCover, isNotNull);
      expect(smallCover.existsSync(), true);
      expect(smallCover.statSync().type, FileSystemEntityType.file);
    });
  });
}
