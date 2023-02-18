import "package:flutter/material.dart" hide Router;
import "package:hive_flutter/hive_flutter.dart";
import "package:riba/repositories/database.dart";
import "package:riba/settings/settings.dart";
import "package:riba/utils/router.dart";
import "package:riba/utils/theme.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Database.init();
  await Settings.init();
  await ThemeManager.init();

  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeManager.instance.mode,
      theme: ThemeManager.instance.theme,
      debugShowCheckedModeBanner: false,
      initialRoute: Router.home,
      onGenerateRoute: Router.onGenerateRoute,
    );
  }

  @override
  void didChangePlatformBrightness() {
    ThemeManager.instance.refresh().then((_) => setState(() => {}));
    super.didChangePlatformBrightness();
  }
}
