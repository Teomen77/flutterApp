import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences? prefs;
String prefKey = "locked";
List<String> lockedPackages = [];

Future<void> initAppLocking() async {
  await initPrefs();
  loadLockedPackages();
}

Future<void> initPrefs() async {
  prefs = await SharedPreferences.getInstance();
}

void loadLockedPackages() {
  lockedPackages = prefs!.getStringList(prefKey) ?? [];
}

Future<void> lockPackage(String packageName) async {
  lockedPackages.add(packageName);
  await prefs!.setStringList(prefKey, lockedPackages);
}

Future<void> unlockPackage(String packageName) async {
  lockedPackages.remove(packageName);
  await prefs!.setStringList(prefKey, lockedPackages);
}

Future<void> unlockPackageAt(int i) async {
  if (i < 0 || i >= lockedPackages.length) {
    return;
  }
  lockedPackages.removeAt(i);
  await prefs!.setStringList(prefKey, lockedPackages);
}

bool isPackageLocked(String packageName) {
  return lockedPackages.contains(packageName);
}
