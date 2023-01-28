import "package:http/http.dart";
import "package:isar/isar.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:package_info_plus/package_info_plus.dart";
import "package:riba/repositories/client.dart";
import "package:riba/repositories/database.dart";
import "package:riba/repositories/rate_limiter.dart";
import "package:riba/repositories/mangadex/manga.dart";
import "package:riba/repositories/url.dart";

final mangaDexPod = FutureProvider<MangaDex>((ref) async {
  final database = await ref.watch(isarPod.future);
  final info = await PackageInfo.fromPlatform();

  return MangaDex(
    database: database,
    userAgent: "${info.appName}/${info.buildNumber}",
  );
});

class MangaDex {
  MangaDex({required this.database, required this.userAgent});

  final Isar database;
  final String userAgent;
  final RateLimiter rateLimiter = RateLimiter(name: "MangaDex");

  late SelfClient client = SelfClient(Client(), userAgent);
  late MDMangaRepo manga = MDMangaRepo(client, rateLimiter, database);

  static final url = URL(hostname: "api.mangadex.org", pathSegments: []);
}
