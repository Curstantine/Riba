import "package:http/http.dart";
import "package:isar/isar.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:riba/repositories/database.dart";
import "package:riba/repositories/rate_limiter.dart";
import "package:riba/repositories/mangadex/manga.dart";

final mangaDexPod = FutureProvider<MangaDex>((ref) async {
  final database = await ref.watch(isarPod.future);
  return MangaDex(database: database);
});

class MangaDex {
  static final Uri url = Uri.https("api.mangadex.org");

  final Client client = Client();
  final RateLimiter rateLimiter = RateLimiter(name: "MangaDex");
  final Isar database;

  late MDMangaRepo manga = MDMangaRepo(client, rateLimiter, database);

  MangaDex({required this.database});
}
