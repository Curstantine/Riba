import "package:isar/isar.dart";
import "package:riba/repositories/mangadex/models/tag.dart";
import "package:riba/utils/hash.dart";

import "localization.dart";

part "tag.g.dart";

@collection
class Tag {
	final String id;
	Id get isarId => fastHash(id);

	final Localizations name;
	final Localizations description;
	final int version;

	@Enumerated(EnumType.ordinal)
	final TagGroup group;

	Tag({
		required this.id,
		required this.name,
		required this.description,
		required this.group,
		required this.version,
	});
}
