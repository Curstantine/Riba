import "package:meta/meta.dart";
import "package:package_info_plus/package_info_plus.dart";

class InitPackageInfo {
  final PackageInfo info;

  InitPackageInfo._internal(this.info);

  static late final InitPackageInfo instance;

  static Future<void> initPlatform() async {
    instance = InitPackageInfo._internal(await PackageInfo.fromPlatform());
  }

  @visibleForTesting
  static void initMock() {
    instance = InitPackageInfo._internal(PackageInfo(
      appName: "Riba",
      packageName: "moe.curstantine.riba",
      version: "0.0.0-testing",
      buildNumber: "0",
    ));
  }
}
