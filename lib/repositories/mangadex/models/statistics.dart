import "package:riba/repositories/local/models/statistics.dart";
import "package:riba/repositories/utils/exception.dart";
import "package:riba/repositories/utils/url.dart";

import "error.dart";
import "general.dart";

class MDStatistics {
  final Map<String, StatisticAttributes> statistics;

  const MDStatistics(this.statistics);

  factory MDStatistics.fromJson(
    Map<String, dynamic> json, {
    required EntityType type,
    required URL url,
  }) {
    final result = json["result"] as String;
    if (result == "error") {
      final errors = MDError.fromJson((json["errors"] as List<dynamic>)[0]);
      throw MDException(errors, url: url);
    }

    final statistics = <String, StatisticAttributes>{};
    for (final entry in (json["statistics"] as Map<String, dynamic>).entries) {
      final id = entry.key;
      statistics[id] = StatisticAttributes.fromJson(entry.value, id: id, type: type);
    }

    return MDStatistics(statistics);
  }
}

class StatisticAttributes {
  final String id;
  final EntityType type;
  final RatingStatistics? rating;
  final CommentStatistics? comments;
  final int? follows;

  const StatisticAttributes({
    required this.id,
    required this.type,
    this.rating,
    this.comments,
    this.follows,
  });

  factory StatisticAttributes.fromJson(
    Map<String, dynamic> json, {
    required String id,
    required EntityType type,
  }) {
    final ratingMap = json["rating"] as Map<String, dynamic>?;
    final commentsMap = json["comments"] as Map<String, dynamic>?;

    final ratings = ratingMap == null
        ? null
        : RatingStatistics(
            average: ratingMap["average"]?.toDouble() ?? 0,
            bayesian: ratingMap["bayesian"] as double,
            distribution: (ratingMap["distribution"] as Map<String, dynamic>)
                .values
                .map((e) => e as int)
                .toList(),
          );

    final comments = commentsMap == null
        ? null
        : CommentStatistics(
            id: commentsMap["threadId"] as int,
            total: commentsMap["repliesCount"] as int,
          );

    return StatisticAttributes(
      id: id,
      type: type,
      rating: ratings,
      comments: comments,
      follows: json["follows"] as int?,
    );
  }

  Statistics toStatistics() {
    return Statistics(
      id: id,
      type: type,
      rating: rating,
      comments: comments,
      follows: follows,
    );
  }
}
