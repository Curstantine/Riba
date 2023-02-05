import "dart:io";

import "package:http/http.dart";
import "package:isar/isar.dart";
import "package:package_info_plus/package_info_plus.dart";
import "package:path_provider/path_provider.dart";
import "package:riba/repositories/client.dart";
import "package:riba/repositories/mangadex/cover_art.dart";
import "package:riba/repositories/rate_limiter.dart";
import "package:riba/repositories/mangadex/manga.dart";
import "package:riba/repositories/url.dart";

class MangaDex {
  static late final MangaDex instance;
  MangaDex._internal({required this.database, required this.userAgent, required this.directory});

  static Future<void> init(Isar database) async {
    final info = await PackageInfo.fromPlatform();
    final applicationDir = await getApplicationDocumentsDirectory();

    instance = MangaDex._internal(
      database: database,
      userAgent: "${info.appName}/${info.buildNumber}",
      directory: Directory("${applicationDir.path}/mangadex"),
    );
  }

  final Isar database;
  final String userAgent;
  final Directory directory;
  final RateLimiter rateLimiter = RateLimiter(name: "MangaDex");

  late Client client = SelfClient(Client(), userAgent);
  late MDMangaRepo manga = MDMangaRepo(client, rateLimiter, database);
  late MDCoverArtRepo covers = MDCoverArtRepo(
    client,
    rateLimiter,
    database,
    Directory("${directory.path}/covers"),
  );

  static final url = URL(hostname: "api.mangadex.org", pathSegments: []);
}
