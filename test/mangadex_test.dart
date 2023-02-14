import "dart:io";
import "dart:developer";

import "package:isar/isar.dart";
import "package:flutter_test/flutter_test.dart";
import "package:logging/logging.dart";
import "package:riba/repositories/database.dart";
import "package:riba/repositories/mangadex/cover_art.dart";
import "package:riba/repositories/mangadex/mangadex.dart";

import "constants.dart";

void main() async {
  await Isar.initializeIsarCore(download: true);

  final tempDirectory = Directory("./tmp");
  final database = await Database.init(directory: tempDirectory, testing: true);
  final mangaDex = MangaDex.instance;

  tearDown(() async {
    await database.local.writeTxn(() async => await database.local.clear());
    try {
      await mangaDex.directory.delete(recursive: true);
    } on FileSystemException {
      log("Failed to delete the temp directory", name: "MangaDexTest", level: Level.SHOUT.value);
    }
  });

  group("MangaDex.Manga", () {
    test("Manga.get", () async {
      final mangaData = await mangaDex.manga.get(mangaId);
      expect(mangaData.manga.id, mangaId);

      final dbMangaData = await mangaDex.manga.get(mangaData.manga.id);
      expect(dbMangaData.manga.id, mangaData.manga.id);
    });
    test("Manga.getMany", () async {
      final manga = await mangaDex.manga.getMany(mangaIds);
      expect(manga.length, mangaIds.length);
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
    test("CoverArt.get", () async {
      final cover = await mangaDex.covers.get(mangaId, coverFile);

      final mediumCover = await mangaDex.covers.get(
        mangaId,
        coverFile,
        size: CoverSize.medium,
      );

      final smallCover = await mangaDex.covers.get(
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
