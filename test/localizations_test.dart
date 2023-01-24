import "package:flutter_test/flutter_test.dart";
import "package:riba/repositories/local/localization.dart";

void main() {
  test("String.toLocale", () {
    expect("en".toLocale(), Locale.en);

    expect("ja".toLocale(), Locale.ja);
    expect("zh".toLocale(), Locale.zh);
    expect("zh-hk".toLocale(), Locale.zhHk);

    expect("ja-ro".toLocale(), Locale.jaRo);
    expect("zh-ro".toLocale(), Locale.zhRo);
    expect("zh-hk-ro".toLocale(), Locale.zhHkRo);
  });

  test("Localizations.toLocalizations", () {
    final locales = {
      "en": "English",
      "ja": "Japanese",
      "zh": "Chinese",
    };

    final localizations = locales.toLocalizations();
    expect(localizations.get(Locale.en), "English");
    expect(localizations.get(Locale.ja), "Japanese");
    expect(localizations.get(Locale.zh), "Chinese");

    expect(localizations.localizations.length, localizations.values.length);
  });
}
