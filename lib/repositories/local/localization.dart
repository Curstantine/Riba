import "dart:developer";

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
  List<Locale> localizations = [];
  List<String?> values = [];

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
  static Locale ja = Locale.withItem(Language.japanese, false);
  static Locale zh = Locale.withItem(Language.simpleChinese, false);
  static Locale zhHk = Locale.withItem(Language.traditionalChinese, false);

  static Locale jaRo = Locale.withItem(Language.japanese, true);
  static Locale zhRo = Locale.withItem(Language.simpleChinese, true);
  static Locale zhHkRo = Locale.withItem(Language.traditionalChinese, true);

  @override
  operator ==(Object other) {
    if (other is Locale) {
      return language == other.language && romanized == other.romanized;
    }
    return false;
  }

  @override
  int get hashCode => language.hashCode ^ romanized.hashCode;
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
      try {
        locales.localizations.add(key.toLocale());
        locales.values.add(value);
      } catch (e) {
        log("Ignoring $key: ${e.toString()}", name: "Localizations.toLocalizations");
      }
    });

    if (locales.localizations.length != locales.values.length) {
      throw Exception("The length of localizations and values are not the same.");
    }

    return locales;
  }
}

extension ToLocale on String {
  /// Converts a string into a language code.
  ///
  /// Throws an exception if the language code is not supported.
  Locale toLocale() {
    final isRomanized = endsWith("-ro");
    final language = Language.values.firstWhere(
      (e) => isRomanized ? e.isoCode == replaceFirst("-ro", "") : e.isoCode == this,
      orElse: () => throw Exception("The language code is not supported."),
    );

    return Locale.withItem(language, isRomanized);
  }
}
