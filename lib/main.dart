import "package:flutter/foundation.dart";
import "package:flutter/material.dart" show runApp, WidgetsFlutterBinding;
import "package:flutter_animate/flutter_animate.dart";
import "package:riba/utils/database.dart";
import "package:riba/utils/directories.dart";
import "package:riba/utils/logging.dart";
import "package:riba/utils/package_info.dart";
import "package:riba/utils/theme.dart";

import "app.dart";

void main() async {
	WidgetsFlutterBinding.ensureInitialized();
	Logging.init();

	await Future.wait([
		InitDirectories.initPlatform(),
		InitPackageInfo.initPlatform(),
	]);

	await Database.init();
	await ThemeManager.init();

	if (kDebugMode) {
		Animate.restartOnHotReload = true;
	}
	
	runApp(const App());
}
