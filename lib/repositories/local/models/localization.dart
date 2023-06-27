import "package:dash_flags/dash_flags.dart" as flag;
import "package:isar/isar.dart";
import "package:logging/logging.dart";
import "package:riba/repositories/mangadex/utils/serde_ext.dart";
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
	final List<Locale> localizations;
	final List<String> values;

	/// Used by isar to instantiate the class on the database.
	/// 
	/// Do not use the default constructor.
	Localizations({
		this.localizations = const [],
		this.values = const [],
	});

	Localizations.withValues({
		required this.localizations,
		required this.values,
	});

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
				localizations.add(Locale.fromJson(key));
				values.add(value);
			} on LanguageNotSupportedException catch (e) {
				logger.warning("Ignoring $key: ${e.toString()}");
			}
		}

		if (localizations.length != values.length) {
			throw Exception("The length of localizations and values are not the same.");
		}

		return Localizations.withValues(localizations: localizations, values: values);
	}
}

@embedded
class Locale implements SerializableDataExt {
	@Enumerated(EnumType.ordinal)
	Language language;
	bool romanized;

	Locale({this.language = Language.english, this.romanized = false});

	/// Returns a locale based on a string.
	///
	/// Throws a [LanguageNotSupportedException] if the language is not supported.
	factory Locale.fromJson(String locale) {
		final roman = locale.endsWith("-ro");
		final language = Language.fromIsoCode(roman ? locale.substring(0, locale.length - 3) : locale);
		return Locale(language: language, romanized: roman);
	}

	static Locale en = Locale(language: Language.english, romanized: false);
	static Locale ja = Locale(language: Language.japanese, romanized: false);
	static Locale zh = Locale(language: Language.chineseSimplified, romanized: false);
	static Locale zhHk = Locale(language: Language.chineseTraditional, romanized: false);
	static Locale ko = Locale(language: Language.korean, romanized: false);

	static Locale jaRo = Locale(language: Language.japanese, romanized: true);
	static Locale zhRo = Locale(language: Language.chineseSimplified, romanized: true);
	static Locale zhHkRo = Locale(language: Language.chineseTraditional, romanized: true);

	static List<Locale> getAll() {
		final direct = Language.values.map((e) => Locale(language: e, romanized: false));
		return [jaRo, zhRo, zhHkRo, ...direct].toList();
	}

	@override
	String asHumanReadable() {
		return romanized ? "Romanized ${language.asHumanReadable()}" : language.asHumanReadable();
	}
	
	@override
	String toJson() => romanized ? "${language.isoCode}-ro" : language.isoCode;

	@override
	bool operator ==(covariant Locale other) {
		if (identical(this, other)) return true;
	
		return 
		other.language == language &&
		other.romanized == romanized;
	}

	@override
	int get hashCode => language.hashCode ^ romanized.hashCode;
}

// CAUTION: DO NOT CHANGE THE ORDER OF THE ENUMS
enum Language implements SerializableDataExt {
	english("en"),
	albanian("sq"),
	arabic("ar"),
	azerbaijani("az"),
	bengali("bn"),
	bulgarian("bg"),
	burmese("my"),
	catalan("ca"),
	chineseSimplified("zh"),
	chineseTraditional("zh-hk"),
	croatian("hr"),
	czech("cs"),
	danish("da"),
	dutch("nl"),
	esperanto("eo"),
	estonian("et"),
	filipino("tl"),
	finnish("fi"),
	french("fr"),
	georgian("ka"),
	german("de"),
	greek("el"),
	hebrew("he"),
	hindi("hi"),
	hungarian("hu"),
	indonesian("id"),
	italian("it"),
	japanese("ja"),
	kazakh("kk"),
	korean("ko"),
	latin("la"),
	lithuanian("lt"),
	malay("ms"),
	mongolian("mn"),
	nepali("ne"),
	norwegian("no"),
	persian("fa"),
	polish("pl"),
	portuguese("pt"),
	portugueseBrazil("pt-br"),
	romanian("ro"),
	russian("ru"),
	serbian("sr"),
	slovak("sk"),
	spanish("es"),
	spanishLatinAmerica("es-la"),
	swedish("sv"),
	tamil("ta"),
	telugu("te"),
	thai("th"),
	turkish("tr"),
	ukrainian("uk"),
	vietnamese("vi");


	final String isoCode;
	const Language(this.isoCode);

	/// Returns a language based on an ISO code.
	///
	/// Throws a [LanguageNotSupportedException] if the language is not supported.
	factory Language.fromIsoCode(String isoCode) {
		return values.firstWhere(
			(e) => e.isoCode == isoCode,
			orElse: () => throw LanguageNotSupportedException(isoCode),
		);
	}	

	@override
	String toJson() => isoCode;

	@override
	String asHumanReadable() {
		// plz kill me
		switch (this) {
			case Language.english:
				return "English";
			case Language.albanian:
				return "Albanian";
			case Language.arabic:
				return "Arabic";
			case Language.azerbaijani:
				return "Azerbaijani";
			case Language.bengali:
				return "Bengali";
			case Language.bulgarian:
				return "Bulgarian";
			case Language.burmese:
				return "Burmese";
			case Language.catalan:
				return "Catalan";
			case Language.chineseSimplified:
				return "Chinese (Simplified)";
			case Language.chineseTraditional:
				return "Chinese (Traditional)";
			case Language.croatian:
				return "Croatian";
			case Language.czech:
				return "Czech";
			case Language.danish:
				return "Danish";
			case Language.dutch:
				return "Dutch";
			case Language.esperanto:
				return "Esperanto";
			case Language.estonian:
				return "Estonian";
			case Language.filipino:
				return "Filipino";
			case Language.finnish:
				return "Finnish";
			case Language.french:
				return "French";
			case Language.georgian:
				return "Georgian";
			case Language.german:
				return "German";
			case Language.greek:
				return "Greek";
			case Language.hebrew:
				return "Hebrew";
			case Language.hindi:
				return "Hindi";
			case Language.hungarian:
				return "Hungarian";
			case Language.indonesian:
				return "Indonesian";
			case Language.italian:
				return "Italian";
			case Language.japanese:
				return "Japanese";
			case Language.kazakh:
				return "Kazakh";
			case Language.korean:
				return "Korean";
			case Language.latin:
				return "Latin";
			case Language.lithuanian:
				return "Lithuanian";
			case Language.malay:
				return "Malay";
			case Language.mongolian:
				return "Mongolian";
			case Language.nepali:
				return "Nepali";
			case Language.norwegian:
				return "Norwegian";
			case Language.persian:
				return "Persian";
			case Language.polish:
				return "Polish";
			case Language.portuguese:
				return "Portuguese";
			case Language.portugueseBrazil:
				return "Portuguese (Brazil)";
			case Language.romanian:
				return "Romanian";
			case Language.russian:
				return "Russian";
			case Language.serbian:
				return "Serbian";
			case Language.slovak:
				return "Slovak";
			case Language.spanish:
				return "Spanish";
			case Language.spanishLatinAmerica:
				return "Spanish (Latin America)";
			case Language.swedish:
				return "Swedish";
			case Language.tamil:
				return "Tamil";
			case Language.telugu:
				return "Telugu";
			case Language.thai:
				return "Thai";
			case Language.turkish:
				return "Turkish";
			case Language.ukrainian:
				return "Ukrainian";
			case Language.vietnamese:
				return "Vietnamese";
		}
	}

	flag.Language getFlag() => flag.Language.fromCode(isoCode);	
}
