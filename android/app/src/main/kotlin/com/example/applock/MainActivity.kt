package com.example.applock

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

import android.content.Context
import android.content.ContextWrapper
import android.content.Intent
import android.content.IntentFilter
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
            else {
                result.notImplemented()
            }
        }
    }

    private fun getBatteryLevel(): Int {
        val batteryLevel: Int
        if(VERSION.SDK_INT >= VERSION_CODES.LOLLIPOP) {
            val batteryManager = getSystemService(android.content.Context.BATTERY_SERVICE) as android.os.BatteryManager
            batteryLevel = batteryManager.getIntProperty(android.os.BatteryManager.BATTERY_PROPERTY_CAPACITY)
        }
        else {
            var intent = android.content.ContextWrapper(applicationContext).registerReceiver(null, IntentFilter(
                android.content.Intent.ACTION_BATTERY_CHANGED))
            batteryLevel = intent!!.getIntExtra(android.os.BatteryManager.EXTRA_LEVEL, -1) * 100 / intent.getIntExtra(
                android.os.BatteryManager.EXTRA_SCALE, -1)
        }
        return batteryLevel
    }
}
