import "dart:developer";
import "dart:io";

import "package:flutter_test/flutter_test.dart";
import "package:isar/isar.dart";
import "package:logging/logging.dart";
import "package:riba/repositories/database.dart";
import "package:riba/repositories/local/cover_art.dart";
import "package:riba/repositories/local/localization.dart";
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
    test("Manga.aggregate", () async {
      final aggregated = await mangaDex.manga.aggregate(mangaId, translatedLanguages: [Locale.en]);
      expect(aggregated, isNotNull);
    });
  });

  group("MangaDex.Chapter", () {
    test("Chapter.getMany", () {
      final chapters = mangaDex.chapter.getMany(chapterIds);
      expect(chapters, isNotNull);
    });
  });

  group("MangaDex.CoverArt", () {
    test("CoverArt.getFileName", () {
      final file = coverFile.split(".");
      final name = file.first;
      final extension = ImageFileType.fromExtension(file.last);

      final original = mangaDex.covers.getFileName(name, CoverSize.original, extension);
      final medium = mangaDex.covers.getFileName(name, CoverSize.medium, extension);
      final small = mangaDex.covers.getFileName(name, CoverSize.small, extension);

      expect(original, coverFile);
      expect(medium, "$coverFile.512.jpg");
      expect(small, "$coverFile.256.jpg");
    });
    test("CoverArt.getMany", () async {
      final covers = await mangaDex.covers.getMany([coverId]);

      expect(covers, isNotNull);
      expect(covers.length, 1);
    });
    test("CoverArt.getForManga", () async {
      final covers = await mangaDex.covers.getForManga(mangaId);
      expect(covers, isNotEmpty);
    });
    test("CoverArt.getImage", () async {
      final coverTemp = (await mangaDex.covers.getMany([coverId])).values.first;
      final cover = await mangaDex.covers.getImage(mangaId, coverTemp.cover);

      final mediumCover = await mangaDex.covers.getImage(
        mangaId,
        coverTemp.cover,
        size: CoverSize.medium,
      );

      final smallCover = await mangaDex.covers.getImage(
        mangaId,
        coverTemp.cover,
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
