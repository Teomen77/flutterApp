package com.example.applock

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

import android.content.Context
import android.content.ContextWrapper
import android.content.Intent
import android.content.IntentFilter
import android.content.pm.ApplicationInfo
import android.content.pm.PackageManager
import android.os.Build.VERSION
import android.os.Build.VERSION_CODES
import android.os.BatteryManager

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.applock.dev/test"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            if(call.method == "getBatteryLevel") {
                val batteryLevel = getBatteryLevel()
                if(batteryLevel != -1) {
                    result.success(batteryLevel)
                }
                else {
                    result.error("UNAVAILABLE", "Battery level not available", null)
                }
            }
            else if(call.method == "getInstalledApps") {
                val installedApps = getInstalledApps()
                result.success(installedApps)
            }
            else {
                result.notImplemented()
            }
        }
    }

    private fun getBatteryLevel(): Int {
        val batteryLevel: Int
        if(VERSION.SDK_INT >= VERSION_CODES.LOLLIPOP) {
            val batteryManager = getSystemService(Context.BATTERY_SERVICE) as BatteryManager
            batteryLevel = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
        }
        else {
            var intent = ContextWrapper(applicationContext).registerReceiver(null, IntentFilter(
                Intent.ACTION_BATTERY_CHANGED))
            batteryLevel = intent!!.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) * 100 / intent.getIntExtra(
                BatteryManager.EXTRA_SCALE, -1)
        }
        return batteryLevel
    }

    private fun getInstalledApps(): List<Map<String, Any?>> {
        val packageManager = activity.packageManager as PackageManager

        // TODO: Implement check for Tiramisu SDK version and use non-deprecated getInstalledApplications()
        var appList = packageManager.getInstalledApplications(0)
        appList = appList.filter { app -> !isSystemApp(packageManager, app.packageName) }

        var mappedList = appList.map {app -> appToMap(packageManager, app)}
        val comp = Comparator {appA: HashMap<String, Any?>, appB: HashMap<String, Any?> -> appA["name"].toString().lowercase().compareTo(appB["name"].toString().lowercase())}
        mappedList = mappedList.sortedWith(comp)

        return mappedList
    }

    private fun isSystemApp(packageManager: PackageManager, packageName: String): Boolean {
        return packageManager.getLaunchIntentForPackage(packageName) == null
    }

    private fun appToMap(packageManager: PackageManager, app: ApplicationInfo): HashMap<String, Any?> {
        val appMap = HashMap<String, Any?>()
        appMap["name"] = packageManager.getApplicationLabel(app)
        appMap["package_name"] = app.packageName
        return appMap
    }
}
