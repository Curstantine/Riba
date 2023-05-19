import "package:flutter/material.dart" hide Router;
import "package:riba/utils/router.dart";
import "package:riba/utils/theme.dart";

class App extends StatefulWidget {
	const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
	@override
	void initState() {
		super.initState();
		ThemeManager.instance.themeId.addListener(onThemeChange);
	}

	@override
	void dispose() {
		ThemeManager.instance.themeId.removeListener(onThemeChange);
		super.dispose();
	}

	void onThemeChange() => setState(() => {});

	@override
	Widget build(BuildContext context) {
		return MaterialApp(
			theme: ThemeManager.instance.lightTheme,
			darkTheme: ThemeManager.instance.darkTheme,
			themeMode: ThemeManager.instance.themeMode.value,
			debugShowCheckedModeBanner: false,
			initialRoute: Router.home,
			onGenerateRoute: Router.onGenerateRoute,
		);
	}
}
