import "package:isar/isar.dart";
import "package:riba/repositories/mangadex/general.dart";
import "package:riba/utils/hash.dart";

part "statistics.g.dart";

/// Generic statistic model to be stored in the local database.
///
/// ### Note
/// This model doesn't implement an eq operator, as it is impossible to do that
/// without losing performance.
@collection
class Statistics {
  late String id;
  Id get isarId => fastHash(id);

  @Enumerated(EnumType.ordinal)
  late EntityType type;

  late CommentStatistics? comments;
  late RatingStatistics? rating;
  late int? follows;

  Statistics({
    required this.id,
    required this.type,
    this.comments,
    this.rating,
    this.follows,
  });

  @override
  // ignore: hash_and_equals
  operator ==(Object other) {
    throw UnimplementedError();
  }
}

@embedded
class CommentStatistics {
  late int id;
  late int total;

  CommentStatistics({
    this.id = 0,
    this.total = 0,
  });
}

@embedded
class RatingStatistics {
  late double average;
  late double bayesian;
  late List<int> distribution;

  RatingStatistics({
    this.average = 0.0,
    this.bayesian = 0.0,
    this.distribution = const [],
  });
}
