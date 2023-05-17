import "package:flutter/material.dart" hide Router;
import "package:riba/utils/router.dart";
import "package:riba/utils/theme.dart";

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
		ThemeManager.instance.pref.addListener(onThemeChange);
	}

	@override
	void dispose() {
		WidgetsBinding.instance.removeObserver(this);
		ThemeManager.instance.pref.removeListener(onThemeChange);
		super.dispose();
	}

	void onThemeChange() =>	setState(() => {});
	
	@override
	Widget build(BuildContext context) {
		return MaterialApp(
			theme: ThemeManager.instance.theme,
			themeMode: ThemeManager.instance.pref.value.themeMode,
			debugShowCheckedModeBanner: false,
			initialRoute: Router.home,
			onGenerateRoute: Router.onGenerateRoute,
		);
	}

	@override
	void didChangePlatformBrightness() {
		ThemeManager.instance.refreshBrightness();
		super.didChangePlatformBrightness();
	}
}
