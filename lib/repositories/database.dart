import "dart:io";

import "package:isar/isar.dart";
import "package:package_info_plus/package_info_plus.dart";
import "package:path_provider/path_provider.dart";
import "package:riba/repositories/local/author.dart";
import "package:riba/repositories/local/chapter.dart";
import "package:riba/repositories/local/cover_art.dart";
import "package:riba/repositories/local/custom_list.dart";
import "package:riba/repositories/local/group.dart";
import "package:riba/repositories/local/manga.dart";
import "package:riba/repositories/local/statistics.dart";
import "package:riba/repositories/local/tag.dart";
import "package:riba/repositories/local/user.dart";
import "package:riba/repositories/mangadex.dart";

class Database {
  static late final Database instance;
  Database._internal({required this.local});

  /// Initializes the needed databases, and their dependent repositories.
  static Future<Database> init({Directory? directory, bool testing = false}) async {
    final dir = directory ?? await getApplicationDocumentsDirectory();
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

    instance = Database._internal(
      local: await Isar.open(schemas, directory: testing ? null : dir.path),
    );

    final packageInfo = !testing
        ? await PackageInfo.fromPlatform()
        : PackageInfo(
            appName: "riba_tester", packageName: "riba_tester", version: "0.0.0", buildNumber: "0");

    await MangaDex.init(instance.local, Directory("${dir.path}/mangadex"), packageInfo);

    return instance;
  }

  final Isar local;
}
