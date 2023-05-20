import "package:flutter_test/flutter_test.dart";
import "package:riba/repositories/local/models/cover_art.dart";
import "package:riba/repositories/local/models/localization.dart";
import "package:riba/utils/logging.dart";

import "constants.dart";

void main() {
  Logging.init();

  group("Locale", () {
    test("fromJsonValue", () {
      expect(Locale.fromJson("en"), Locale.en);

      expect(Locale.fromJson("ja"), Locale.ja);
      expect(Locale.fromJson("zh"), Locale.zh);
      expect(Locale.fromJson("zh-hk"), Locale.zhHk);

      expect(Locale.fromJson("ja-ro"), Locale.jaRo);
      expect(Locale.fromJson("zh-ro"), Locale.zhRo);
      expect(Locale.fromJson("zh-hk-ro"), Locale.zhHkRo);
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
  group("ImageFileType", () {
    test("fromExtension", () {
      final file = coverFile.split(".");
      expect(ImageFileType.fromExtension(file.last), ImageFileType.png);
    });
  });
}
