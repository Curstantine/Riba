import "package:isar/isar.dart";
import "package:riba/repositories/local/models/author.dart";
import "package:riba/repositories/local/models/chapter.dart";
import "package:riba/repositories/local/models/cover_art.dart";
import "package:riba/repositories/local/models/custom_list.dart";
import "package:riba/repositories/local/models/group.dart";
import "package:riba/repositories/local/models/manga.dart";
import "package:riba/repositories/local/models/statistics.dart";
import "package:riba/repositories/local/models/tag.dart";
import "package:riba/repositories/local/models/user.dart";
import "package:riba/repositories/mangadex/mangadex.dart";
import "package:riba/utils/directories.dart";

class LocalDatabase {
  static late final LocalDatabase instance;

  LocalDatabase._internal({required this.local});

  /// Initializes the needed databases, and their dependent repositories.
  static Future<LocalDatabase> init({bool testing = false}) async {
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

    instance = LocalDatabase._internal(
      local: await Isar.open(
        schemas,
        directory: InitDirectories.instance.supportDir.path,
        name: "LocalDatabase",
      ),
    );

    await MangaDex.init(instance.local);

    return instance;
  }

  final Isar local;
}
