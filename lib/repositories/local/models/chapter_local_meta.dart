import "package:copy_with_extension/copy_with_extension.dart";
import "package:isar/isar.dart";
import "package:riba/utils/hash.dart";

part "chapter_local_meta.g.dart";

@CopyWith()
@Collection(accessor: "chapterMeta")
class ChapterLocalMeta {
	/// The id of the chapter.
	final String id;
	Id get isarId => fastHash(id);

	final bool isRead;
	final bool isDownloaded;
	final bool isFavorite;

	final int lastReadPage;
	final DateTime lastReadAt;	

	ChapterLocalMeta({
		required this.id,
		required this.isRead,
		required this.isDownloaded,
		required this.isFavorite,
		required this.lastReadPage,
		required this.lastReadAt,
	});
}