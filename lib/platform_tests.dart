import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      .map((app) => app.name)
      .fold("", (previousValue, element) => "$previousValue, $element")
      .substring(2);
  print("Installed Apps: $appList");
}

SharedPreferences? prefs;
String lockedPackagesKey = "locked";
List<String> lockedPackages = [];

void initPrefs() async {
  prefs = await SharedPreferences.getInstance();
}

void loadLockedPackages() {
  lockedPackages = prefs!.getStringList(lockedPackagesKey) ?? [];
}

void addLockedPackage(String packageName) async {
  lockedPackages.add(packageName);
  await prefs!.setStringList(lockedPackagesKey, lockedPackages);
}

void removeLockedPackage(String packageName) async {
  lockedPackages.remove(packageName);
  await prefs!.setStringList(lockedPackagesKey, lockedPackages);
}

void removeLockedPackageAt(int i) async {
  lockedPackages.removeAt(i);
  await prefs!.setStringList(lockedPackagesKey, lockedPackages);
}
