import "package:flutter/material.dart" hide Router;
import "package:hive_flutter/hive_flutter.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:riba/repositories/database.dart";
import "package:riba/settings/theme.dart";
import "package:riba/utils/router.dart";
import "package:riba/settings/settings.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Database.init();
  await Settings.init();

  runApp(const ProviderScope(child: App()));
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
      themeMode: Settings.instance.theme.mode,
      theme: Settings.instance.theme.theme,
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
