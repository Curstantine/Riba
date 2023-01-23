import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:isar/isar.dart';
import 'package:riba/repositories/database.dart';
import 'package:riba/repositories/mangadex/manga.dart';
import 'package:riba/repositories/rate_limiter.dart';

final mangaDexPod = Provider<MangaDex>((ref) {
  final database = ref.watch(isarPod);
  return MangaDex(database: database.asData!.value);
});

class MangaDex {
  static final Uri url = Uri.https("api.mangadex.org");

  final Client client = Client();
  final RateLimiter rateLimiter = RateLimiter();
  final Isar database;

  late MDMangaRepo manga = MDMangaRepo(client, rateLimiter, database);

  MangaDex({required this.database});
}
