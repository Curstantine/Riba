import "package:isar/isar.dart";
import "package:riba/repositories/mangadex/models/user.dart";
import "package:riba/utils/hash.dart";

part "user.g.dart";

@collection
class User {
  late String id;
  Id get isarId => fastHash(id);

  late String username;
  late int version;

  @Enumerated(EnumType.ordinal)
  late List<UserRole> roles;

  User({
    required this.id,
    required this.username,
    required this.roles,
    required this.version,
  });

  /// Checks if the given [User] has the same [id] and the [version] as this.
  bool isLooselyEqual(User other) {
    return id == other.id && version == other.version;
  }

  @override
  // ignore: hash_and_equals
  operator ==(Object other) {
    throw UnimplementedError();
  }
}
