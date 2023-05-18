import "package:flutter/material.dart" hide Router;
import "package:riba/utils/router.dart";
import "package:riba/utils/theme.dart";

class App extends StatelessWidget {
	const App({super.key});
	
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
