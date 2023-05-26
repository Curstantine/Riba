// ignore_for_file: public_member_api_docs, sort_constructors_first
import "package:isar/isar.dart";

part "history.g.dart";

@Collection(accessor: "history")
class History {
	final Id id = Isar.autoIncrement;

	@Index()
	@Enumerated(EnumType.ordinal)
	final HistoryType type;

	/// The value of the entity this [HistoryType] is referring to.
	/// 
	/// For known entities like author, chapter and manga, this value refers to the id of it.
	/// In the context of a query, this value refers to the query itself.
	final String value;

	final DateTime createdAt;
	
	const History({
		required this.type,
		required this.value,
		required this.createdAt,
	});
}

// NOTE: DO NOT CHANGE THE ORDER OF THIS ENUM
/// The type of entity this [History] is referring to.
enum HistoryType {
	author,
	chapter,
	manga,
	query,
}