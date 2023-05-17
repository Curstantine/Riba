import "dart:io";

import "package:meta/meta.dart";
import "package:path_provider/path_provider.dart";

class InitDirectories {
	final Directory supportDir;
	final Directory documentDir;
	final Directory cacheDir;

	InitDirectories._internal(this.supportDir, this.documentDir, this.cacheDir);

	static late final InitDirectories instance;

	static Future<void> initPlatform() async {
		final dirs = await Future.wait([
			getApplicationSupportDirectory(),
			getApplicationDocumentsDirectory(),
			getTemporaryDirectory(),
		]);

		instance = InitDirectories._internal(dirs[0], dirs[1], dirs[2]);
	}

	@visibleForTesting
	static void initMock() {
		final cwd = Directory.current;

		instance = InitDirectories._internal(
			Directory("${cwd.path}/temp/support"),
			Directory("${cwd.path}/temp/documents"),
			Directory("${cwd.path}/temp/cache"),
		);

		instance.supportDir.createSync(recursive: true);
		instance.documentDir.createSync(recursive: true);
		instance.cacheDir.createSync(recursive: true);
	}
}
