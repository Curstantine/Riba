import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:riba/repositories/mangadex/manga.dart';
import 'package:riba/repositories/rate_limiter.dart';

final mangaDexPod = Provider<MangaDex>((ref) => MangaDex());

class MangaDex {
  static final Uri url = Uri.https("api.mangadex.org");

  final Client client = Client();
  final RateLimiter rateLimiter = RateLimiter();
  late MDMangaRepo manga = MDMangaRepo(client, rateLimiter);
}
