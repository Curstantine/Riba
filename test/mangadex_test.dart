import "dart:developer";
import "dart:io";

import "package:flutter_test/flutter_test.dart";
import "package:isar/isar.dart";
import "package:logging/logging.dart";
import "package:riba/repositories/database.dart";
import "package:riba/repositories/local/cover_art.dart";
import "package:riba/repositories/mangadex.dart";
import "package:riba/repositories/mangadex/chapter.dart";
import "package:riba/repositories/mangadex/cover_art.dart";
import "package:riba/repositories/mangadex/manga.dart";
import "package:riba/repositories/mangadex/models/manga.dart";
import "package:riba/repositories/mangadex/utils/service.dart";
import "package:riba/utils/logging.dart";

import "constants.dart";

void main() async {
  await Isar.initializeIsarCore(download: true);
  Logging.init();

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
      final manga = await mangaDex.manga.getMany(
        overrides: MangaDexMangaQueryFilter(ids: mangaIds),
      );

      // MangaIds contain a pornographic title, so the resolved list will be -1
      expect(manga.length, mangaIds.length - 1);

      final withRatingFilters = await MangaDex.instance.manga.getMany(
        overrides: MangaDexMangaQueryFilter(ids: mangaIds, contentRatings: [
          MangaContentRating.safe,
          MangaContentRating.suggestive,
          MangaContentRating.erotica,
          MangaContentRating.pornographic,
        ]),
      );

      expect(withRatingFilters.length, mangaIds.length);
    });
  });

  group("MangaDex.Chapter", () {
    test("Chapter.getMany", () async {
      final chapters = await mangaDex.chapter.getMany(
        overrides: MangaDexChapterQueryFilter(ids: chapterIds),
      );
      expect(chapters, isNotEmpty);
    });
    test("Chapter.getMany with mangaId", () async {
      final chapters = await mangaDex.chapter.getMany(
        overrides: MangaDexChapterQueryFilter(mangaId: mangaId),
      );
      expect(chapters, isNotEmpty);
    });
  });

  group("MangaDex.CoverArt", () {
    test("CoverArt.getFileName", () {
      final file = coverFile.split(".");
      final name = file.first;
      final extension = ImageFileType.fromExtension(file.last);

      final original = mangaDex.cover.getFileName(name, CoverSize.original, extension);
      final medium = mangaDex.cover.getFileName(name, CoverSize.medium, extension);
      final small = mangaDex.cover.getFileName(name, CoverSize.small, extension);

      expect(original, coverFile);
      expect(medium, "$coverFile.512.jpg");
      expect(small, "$coverFile.256.jpg");
    });
    test("CoverArt.getMany", () async {
      final covers = await mangaDex.cover.getMany(
        overrides: MangaDexCoverQueryFilter(ids: [coverId]),
      );
      expect(covers.length, 1);
    });
    test("CoverArt.getMany with mangaId", () async {
      final covers = await mangaDex.cover.getMany(
        overrides: MangaDexCoverQueryFilter(mangaId: mangaId),
      );
      expect(covers.length, 1);
    });
    test("CoverArt.getImage", () async {
      final res = await mangaDex.cover.getMany(overrides: MangaDexCoverQueryFilter(ids: [coverId]));
      final coverTemp = res.values.first;
      final cover = await mangaDex.cover.getImage(mangaId, coverTemp.cover);

      final mediumCover = await mangaDex.cover.getImage(
        mangaId,
        coverTemp.cover,
        size: CoverSize.medium,
      );

      final smallCover = await mangaDex.cover.getImage(
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
  group("MangaDex.Group", () {
    test("Group.getSimpleMany", () async {
      final groups = await mangaDex.group
          .getWithSingleConstraint(overrides: MangaDexGenericQueryFilter(ids: groupIds));
      expect(groups, isNotNull);
      expect(groups.length, groupIds.length);
    });
  });
}
