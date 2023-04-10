import "package:dash_flags/dash_flags.dart" as flag;
import "package:isar/isar.dart";
import "package:logging/logging.dart";
import "package:riba/repositories/utils/exception.dart";

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
/// localizations[0] == Locale.English && values[0] == "English Title"
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

  static final logger = Logger("Localizations");

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

    for (final i in map.entries) {
      final value = i.value;
      final key = i.key;

      try {
        localizations.add(Locale.fromJsonValue(key));
        values.add(value);
      } on LanguageNotSupportedException catch (e) {
        logger.warning("Ignoring $key: ${e.toString()}");
      }
    }

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
  /// Throws a [LanguageNotSupportedException] if the language is not supported.
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
  static Locale ko = Locale(language: Language.korean, romanized: false);
  static Locale fr = Locale(language: Language.french, romanized: false);
  static Locale ru = Locale(language: Language.russian, romanized: false);
  static Locale vi = Locale(language: Language.vietnamese, romanized: false);
  static Locale ptBr = Locale(language: Language.portugueseBrazil, romanized: false);
  static Locale id = Locale(language: Language.indonesian, romanized: false);

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
  korean("ko"),
  french("fr"),
  russian("ru"),
  vietnamese("vi"),
  portugueseBrazil("pt-br"),
  indonesian("id");

  final String isoCode;
  const Language(this.isoCode);

  /// Returns a language based on an ISO code.
  ///
  /// Throws a [LanguageNotSupportedException] if the language is not supported.
  static Language fromIsoCode(String isoCode) {
    return values.firstWhere(
      (e) => e.isoCode == isoCode,
      orElse: () => throw LanguageNotSupportedException(isoCode),
    );
  }

  static Map<Language, String> _humanNames = {
    Language.none: "None",
    Language.english: "English",
    Language.japanese: "Japanese",
    Language.simpleChinese: "Simplified Chinese",
    Language.traditionalChinese: "Traditional Chinese",
    Language.korean: "Korean",
    Language.french: "French",
    Language.russian: "Russian",
    Language.vietnamese: "Vietnamese",
    Language.portugueseBrazil: "Portuguese (Brazil)",
    Language.indonesian: "Indonesian",
  };

  static Map<Language, flag.Language> _flagLanguages = {
    Language.english: flag.Language.en,
    Language.japanese: flag.Language.ja,
    Language.simpleChinese: flag.Language.zh,
    Language.traditionalChinese: flag.Language.zh_TW,
    Language.korean: flag.Language.ko,
    Language.french: flag.Language.fr,
    Language.russian: flag.Language.ru,
    Language.vietnamese: flag.Language.vi,
    Language.portugueseBrazil: flag.Language.pt_br,
    Language.indonesian: flag.Language.id,
  };

  String get human => _humanNames[this]!;
  flag.Language get flagLanguage => _flagLanguages[this]!;
}
