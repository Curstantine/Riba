import "dart:developer";
import "dart:io";

import "package:flutter_test/flutter_test.dart";
import "package:isar/isar.dart";
import "package:logging/logging.dart";
import "package:riba/repositories/local/models/cover_art.dart";
import "package:riba/repositories/local/models/localization.dart";
import "package:riba/repositories/mangadex/mangadex.dart";
import "package:riba/repositories/mangadex/models/manga.dart";
import "package:riba/repositories/mangadex/services/author.dart";
import "package:riba/repositories/mangadex/services/chapter.dart";
import "package:riba/repositories/mangadex/services/cover_art.dart";
import "package:riba/repositories/mangadex/services/group.dart";
import "package:riba/repositories/mangadex/services/manga.dart";
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

	testAuthor(mangadex, database);
	testChapter(mangadex, database);
	testCoverArt(mangadex, database);
	testCustomList(mangadex, database);
	testGroup(mangadex, database);
	testManga(mangadex, database);
}

void testAuthor(MangaDex mangadex, Database database) => group("MangaDex.Author", () {
	test(".withFilters", () async {
		final groups = await mangadex.author.withFilters(
			overrides: const MangaDexAuthorWithFilterQueryFilter(name: authorName),
		);

		expect(groups, isNotNull);
		expect(groups.data.length, equals(1));
		expect(groups.data.first.name, equals(authorName));
	});
});

