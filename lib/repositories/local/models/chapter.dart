import "package:isar/isar.dart";
import "package:riba/utils/hash.dart";

import "chapter_local_meta.dart";
import "localization.dart";

part "chapter.g.dart";

@collection
class Chapter {
	final String id;
	Id get isarId => fastHash(id);

	@Index()
	final String mangaId;
	final String uploaderId;

	@Index(type: IndexType.hashElements)
	final List<String> groupIds;

	final String? title;
	final String? volume;
	final String? chapter;

	final int pages;
	final String? externalUrl;

	final DateTime createdAt;
	final DateTime updatedAt;
	final DateTime publishAt;
	final DateTime readableAt;

	final int version;

	@Enumerated(EnumType.ordinal)
	final Language translatedLanguage;

	final meta = IsarLink<ChapterLocalMeta>();

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
}

extension SortChapter on List<Chapter> {
	// TODO: Handle edge cases where chapter number is repated every volume and etc.
	/// Sorts in the desired descending order.
	///
	/// If [chapter] is not null, it will be sorted by [chapter].
	/// If [chapter] is null, it will be sorted by [volume].
	/// If both [chapter] and [volume] are null, it will not be sorted.
	void sortInDesc() => sort((a, b) {
		if (a.chapter != null && b.chapter != null) {
			final aChapter = double.tryParse(a.chapter!) ?? parseFromLTR(a.chapter!) ?? 0;
			final bChapter = double.tryParse(b.chapter!) ?? parseFromLTR(b.chapter!) ?? 0;

			return bChapter.compareTo(aChapter);
		}

		if (a.volume != null && b.volume != null) {
			final aVolume = double.tryParse(a.volume!) ?? parseFromLTR(a.volume!) ?? 0;
			final bVolume = double.tryParse(b.volume!) ?? parseFromLTR(b.volume!) ?? 0;

			return bVolume.compareTo(aVolume);
		}

		return 0;
	});
}

/// Parses a string to a double.
/// Uses a mechanism where it will parse the first number it finds if [double.tryParse] cannot parse it.
/// 
/// E.g.
/// 1. "9y" -> 9
/// 2. "y9" -> 9
/// 3. "9.5" -> 9.5
/// 4. "yooe" -> null
double? parseFromLTR(String str) {
	final match = RegExp(r"\d+").firstMatch(str);
	if (match == null) return null;
	return double.parse(match.group(0)!);
}