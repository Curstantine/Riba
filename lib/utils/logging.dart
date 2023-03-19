import "dart:developer";

import "package:logging/logging.dart";

class Logging {
  static bool _initialized = false;
  static late final Logging instance;
  Logging._internal();

  static void init() {
    if (_initialized) throw Exception("Logging is already initialized.");

    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((record) {
      log(
        record.message,
        name: record.loggerName,
        level: record.level.value,
        error: record.error,
        stackTrace: record.stackTrace,
      );
    });

    instance = Logging._internal();
    _initialized = true;
  }
}
