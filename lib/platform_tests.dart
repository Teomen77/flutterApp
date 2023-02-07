import 'package:flutter/services.dart';

const platform = MethodChannel("com.applock.dev/test");

Future<List<AppInfo>> getInstalledApps() async {
  List<dynamic> appList = await platform.invokeMethod("getInstalledApps");
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

void printAppList(List<AppInfo> appInfoList) {
  String? appList = appInfoList
      .map((app) => app.packageName)
      .fold("", (previousValue, element) => "$previousValue, $element")
      .substring(2);
  print("Installed Apps: $appList");
}
