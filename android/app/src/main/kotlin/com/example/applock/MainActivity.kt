package com.example.applock

import android.accessibilityservice.AccessibilityService
import android.content.Context
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
            val packageName = event?.packageName

            // Prevent infinite loop
            if(packageName == getPackageName()) return

            Log.d("AccessibilityService", "Package opened: $packageName")

            // See shared_preferences_android plugin code on GitHub for name and mode reference
            /*
            Some part of the SharedPreferences logic will need to be added here, but then we need to maintain feature parity between
            the shared_preferences_android plugin from Flutter and our custom implementation.

            Having to open an entire FlutterActivity just to check if a certain package is locked on the Dart side is not only very wasteful
            but it also leads to strange black/white screens that lock the entire phone, so definitely not ideal.

            We might need to rethink our strategy for this app. Maybe start with an Android app and add Flutter to that instead of this
            strange two-way setup where Android code is added to a Flutter app, but said code also influences the Flutter app itself
            by starting new activities.

            Lennart
            */
            val shared_prefs = this.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)

            val lockIntent = FlutterActivity.withNewEngine().dartEntrypointArgs(listOf(packageName.toString())).build(this).addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            startActivity(lockIntent)
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
