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
