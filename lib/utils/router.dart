import "package:flutter/material.dart";
import "package:riba/routes/root.dart";
import "package:riba/routes/settings/views/page.dart";

class Router {
	static const String home = "/";
	static const String settings = "/settings";

	static Route? onGenerateRoute(RouteSettings rt) {
		switch (rt.name) {
			case home:
				return MaterialPageRoute(builder: (_) => const RootView());
			case settings:
				return MaterialPageRoute(builder: (_) => const SettingsView());
		}

		return null;
	}
}
