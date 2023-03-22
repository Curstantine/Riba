import "package:flutter/material.dart" show runApp, WidgetsFlutterBinding;
import "package:hive_flutter/hive_flutter.dart";
import "package:riba/repositories/database.dart";
import "package:riba/settings/settings.dart";
import "package:riba/utils/logging.dart";
import "package:riba/utils/theme.dart";

import "app.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Logging.init();

  await Hive.initFlutter();
  await Database.init();
  await Settings.init();
  await ThemeManager.init();
  runApp(const App());
}
