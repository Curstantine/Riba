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
  List<Locale> localizations;
  List<String> values;

  Localizations({this.localizations = const [], this.values = const []});

  String? get(Locale locale) {
    final index = localizations.indexOf(locale);
    if (index == -1) return null;
    return values[index];
  }

  factory Localizations.fromMap(Map<String, String> map) {
    final List<Locale> localizations = [];
    final List<String> values = [];

    map.forEach((key, value) {
      try {
        localizations.add(Locale.fromJsonValue(key));
        values.add(value);
      } catch (e) {
        log("Ignoring $key: ${e.toString()}", name: "Localizations.toLocalizations");
      }
    });

    if (localizations.length != values.length) {
      throw Exception("The length of localizations and values are not the same.");
    }

    return Localizations(localizations: localizations, values: values);
  }
}

@embedded
class Locale {
  @Enumerated(EnumType.ordinal)
  Language language;
  bool romanized;

  Locale({this.language = Language.none, this.romanized = false});

  /// Returns a locale based on a string.
  ///
  /// Throws an exception if the language is not supported.
  factory Locale.fromJsonValue(String locale) {
    final isRomanized = locale.endsWith("-ro");
    final language = Language.values.firstWhere(
      (e) => isRomanized ? e.isoCode == locale.replaceFirst("-ro", "") : e.isoCode == locale,
      orElse: () => throw Exception("Language $locale is not supported."),
    );

    return Locale(language: language, romanized: isRomanized);
  }

  @override
  operator ==(Object other) {
    if (other is Locale) {
      return language == other.language && romanized == other.romanized;
    }
    return false;
  }

  @override
  int get hashCode => language.hashCode ^ romanized.hashCode;

  static Locale en = Locale(language: Language.english, romanized: false);
  static Locale ja = Locale(language: Language.japanese, romanized: false);
  static Locale zh = Locale(language: Language.simpleChinese, romanized: false);
  static Locale zhHk = Locale(language: Language.traditionalChinese, romanized: false);

  static Locale jaRo = Locale(language: Language.japanese, romanized: true);
  static Locale zhRo = Locale(language: Language.simpleChinese, romanized: true);
  static Locale zhHkRo = Locale(language: Language.traditionalChinese, romanized: true);
}

// CAUTION: DO NOT CHANGE THE ORDER OF THE ENUMS
enum Language {
  none("none"),
  english("en"),
  japanese("ja"),
  simpleChinese("zh"),
  traditionalChinese("zh-hk"),
  korean("ko");

  final String isoCode;
  const Language(this.isoCode);
}
