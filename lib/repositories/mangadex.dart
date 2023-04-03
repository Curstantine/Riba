import "dart:io";

import "package:http/http.dart";
import "package:isar/isar.dart";
import "package:package_info_plus/package_info_plus.dart";
import "package:riba/repositories/mangadex/chapter.dart";
import "package:riba/repositories/mangadex/cover_art.dart";
import "package:riba/repositories/mangadex/custom_list.dart";
import "package:riba/repositories/mangadex/group.dart";
import "package:riba/repositories/mangadex/manga.dart";
import "package:riba/repositories/utils/client.dart";
import "package:riba/repositories/utils/rate_limiter.dart";
import "package:riba/repositories/utils/url.dart";

class MangaDex {
  static late final MangaDex instance;
  MangaDex._internal({required this.database, required this.userAgent, required this.directory});

  static final url = URL(hostname: "api.mangadex.org", pathSegments: []);

  final Isar database;
  final String userAgent;
  final Directory directory;
  final RateLimiter rateLimiter = RateLimiter(name: "MangaDex");

  late final Client client = SelfClient(Client(), userAgent);
  late final MDMangaRepo manga = MDMangaRepo(client, rateLimiter, database);
  late final MDGroupRepo group = MDGroupRepo(client, rateLimiter, database);
  late final MDCustomListRepo customLists = MDCustomListRepo(client, rateLimiter, database);

  late final MangaDexCoverService cover = MangaDexCoverService(
    client: client,
    rateLimiter: rateLimiter,
    database: database,
    rootUrl: url,
    cache: Directory("${directory.path}/covers"),
  );

  late final MangaDexChapterService chapter = MangaDexChapterService(
    client: client,
    rateLimiter: rateLimiter,
    database: database,
    rootUrl: url,
  );

  static Future<void> init(Isar database, Directory directory, PackageInfo info) async {
    instance = MangaDex._internal(
      database: database,
      userAgent: "${info.appName}/${info.buildNumber}",
      directory: directory,
    );
  }
}
