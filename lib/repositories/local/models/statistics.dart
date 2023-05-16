import "package:isar/isar.dart";
import "package:riba/repositories/mangadex/models/general.dart";
import "package:riba/utils/hash.dart";

part "statistics.g.dart";

@collection
class Statistics {
	final String id;
	Id get isarId => fastHash(id);

	@Enumerated(EnumType.ordinal)
	final EntityType type;

	final CommentStatistics? comments;
	final RatingStatistics? rating;
	final int? follows;

	Statistics({
		required this.id,
		required this.type,
		this.comments,
		this.rating,
		this.follows,
	});
}

@embedded
class CommentStatistics {
	final int id;
	final int total;

	CommentStatistics({this.id = 0, this.total = 0});
}

@embedded
class RatingStatistics {
	final double average;
	final double bayesian;
	final List<int> distribution;

	/// Used by isar to instantiate the class on the database.
	/// 
	/// Do not use the default constructor.
	RatingStatistics({
		this.average = 0,
		this.bayesian = 0,
		this.distribution = const [],
	});

	RatingStatistics.withValues({
		required this.average,
		required this.bayesian,
		required this.distribution,
	});
}
