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
		ExperimentalThemeManager.instance.pref.addListener(onThemeChange);
	}

	@override
	void dispose() {
		WidgetsBinding.instance.removeObserver(this);
		ExperimentalThemeManager.instance.pref.removeListener(onThemeChange);
		super.dispose();
	}

	void onThemeChange() {
		setState(() => {});
	}

	@override
	Widget build(BuildContext context) {
		return ValueListenableBuilder(
			valueListenable: ExperimentalThemeManager.instance.pref,
			builder: (context, value, _) {
				return MaterialApp(
					theme: ExperimentalThemeManager.instance.theme,
					themeMode: value.themeMode,
					debugShowCheckedModeBanner: false,
					initialRoute: Router.home,
					onGenerateRoute: Router.onGenerateRoute,
				);
			},
		);
	}

	@override
	void didChangePlatformBrightness() {
		ExperimentalThemeManager.instance.refreshBrightness();
		super.didChangePlatformBrightness();
	}
}
