import "dart:developer";

/// Generic rate limiter that could be used to impose limits based on a signature/key.
class RateLimiter {
  RateLimiter({required this.name});

  /// Map of signature and it's rate.
  ///
  /// A signature is a string that identifies a request.
  ///
  /// e.g.
  ///   `/manga:GET` for `GET https://api.mangadex.org/manga`
  final Map<String, Rate> rates = {};
  final Map<String, List<DateTime>> rateStamps = {};
  final String name;

  Future<void> wait(String signature) async {
    if (!rates.containsKey(signature)) throw Exception("No rate limit for $signature");
    if (!rateStamps.containsKey(signature)) rateStamps[signature] = [];

    final now = DateTime.now();
    final rate = rates[signature]!;
    final timestamps = rateStamps[signature]!;
    final withinDuration = timestamps.where((t) => t.isAfter(now.subtract(rate.duration)));

    if (withinDuration.length > rate.requests) {
      final elapsed = now.difference(withinDuration.last);
      final remaining = rate.duration - elapsed;
      log("Rate limit exceeded for $signature, waiting $remaining", name: name);

      await Future.delayed(remaining);
      rateStamps[signature] = [now];
    } else {
      rateStamps[signature]!.add(DateTime.now());
    }
  }
}

class Rate {
  /// Requests per [duration].
  final int requests;
  final Duration duration;

  const Rate(this.requests, this.duration);
}
