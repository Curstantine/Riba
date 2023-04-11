import "package:isar/isar.dart";
import "package:riba/repositories/local/author.dart";
import "package:riba/repositories/local/chapter.dart";
import "package:riba/repositories/local/cover_art.dart";
import "package:riba/repositories/local/custom_list.dart";
import "package:riba/repositories/local/group.dart";
import "package:riba/repositories/local/manga.dart";
import "package:riba/repositories/local/statistics.dart";
import "package:riba/repositories/local/tag.dart";
import "package:riba/repositories/local/user.dart";
import "package:riba/repositories/mangadex/mangadex.dart";
import "package:riba/utils/directories.dart";

class MangaDexDatabase {
  static late final MangaDexDatabase instance;

  MangaDexDatabase._internal({required this.local});

  /// Initializes the needed databases, and their dependent repositories.
  static Future<MangaDexDatabase> init({bool testing = false}) async {
    final schemas = [
      MangaSchema,
      AuthorSchema,
      CoverArtSchema,
      TagSchema,
      CustomListSchema,
      UserSchema,
      StatisticsSchema,
      GroupSchema,
      ChapterSchema,
    ];

    instance = MangaDexDatabase._internal(
      local: await Isar.open(
        schemas,
        directory: InitDirectories.instance.supportDir.path,
      ),
    );

    await MangaDex.init(instance.local);

    return instance;
  }

  final Isar local;
}
