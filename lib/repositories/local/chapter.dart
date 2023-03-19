import "package:isar/isar.dart";
import "package:riba/repositories/local/localization.dart";
import "package:riba/utils/hash.dart";

part "chapter.g.dart";

@collection
class Chapter {
  late String id;
  Id get isarId => fastHash(id);

  late String mangaId;
  late String uploaderId;
  late List<String> groupIds;

  late String? title;
  late String? volume;
  late String? chapter;

  late int pages;
  late Locale translatedLanguage;
  late String? externalUrl;

  late DateTime createdAt;
  late DateTime updatedAt;
  late DateTime publishAt;
  late DateTime readableAt;

  late int version;

  Chapter({
    required this.id,
    required this.mangaId,
    required this.uploaderId,
    required this.groupIds,
    this.title,
    this.volume,
    this.chapter,
    required this.pages,
    required this.translatedLanguage,
    this.externalUrl,
    required this.createdAt,
    required this.updatedAt,
    required this.publishAt,
    required this.readableAt,
    required this.version,
  });

  /// Checks if the given [Chapter] has the same [id] and the [version] as this.
  bool isLooselyEqual(Chapter other) {
    return id == other.id && version == other.version;
  }

  @override
  // ignore: hash_and_equals
  operator ==(Object other) {
    throw UnimplementedError();
  }
}
