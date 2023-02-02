import "package:flutter_test/flutter_test.dart";
import "package:riba/repositories/local/author.dart";
import "package:riba/repositories/local/localization.dart";

void main() {
  group("Locale", () {
    test("fromJsonValue", () {
      expect(Locale.fromJsonValue("en"), Locale.en);

      expect(Locale.fromJsonValue("ja"), Locale.ja);
      expect(Locale.fromJsonValue("zh"), Locale.zh);
      expect(Locale.fromJsonValue("zh-hk"), Locale.zhHk);

      expect(Locale.fromJsonValue("ja-ro"), Locale.jaRo);
      expect(Locale.fromJsonValue("zh-ro"), Locale.zhRo);
      expect(Locale.fromJsonValue("zh-hk-ro"), Locale.zhHkRo);
    });
  });

  group("Localizations", () {
    test("fromMap", () {
      final locales = {
        "en": "English",
        "ja": "Japanese",
        "zh": "Chinese",
      };

      final localizations = Localizations.fromMap(locales);
      expect(localizations.get(Locale.en), "English");
      expect(localizations.get(Locale.ja), "Japanese");
      expect(localizations.get(Locale.zh), "Chinese");

      expect(localizations.localizations.length, localizations.values.length);
    });
  });

  group("Author", () {
    final author1 = Author(
        id: "1",
        name: "Author 1",
        createdAt: DateTime.now(),
        description: Localizations(localizations: [Locale.en], values: ["Author 1"]),
        socials: [],
        version: 1);

    final author1Likely = Author(
        id: "1",
        name: "Author 1",
        createdAt: DateTime.now(),
        description: Localizations(localizations: [Locale.en], values: ["Author 1"]),
        socials: [],
        version: 1);

    final author2 = Author(
        id: "2",
        name: "Author 2",
        createdAt: DateTime.now(),
        description: Localizations(localizations: [Locale.en], values: ["Author 2"]),
        socials: [],
        version: 1);

    test("Equality", () {
      expect(author1.isLooselyEqual(author1), isTrue);
      expect(author1.isLooselyEqual(author1Likely), isTrue);
      expect(author1.isLooselyEqual(author2), isFalse);
    });
  });
}
