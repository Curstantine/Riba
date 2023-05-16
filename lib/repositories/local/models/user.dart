import "package:isar/isar.dart";
import "package:riba/repositories/mangadex/models/user.dart";
import "package:riba/utils/hash.dart";

part "user.g.dart";

@collection
class User {
	final String id;
	Id get isarId => fastHash(id);

	final String username;
	final int version;

	@Enumerated(EnumType.ordinal)
	final List<UserRole> roles;

	User({
		required this.id,
		required this.username,
		required this.roles,
		required this.version,
	});
}
