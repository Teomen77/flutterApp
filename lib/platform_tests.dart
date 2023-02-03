import 'package:flutter/services.dart';

const platform = MethodChannel("com.applock.dev/test");

Future<int> getBatteryLevel() async {
  int batteryLevel = await platform.invokeMethod("getBatteryLevel");
  return batteryLevel;
}
