import "package:flutter/material.dart" hide Router;
import "package:riba/utils/router.dart";
import "package:riba/utils/theme.dart";

import "settings/settings.dart";

class App extends StatefulWidget {
	const App({super.key});

	@override
	State<App> createState() => _AppState();
}

class _AppState extends State<App> {
	late final themeRefreshHook = ThemeManager.useAppRefreshHook(setState: setState);

	@override
	void initState() {
		super.initState();
		themeRefreshHook.init();
	}

	@override
	void dispose() {
		themeRefreshHook.dispose();
		super.dispose();
	}

	@override
	Widget build(BuildContext context) {
		return MaterialApp(
			theme: ThemeManager.instance.lightTheme,
			darkTheme: ThemeManager.instance.darkTheme,
			themeMode: Settings.instance.appearance.themeMode.value,
			debugShowCheckedModeBanner: false,
			initialRoute: Router.home,
			onGenerateRoute: Router.onGenerateRoute,
		);
	}
}
