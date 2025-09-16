package com.example.current_app_detector

import android.app.usage.UsageEvents
import android.app.usage.UsageStatsManager
import android.content.Context
import android.content.Intent
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class CurrentAppDetectorPlugin : FlutterPlugin, MethodCallHandler {
    private lateinit var channel: MethodChannel
    private lateinit var context: Context

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        context = flutterPluginBinding.applicationContext
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "current_app_detector")
        channel.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "goHome" -> goHome(result)
            "getCurrentApp" -> getCurrentApp(result)
            "getUsagePermission" -> getUsagePermission(result)
            else -> result.notImplemented()
        }
    }

    private fun goHome(result: Result) {
        try {
            val intent = Intent(Intent.ACTION_MAIN)
            intent.addCategory(Intent.CATEGORY_HOME)
            intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
            context.startActivity(intent)
            result.success(true)
        } catch (e: Exception) {
            result.error("GO_HOME_ERROR", "Failed to go home: ${e.message}", null)
        }
    }

    private fun getUsagePermission(result :Result){
      try {
            // Check current permission status
            val hasPermission = hasUsageStatsPermission()
            
            if (hasPermission) {
                result.success("granted")
            } else {
                // Open the usage access settings screen
                val intent = Intent(Settings.ACTION_USAGE_ACCESS_SETTINGS)
                intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
                context.startActivity(intent)
                result.success("need_permission")
            }
        } catch (e: Exception) {
            result.error("PERMISSION_ERROR", "Failed to handle permission request: ${e.message}", null)
        }
    }


     private fun hasUsageStatsPermission(): Boolean {
        val appOps = context.getSystemService(Context.APP_OPS_SERVICE) as android.app.AppOpsManager
        val mode = appOps.checkOpNoThrow(
            android.app.AppOpsManager.OPSTR_GET_USAGE_STATS,
            android.os.Process.myUid(),
            context.packageName
        )
        return mode == android.app.AppOpsManager.MODE_ALLOWED
    }


    

    private fun getCurrentApp(result: Result) {
        try {
            val usageStatsManager = context.getSystemService(Context.USAGE_STATS_SERVICE) as UsageStatsManager
            val endTime = System.currentTimeMillis()
            val beginTime = endTime - 10000 // check last 10 seconds

            val usageEvents = usageStatsManager.queryEvents(beginTime, endTime)
            var lastApp: String? = null
            val event = UsageEvents.Event()

            while (usageEvents.hasNextEvent()) {
                usageEvents.getNextEvent(event)
                if (event.eventType == UsageEvents.Event.MOVE_TO_FOREGROUND) {
                    lastApp = event.packageName
                }
            }

            if (lastApp != null) {
                result.success(lastApp)
            } else {
                result.error("NO_APP_FOUND", "No foreground app detected", null)
            }
        } catch (e: SecurityException) {
            result.error("PERMISSION_DENIED", "Usage stats permission required", null)
        } catch (e: Exception) {
            result.error("UNKNOWN_ERROR", "Failed to get current app: ${e.message}", null)
        }
    }
}