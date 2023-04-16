import "package:isar/isar.dart";
import "package:riba/utils/hash.dart";

import "localization.dart";

part "chapter.g.dart";

@collection
class Chapter {
  late String id;
  Id get isarId => fastHash(id);

  @Index()
  late String mangaId;

  @Index()
  late String uploaderId;

  @Index(type: IndexType.hashElements)
  late List<String> groupIds;

  late String? title;
  late String? volume;
  late String? chapter;

  late int pages;
  late String? externalUrl;

  late DateTime createdAt;
  late DateTime updatedAt;
  late DateTime publishAt;
  late DateTime readableAt;

  late int version;

  @Enumerated(EnumType.ordinal)
  late Language translatedLanguage;

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

extension SortChapter on List<Chapter> {
  // TODO: Handle edge cases where chapter number is repated every volume and etc.
  /// Sorts in the desired descending order.
  ///
  /// If [chapter] is not null, it will be sorted by [chapter].
  /// If [chapter] is null, it will be sorted by [volume].
  /// If both [chapter] and [volume] are null, it will not be sorted.
  void sortInDesc() {
    sort((a, b) {
      if (a.chapter != null && b.chapter != null) {
        final aChapter = double.parse(a.chapter!);
        final bChapter = double.parse(b.chapter!);

        return bChapter.compareTo(aChapter);
      }

      if (a.volume != null && b.volume != null) {
        final aVolume = double.parse(a.volume!);
        final bVolume = double.parse(b.volume!);

        return bVolume.compareTo(aVolume);
      }

      return 0;
    });
  }
}
