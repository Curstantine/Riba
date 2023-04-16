import "dart:developer";
import "dart:io";

import "package:flutter_test/flutter_test.dart";
import "package:isar/isar.dart";
import "package:logging/logging.dart";
import "package:riba/repositories/local/models/cover_art.dart";
import "package:riba/repositories/local/models/localization.dart";
import "package:riba/repositories/mangadex/mangadex.dart";
import "package:riba/repositories/mangadex/models/manga.dart";
import "package:riba/repositories/mangadex/services/chapter.dart";
import "package:riba/repositories/mangadex/services/cover_art.dart";
import "package:riba/repositories/mangadex/services/manga.dart";
import "package:riba/repositories/mangadex/utils/service.dart";
import "package:riba/utils/database.dart";
import "package:riba/utils/directories.dart";
import "package:riba/utils/logging.dart";
import "package:riba/utils/package_info.dart";

import "constants.dart";

void main() async {
  await Isar.initializeIsarCore(download: true);
  Logging.init();
  InitDirectories.initMock();
  InitPackageInfo.initMock();

  final database = await Database.init(testing: true);
  final mangadex = MangaDex.instance;

  setUp(() async => await clear(database, mangadex));
  tearDown(() async => await clear(database, mangadex));

  group("MangaDex.Manga", () {
    test(".get", () async {
      final mangaData = await mangadex.manga.get(mangaId);
      expect(mangaData.manga.id, mangaId);

      final dbMangaData = await mangadex.manga.get(mangaData.manga.id);
      expect(dbMangaData.manga.id, equals(mangaData.manga.id));
    });
    test(".getMany", () async {
      final manga = await mangadex.manga.getMany(
        overrides: MangaDexMangaQueryFilter(ids: mangaIds),
      );

      // MangaIds contain a pornographic title, so the resolved list will be -1
      expect(manga.length, equals(mangaIds.length - 1));

      final withRatingFilters = await mangadex.manga.getMany(
        overrides: MangaDexMangaQueryFilter(ids: mangaIds, contentRatings: [
          MangaContentRating.safe,
          MangaContentRating.suggestive,
          MangaContentRating.erotica,
          MangaContentRating.pornographic,
        ]),
      );

      expect(withRatingFilters.length, equals(mangaIds.length));
    });
    test(".getByAuthorOrArtistId", () async {
      final manga = await mangadex.manga.getByAuthorOrArtistId(
        overrides: MangaDexMangaQueryFilter(authorOrArtist: authorOrArtistId),
      );

      expect(manga, isNotEmpty);
      expect(
        manga.every((e) =>
            e.manga.artistIds.contains(authorOrArtistId) ||
            e.manga.authorIds.contains(authorOrArtistId)),
        isTrue,
      );

      final local = await mangadex.manga.getByAuthorOrArtistId(
        overrides: MangaDexMangaQueryFilter(authorOrArtist: authorOrArtistId),
      );

      expect(local, isNotEmpty);
      expect(
        local.every((e) =>
            e.manga.artistIds.contains(authorOrArtistId) ||
            e.manga.authorIds.contains(authorOrArtistId)),
        isTrue,
      );
      expect(manga.length, local.length);
    });
    test(".getStatistics", () async {
      final stats = await mangadex.manga.getStatistics(mangaId);
      expect(stats.rating, isNotNull);
      expect(stats.comments, isNotNull);

      final localStats = await mangadex.manga.getStatistics(mangaId);
      expect(localStats.rating, isNotNull);
      expect(localStats.comments, isNotNull);
      expect(localStats.rating!.average, equals(stats.rating!.average));
    });
  });

  group("MangaDex.Chapter", () {
    test(".withFilters", () async {
      final chapters = await mangadex.chapter.withFilters(
        overrides: MangaDexChapterQueryFilter(ids: chapterIds),
      );
      expect(chapters.data, isNotEmpty);
      expect(chapters.data.length, chapterIds.length);

      final chaptersWithTL = await mangadex.chapter.withFilters(
        overrides: MangaDexChapterQueryFilter(translatedLanguages: [Language.japanese]),
      );
      expect(chaptersWithTL.data, isNotEmpty);
      expect(
        chaptersWithTL.data.every((e) => e.chapter.translatedLanguage == Language.japanese),
        isTrue,
      );
    });
    test(".getFeed", () async {
      final feed = await mangadex.chapter.getFeed(
        overrides: MangaDexChapterQueryFilter(mangaId: mangaId),
      );
      expect(feed.data, isNotEmpty);

      final localFeed = await mangadex.chapter.getFeed(
        overrides: MangaDexChapterQueryFilter(mangaId: mangaId),
      );
      expect(localFeed.data, isNotEmpty);
      expect(localFeed.data.length, feed.data.length);

      final filteredGroupId = feed.data
          .firstWhere((e) =>
              e.chapter.translatedLanguage == Language.english && e.chapter.groupIds.isNotEmpty)
          .chapter
          .groupIds
          .first;

      final filteredFeed = await mangadex.chapter.getFeed(
        checkDB: false,
        overrides: MangaDexChapterQueryFilter(
          mangaId: mangaId,
          excludedGroups: [filteredGroupId],
          translatedLanguages: [Language.english],
        ),
      );
      expect(filteredFeed.data, isNotEmpty);
      expect(
        filteredFeed.data.every((e) => !e.chapter.groupIds.contains(filteredGroupId)),
        isTrue,
      );
      expect(
        filteredFeed.data.every((e) => e.chapter.translatedLanguage == Language.english),
        isTrue,
      );

      final localFilteredFeed = await mangadex.chapter.getFeed(
        overrides: MangaDexChapterQueryFilter(
          mangaId: mangaId,
          excludedGroups: [filteredGroupId],
          translatedLanguages: [Language.english],
        ),
      );
      expect(localFilteredFeed.data, isNotEmpty);
      expect(
        localFilteredFeed.data.every((e) => !e.chapter.groupIds.contains(filteredGroupId)),
        isTrue,
      );
      expect(
        localFilteredFeed.data.every((e) => e.chapter.translatedLanguage == Language.english),
        isTrue,
      );
      expect(localFilteredFeed.data.length, equals(filteredFeed.data.length));
    });
  });

  group("MangaDex.CoverArt", () {
    test(".getFileName", () {
      final file = coverFile.split(".");
      final name = file.first;
      final extension = ImageFileType.fromExtension(file.last);

      final original = mangadex.cover.getFileName(name, CoverSize.original, extension);
      final medium = mangadex.cover.getFileName(name, CoverSize.medium, extension);
      final small = mangadex.cover.getFileName(name, CoverSize.small, extension);

      expect(original, coverFile);
      expect(medium, "$coverFile.512.jpg");
      expect(small, "$coverFile.256.jpg");
    });
    test(".getMany", () async {
      final covers = await mangadex.cover.getMany(
        overrides: MangaDexCoverQueryFilter(ids: [coverId]),
      );
      expect(covers.length, equals(1));
    });
    test(".getManyWithMangaId", () async {
      final covers = await mangadex.cover.getManyByMangaId(
        overrides: MangaDexCoverQueryFilter(mangaId: mangaId),
      );
      expect(covers, isNotEmpty);

      final localCovers = await mangadex.cover.getManyByMangaId(
        overrides: MangaDexCoverQueryFilter(mangaId: mangaId),
      );
      expect(localCovers, isNotEmpty);
      expect(localCovers.length, equals(covers.length));
    });
    test(".getImage", () async {
      final res = await mangadex.cover.getMany(overrides: MangaDexCoverQueryFilter(ids: [coverId]));
      final coverTemp = res.values.first;
      final cover = await mangadex.cover.getImage(mangaId, coverTemp.cover);

      final mediumCover = await mangadex.cover.getImage(
        mangaId,
        coverTemp.cover,
        size: CoverSize.medium,
      );

      final smallCover = await mangadex.cover.getImage(
        mangaId,
        coverTemp.cover,
        size: CoverSize.small,
      );

      expect(cover, isNotNull);
      expect(cover.existsSync(), isTrue);
      expect(cover.statSync().type, FileSystemEntityType.file);

      expect(mediumCover, isNotNull);
      expect(mediumCover.existsSync(), isTrue);
      expect(mediumCover.statSync().type, FileSystemEntityType.file);

      expect(smallCover, isNotNull);
      expect(smallCover.existsSync(), isTrue);
      expect(smallCover.statSync().type, FileSystemEntityType.file);
    });
  });

  group("MangaDex.Group", () {
    test(".getSimpleMany", () async {
      final groups = await mangadex.group
          .getManyAsSingle(overrides: MangaDexGenericQueryFilter(ids: groupIds));
      expect(groups, isNotNull);
      expect(groups.length, equals(groupIds.length));
    });
  });

  group("MangaDex.CustomList", () {
    test(".get", () async {
      // Uses .getSeasonal as the underlying function calls .get
      final customList = await mangadex.customList.getSeasonal();
      expect(customList, isNotNull);
      expect(customList.list.mangaIds, isNotEmpty);

      final localCustomList = await mangadex.customList.getSeasonal();
      expect(localCustomList, isNotNull);
      expect(localCustomList.list.mangaIds, equals(customList.list.mangaIds));
    });
  });
}

Future<void> clear(Database database, MangaDex mangadex) async {
  await database.local.writeTxn(() async => await database.local.clear());
  try {
    await Future.wait([
      mangadex.rootDataDir.delete(recursive: true),
      mangadex.rootCacheDir.delete(recursive: true),
    ]);
  } on FileSystemException {
    log("Failed to delete the temp directory", name: "MangaDexTest", level: Level.SHOUT.value);
  }
}
