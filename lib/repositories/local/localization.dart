import "package:isar/isar.dart";

part "localization.g.dart";

/// A class that represents a localization object.
///
/// The values and locales are stored in separate lists to manage compatibility with isar.
/// However, the keys of value and locale are the same.
///
///e.g.
///```
/// Locale.English -> "English Title"
/// Locale.RomanizedJapanese -> "Romanized Japanese Title"
/// localizations[0] = Locale.English && values[0] = "English Title"
/// ```
@embedded
class Localizations {
  late List<Locale> localizations;
  late List<String?> values;

  String? get(Locale locale) {
    final index = localizations.indexOf(locale);
    if (index == -1) return null;
    return values[index];
  }
}

@embedded
class Locale {
  Locale();

  @Enumerated(EnumType.ordinal)
  late Language language;
  late bool romanized;

  factory Locale.withItem(Language language, bool romanized) {
    return Locale()
      ..language = language
      ..romanized = romanized;
  }

  static Locale en = Locale.withItem(Language.english, false);
  static Locale jp = Locale.withItem(Language.japanese, false);
  static Locale cn = Locale.withItem(Language.simpleChinese, false);
  static Locale zhHk = Locale.withItem(Language.traditionalChinese, false);

  static Locale jpRo = Locale.withItem(Language.japanese, true);
  static Locale cnRo = Locale.withItem(Language.simpleChinese, true);
  static Locale zhHkRo = Locale.withItem(Language.traditionalChinese, true);
}

// CAUTION: DO NOT CHANGE THE ORDER OF THE ENUMS
enum Language {
  english("en"),
  japanese("ja"),
  simpleChinese("zh"),
  traditionalChinese("zh-hk"),
  korean("ko");

  final String isoCode;
  const Language(this.isoCode);
}

extension ToLocalizations on Map<String, String> {
  Localizations toLocalizations() {
    final locales = Localizations();

    forEach((key, value) {
      locales.localizations[locales.localizations.length] = key.toLocale();
      locales.values[locales.values.length] = value;
    });

    if (locales.localizations.length != locales.values.length) {
      throw Exception("The length of localizations and values are not the same.");
    }

    return locales;
  }
}

extension ToLocale on String {
  Locale toLocale() {
    final isRomanized = endsWith("-ro");
    final language = Language.values.firstWhere((e) => e.isoCode == replaceFirst("-ro", ""));

    return Locale.withItem(language, isRomanized);
  }
}
