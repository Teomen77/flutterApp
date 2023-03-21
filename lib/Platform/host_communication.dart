import 'package:flutter/services.dart';

const platformChannel = MethodChannel("com.applock.dev/platform");

Future<List<AppInfo>> getInstalledApps() async {
  List<dynamic> appList =
      await platformChannel.invokeMethod("getInstalledApps");
  List<AppInfo> appInfoList =
      appList.map((app) => AppInfo.create(app)).toList();
  return appInfoList;
}

class AppInfo {
  String? name;
  String? packageName;

  AppInfo(this.name, this.packageName);

  factory AppInfo.create(dynamic data) {
    return AppInfo(data["name"], data["package_name"]);
  }
}

Future<void> lockPackage(String packageName) async {
  await platformChannel
      .invokeMethod("lockPackage", <String, dynamic>{"value": packageName});
}

Future<void> unlockPackage(String packageName) async {
  await platformChannel.invokeMapMethod(
      "unlockPackage", <String, dynamic>{"value": packageName});
}

Future<bool> isPackageLocked(String packageName) async {
  return await platformChannel.invokeMethod("isPackageLocked");
}
