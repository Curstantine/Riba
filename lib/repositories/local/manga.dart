import 'package:isar/isar.dart';
import 'package:riba/utils/hash.dart';
import 'localization.dart';

part 'manga.g.dart';

@collection
class Manga {
  late String id;
  Id get isarId => fastHash(id);

  late Localizations titles;
  late Localizations description;
  late List<Localizations> authors;
  late Locale originalLocale;
}
