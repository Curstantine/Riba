import "dart:io";

import "package:http/http.dart";
import "package:isar/isar.dart";
import "package:riba/repositories/local/models/author.dart";
import "package:riba/repositories/local/models/chapter.dart";
import "package:riba/repositories/local/models/cover_art.dart";
import "package:riba/repositories/local/models/custom_list.dart";
import "package:riba/repositories/local/models/group.dart";
import "package:riba/repositories/local/models/manga.dart";
import "package:riba/repositories/utils/client.dart";
import "package:riba/repositories/utils/rate_limiter.dart";
import "package:riba/repositories/utils/url.dart";
import "package:riba/utils/directories.dart";
import "package:riba/utils/package_info.dart";

import "services/author.dart";
import "services/chapter.dart";
import "services/cover_art.dart";
import "services/custom_list.dart";
import "services/group.dart";
import "services/manga.dart";

class MangaDex {
	static late final MangaDex instance;
	MangaDex._internal({
		required this.database,
		required this.userAgent,
		required this.rootCacheDir,
		required this.rootDataDir,
	});

	static final url = URL(hostname: "api.mangadex.org", pathSegments: []);

	final Isar database;
	final String userAgent;
	final Directory rootCacheDir;
	final Directory rootDataDir;

	final RateLimiter rateLimiter = RateLimiter(name: "MangaDex");
	late final Client client = SelfClient(Client(), userAgent);

	late final customList = MangaDexCustomListService(
		client: client,
		rateLimiter: rateLimiter,
		database: database.customLists,
		rootUrl: url,
	);

	late final author = MangaDexAuthorService(
		client: client,
		rateLimiter: rateLimiter,
		database: database.authors,
		rootUrl: url,
	);

	late final cover = MangaDexCoverService(
		client: client,
		rateLimiter: rateLimiter,
		database: database.covers,
		rootUrl: url,
		dataDir: Directory("${rootDataDir.path}/covers"),
		cacheDir: Directory("${rootCacheDir.path}/covers"),
	);

	late final chapter = MangaDexChapterService(
		client: client,
		rateLimiter: rateLimiter,
		database: database.chapters,
		rootUrl: url,
	);

	late final group = MangaDexGroupService(
		client: client,
		rateLimiter: rateLimiter,
		database: database.groups,
		rootUrl: url,
	);

	late final manga = MangaDexMangaService(
		client: client,
		rateLimiter: rateLimiter,
		database: database.manga,
		rootUrl: url,
	);

	static void init(Isar database) {
		final pkgInfo = InitPackageInfo.instance.info;

		instance = MangaDex._internal(
			database: database,
			userAgent: "${pkgInfo.appName}/${pkgInfo.version}",
			rootCacheDir: Directory("${InitDirectories.instance.cacheDir.path}/mangadex"),
			rootDataDir: Directory("${InitDirectories.instance.documentDir.path}/mangadex"),
		);
	}
}
