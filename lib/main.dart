import 'package:applock/Lock/lock_app.dart';
import 'package:applock/Pages/home_page.dart';
import 'package:applock/app_lock_list.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const String title = 'Applock';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: HomePage());
  }
}

// Custom entry point when the lock screen intent is launched via the AccessibilityService
@pragma('vm:entry-point')
void mainLock(List<String> args) {
  String openedPackage = args[0];
  print(openedPackage);

  if (isPackageLocked(openedPackage)) {
    runApp(const LockApp());
  }
}
