import "package:isar/isar.dart";
import "package:riba/repositories/mangadex/models/custom_list.dart";
import "package:riba/utils/hash.dart";

part "custom_list.g.dart";

@collection
class CustomList {
	final String id;
	Id get isarId => fastHash(id);

	final String name;
	@Enumerated(EnumType.ordinal)
	final CustomListVisibility visibility;

	final String userId;
	final List<String> mangaIds;

	final int version;

	CustomList({
		required this.id,
		required this.name,
		required this.userId,
		required this.mangaIds,
		required this.version,
		required this.visibility,
	});
}
