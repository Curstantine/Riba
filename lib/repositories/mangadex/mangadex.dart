import "dart:io";

import "package:http/http.dart";
import "package:isar/isar.dart";
import "package:riba/repositories/local/models/chapter.dart";
import "package:riba/repositories/local/models/cover_art.dart";
import "package:riba/repositories/local/models/custom_list.dart";
import "package:riba/repositories/local/models/group.dart";
import "package:riba/repositories/local/models/manga.dart";
import "package:riba/repositories/mangadex/services/chapter.dart";
import "package:riba/repositories/mangadex/services/cover_art.dart";
import "package:riba/repositories/mangadex/services/custom_list.dart";
import "package:riba/repositories/mangadex/services/group.dart";
import "package:riba/repositories/mangadex/services/manga.dart";
import "package:riba/repositories/utils/client.dart";
import "package:riba/repositories/utils/rate_limiter.dart";
import "package:riba/repositories/utils/url.dart";
import "package:riba/utils/directories.dart";
import "package:riba/utils/package_info.dart";

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

  late final MangaDexCustomListService customList = MangaDexCustomListService(
    client: client,
    rateLimiter: rateLimiter,
    database: database.customLists,
    rootUrl: url,
  );

  late final MangaDexCoverService cover = MangaDexCoverService(
    client: client,
    rateLimiter: rateLimiter,
    database: database.covers,
    rootUrl: url,
    dataDir: Directory("${rootDataDir.path}/covers"),
    cacheDir: Directory("${rootCacheDir.path}/covers"),
  );

  late final MangaDexChapterService chapter = MangaDexChapterService(
    client: client,
    rateLimiter: rateLimiter,
    database: database.chapters,
    rootUrl: url,
  );

  late final MangaDexGroupService group = MangaDexGroupService(
    client: client,
    rateLimiter: rateLimiter,
    database: database.groups,
    rootUrl: url,
  );

  late final MangaDexMangaService manga = MangaDexMangaService(
    client: client,
    rateLimiter: rateLimiter,
    database: database.manga,
    rootUrl: url,
  );

  static Future<void> init(Isar database) async {
    final pkgInfo = InitPackageInfo.instance.info;

    instance = MangaDex._internal(
      database: database,
      userAgent: "${pkgInfo.appName}/${pkgInfo.version}",
      rootCacheDir: Directory("${InitDirectories.instance.cacheDir.path}/mangadex"),
      rootDataDir: Directory("${InitDirectories.instance.documentDir.path}/mangadex"),
    );
  }
}
