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
///
/// ### Note
/// This model doesn't implement an eq operator, as it is impossible to do that
/// without losing performance.
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

  /// Returns the preferred localization based on the list of locales.
  ///
  /// If the preferred locale is not found, the first localization is returned.
  String getPreferred(List<Locale> locales) {
    for (final locale in locales) {
      final loc = get(locale);
      if (loc != null) return loc;
    }

    return values.first;
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

  @override
  // ignore: hash_and_equals
  operator ==(Object other) {
    throw UnimplementedError();
  }
}

@embedded
class Locale {
  @Enumerated(EnumType.ordinal)
  Language language;
  bool romanized;

  Locale({this.language = Language.none, this.romanized = false});

  String get code => romanized ? "${language.isoCode}-ro" : language.isoCode;

  /// Returns a locale based on a string.
  ///
  /// Throws an exception if the language is not supported.
  factory Locale.fromJsonValue(String locale) {
    final roman = locale.endsWith("-ro");
    final language = Language.fromIsoCode(roman ? locale.substring(0, locale.length - 3) : locale);
    return Locale(language: language, romanized: roman);
  }

  @override
  int get hashCode => language.hashCode ^ romanized.hashCode;

  @override
  operator ==(Object other) =>
      identical(this, other) ||
      (other is Locale &&
          runtimeType == other.runtimeType &&
          language == other.language &&
          romanized == other.romanized);

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

  static Language fromIsoCode(String isoCode) {
    return values.firstWhere(
      (e) => e.isoCode == isoCode,
      orElse: () => throw Exception("Language $isoCode is not supported."),
    );
  }

  static Map<Language, String> humanNames = {
    Language.none: "None",
    Language.english: "English",
    Language.japanese: "Japanese",
    Language.simpleChinese: "Simplified Chinese",
    Language.traditionalChinese: "Traditional Chinese",
    Language.korean: "Korean",
  };

  String get human => humanNames[this]!;
}
