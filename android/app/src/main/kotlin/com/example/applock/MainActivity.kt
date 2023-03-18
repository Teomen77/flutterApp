package com.example.applock

import android.accessibilityservice.AccessibilityService
import android.content.Intent
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

import android.content.pm.ApplicationInfo
import android.content.pm.PackageManager
import android.os.Build.VERSION
import android.os.Build.VERSION_CODES
import android.os.Bundle
import android.provider.Settings
import android.util.Log
import android.view.accessibility.AccessibilityEvent

class AppOpeningAccessibilityService : AccessibilityService() {
    override fun onAccessibilityEvent(event: AccessibilityEvent?) {
        if(event?.eventType == AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED) {
            Log.d("AccessibilityService", "Package opened: " + event?.packageName)
        }
    }

    override fun onInterrupt() {}
}

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.applock.dev/platform"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        val accessibilityService = Intent(this, AppOpeningAccessibilityService::class.java)
        startService(accessibilityService)

        val intent = Intent(Settings.ACTION_ACCESSIBILITY_SETTINGS)
        startActivity(intent)

        Log.d("Applock", "Main activity started!")
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            if(call.method == "getInstalledApps") {
                val installedApps = getInstalledApps()
                result.success(installedApps)
            }
            else {
                result.notImplemented()
            }
        }
    }

    private fun getInstalledApps(): List<Map<String, Any?>> {
        val packageManager = activity.packageManager as PackageManager

        val appList: List<ApplicationInfo>
        if(VERSION.SDK_INT >= VERSION_CODES.TIRAMISU) {
            appList = packageManager.getInstalledApplications(PackageManager.ApplicationInfoFlags.of(0))
        }
        else {
            appList = packageManager.getInstalledApplications(0)
        }
        var filteredList = appList.filter { app -> !isSystemApp(packageManager, app.packageName) }

        var mappedList = filteredList.map {app -> appToMap(packageManager, app)}
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