void testChapter(MangaDex mangadex, Database database) => group("MangaDex.Chapter", () {
	test(".withFilters", () async {
		final chaptersWithId = await mangadex.chapter.withFilters(
			overrides: const MangaDexChapterWithFiltersQueryFilter(ids: chapterIds),
		);
		expect(chaptersWithId.data, hasLength(chapterIds.length));

		final chaptersWithTL = await mangadex.chapter.withFilters(
			overrides: const MangaDexChapterWithFiltersQueryFilter(translatedLanguages: [Language.japanese]),
		);
		expect(chaptersWithTL.data, isNotEmpty);
		expect(
			chaptersWithTL.data.every((e) => e.chapter.translatedLanguage == Language.japanese),
			isTrue,
		);
	});

	test(".getFeed", () async {
		final feed = await mangadex.chapter.getFeed(
			overrides: const MangaDexChapterGetFeedQueryFilter(mangaId: mangaId),
		);
		expect(feed.data, isNotEmpty);
		expect(
			feed.data.every((e) => e.chapter.mangaId == mangaId),
			isTrue,
		);

		final localFeed = await mangadex.chapter.getFeed(
			overrides: const MangaDexChapterGetFeedQueryFilter(mangaId: mangaId),
		);
		expect(localFeed.data, hasLength(feed.data.length));
		expect(
			localFeed.data.every((e) => e.chapter.mangaId == mangaId),
			isTrue,
		);

		final filteredGroupId = feed.data
			.firstWhere((e) => e.chapter.translatedLanguage == Language.english && e.chapter.groupIds.isNotEmpty)
			.chapter
			.groupIds
			.first;

		final filteredFeed = await mangadex.chapter.getFeed(
			checkDB: false,
			overrides: MangaDexChapterGetFeedQueryFilter(
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
			overrides: MangaDexChapterGetFeedQueryFilter(
				mangaId: mangaId,
				excludedGroups: [filteredGroupId],
				translatedLanguages: [Language.english],
			),
		);
		expect(localFilteredFeed.data, hasLength(filteredFeed.data.length));
		expect(
			localFilteredFeed.data.every((e) => !e.chapter.groupIds.contains(filteredGroupId)),
			isTrue,
		);
		expect(
			localFilteredFeed.data.every((e) => e.chapter.translatedLanguage == Language.english),
			isTrue,
		);
	});
});

void testCoverArt(MangaDex mangadex, Database database) => group("MangaDex.CoverArt", () {
	test(".getFileName", () {
		final file = coverFile.split(".");
		final name = file.first;
		final ext = ImageFileType.fromExtension(file.last);

		final original = mangadex.cover.getFileName(name, CoverSize.original, ext);
		final medium = mangadex.cover.getFileName(name, CoverSize.medium, ext);
		final small = mangadex.cover.getFileName(name, CoverSize.small, ext);

		expect(original, coverFile);
		expect(medium, "$coverFile.512.jpg");
		expect(small, "$coverFile.256.jpg");
	});

	test(".get", () async {
		final cover = await mangadex.cover.get(coverId);
		expect(cover, isNotNull);
		expect(cover.cover.id, equals(coverId));
	});

	test(".getMany", () async {
		final covers = await mangadex.cover.getMany(overrides: const MangaDexCoverGetManyQueryFilter(ids: [coverId]));
		expect(covers.length, equals(1));
		expect(covers.values.first.cover.id, equals(coverId));
	});

	test(".getManyWithMangaId", () async {
		final covers = await mangadex.cover.getManyByMangaId(
			overrides: const MangaDexCoverGetManyByMangaIdQueryFilter(mangaId: mangaId),
		);
		expect(covers, isNotEmpty);

		final localCovers = await mangadex.cover.getManyByMangaId(
			overrides: const MangaDexCoverGetManyByMangaIdQueryFilter(mangaId: mangaId),
		);
		expect(localCovers, isNotEmpty);
		expect(localCovers.length, equals(covers.length));

		final localeCovers = await mangadex.cover.getManyByMangaId(
			overrides: MangaDexCoverGetManyByMangaIdQueryFilter(mangaId: mangaId, locales: [Locale.en]),
			checkDB: false,
		);
		expect(localeCovers, isNotEmpty);
		expect(localeCovers.every((e) => e.cover.locale == Locale.en), isTrue);

		final localLocaleCovers = await mangadex.cover.getManyByMangaId(
			overrides: MangaDexCoverGetManyByMangaIdQueryFilter(mangaId: mangaId, locales: [Locale.en]),
		);
		expect(localLocaleCovers, isNotEmpty);
		expect(localLocaleCovers.every((e) => e.cover.locale == Locale.en), isTrue);
		expect(localLocaleCovers.length, equals(localeCovers.length));
	});

	test(".getImage", () async {
		final data = await mangadex.cover.get(coverId);

		final cover = await mangadex.cover.getImage(mangaId, data.cover);
		expect(cover, isNotNull);
		expect(cover.existsSync(), isTrue);
		expect(cover.statSync().type, FileSystemEntityType.file);

		final mediumCover = await mangadex.cover.getImage(mangaId, data.cover, size: CoverSize.medium);
		expect(mediumCover, isNotNull);
		expect(mediumCover.existsSync(), isTrue);
		expect(mediumCover.statSync().type, FileSystemEntityType.file);

		final smallCover = await mangadex.cover.getImage(mangaId, data.cover, size: CoverSize.small);
		expect(smallCover, isNotNull);
		expect(smallCover.existsSync(), isTrue);
		expect(smallCover.statSync().type, FileSystemEntityType.file);
	});
});

void testCustomList(MangaDex mangadex, Database database) => group("MangaDex.CustomList", () {
	test(".get", () async {
		// .getSeasonal is a convenient method to use .get with a predefined id.
		final customList = await mangadex.customList.getSeasonal();
		expect(customList, isNotNull);
		expect(customList.list.mangaIds, isNotEmpty);

		final localCustomList = await mangadex.customList.getSeasonal();
		expect(localCustomList, isNotNull);
		expect(localCustomList.list.mangaIds, equals(customList.list.mangaIds));
	});
});

void testGroup(MangaDex mangadex, Database database) => group("MangaDex.Group", () {
	test(".withFilters", () async {
		final groups = await mangadex.group.withFilters(
			overrides: const MangaDexGroupWithFilterQueryFilter(name: groupName),
		);

		expect(groups, isNotNull);
		expect(groups.data.length, equals(1));
		expect(groups.data.first.group.name, equals(groupName));
	});
	test(".getSimpleMany", () async {
		final groups = await mangadex.group.getManyAsSingle(
			overrides: const MangaDexGroupGetManyAsSingleQueryFilter(ids: groupIds)
		);

		expect(groups, isNotNull);
		expect(groups.length, equals(groupIds.length));
	});
});


void testManga(MangaDex mangadex, Database database) => group("MangaDex.Manga", () {
	test(".get", () async {
		final mangaData = await mangadex.manga.get(mangaId);
		expect(mangaData.manga.id, mangaId);

		final dbMangaData = await mangadex.manga.get(mangaData.manga.id);
		expect(dbMangaData.manga.id, equals(mangaData.manga.id));
	});

	test(".getMany", () async {
		final manga = await mangadex.manga.getMany(
			overrides: const MangaDexMangaGetManyQueryFilter(ids: mangaIds),
		);

		// MangaIds contain a pornographic title, so the resolved list will be -1
		expect(manga.length, equals(mangaIds.length - 1));

		final withRatingFilters = await mangadex.manga.getMany(
			overrides: const MangaDexMangaGetManyQueryFilter(ids: mangaIds, contentRatings: [
				ContentRating.safe,
				ContentRating.suggestive,
				ContentRating.erotica,
				ContentRating.pornographic,
			]),
		);

		expect(withRatingFilters.length, equals(mangaIds.length));
	});

	test(".getByAuthorOrArtistId", () async {
		final manga = await mangadex.manga.getByAuthorOrArtistId(
			overrides: const MangaDexMangaAuthorOrArtistQueryFilter(authorOrArtistId: authorOrArtistId),
		);

		expect(manga, isNotEmpty);
		expect(
			manga.every((e) => e.manga.artistIds.contains(authorOrArtistId) || e.manga.authorIds.contains(authorOrArtistId)),
			isTrue,
		);

		final local = await mangadex.manga.getByAuthorOrArtistId(
			overrides: const MangaDexMangaAuthorOrArtistQueryFilter(authorOrArtistId: authorOrArtistId),
		);

		expect(local, isNotEmpty);
		expect(
			local.every((e) => e.manga.artistIds.contains(authorOrArtistId) || e.manga.authorIds.contains(authorOrArtistId)),
			isTrue,
		);
		expect(manga.length, local.length);
	});

	test(".withFilters", () async {
		final manga = await mangadex.manga.withFilters(
			overrides: const MangaDexMangaWithFiltersQueryFilter(title: title, limit: 1),
		);

		expect(manga.limit, equals(1));
		expect(manga.data, hasLength(1));
		expect(manga.data.first.manga.titles.get(Locale.en), equals(title));
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
	test(".getAllTags", () async {
		final tags = await mangadex.manga.getAllTags();
		expect(tags, isNotEmpty);
	});
});


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
