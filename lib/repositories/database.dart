import "package:isar/isar.dart";
import "package:path_provider/path_provider.dart";
import "package:riba/repositories/local/cover_art.dart";
import "package:riba/repositories/local/manga.dart";
import "package:riba/repositories/local/author.dart";
import "package:riba/repositories/local/tag.dart";
import "package:riba/repositories/mangadex/mangadex.dart";

class Database {
  static late final Database instance;
  Database._internal({required this.local});

  /// Initializes the needed databases, and their dependent repositories.
  static Future<Database> init() async {
    final dir = await getApplicationDocumentsDirectory();

    instance = Database._internal(
      local: await Isar.open(
        [MangaSchema, AuthorSchema, CoverArtSchema, TagSchema],
        directory: dir.path,
      ),
    );

    await MangaDex.init(instance.local);

    return instance;
  }

  final Isar local;
}
