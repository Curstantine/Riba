import 'package:flutter/material.dart' hide Router;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riba/utils/router.dart';
import 'package:riba/utils/settings.dart';
import 'package:riba/utils/theme.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Hive and its adapters
  await Hive.initFlutter();
  Hive.registerAdapter(ThemeIdAdapter());
  Hive.registerAdapter(ThemeModeAdapter());

  await Settings.init();
  await ThemeManager.init();

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
