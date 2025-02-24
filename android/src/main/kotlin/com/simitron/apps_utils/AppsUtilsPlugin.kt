package com.simitron.apps_utils

import android.content.Context
import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import android.util.Log

/** AppsUtilsPlugin */
class AppsUtilsPlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private lateinit var context: Context

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    context = flutterPluginBinding.applicationContext
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "apps_utils")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
      "getPlatformVersion" -> handleGetPlatformVersion(result)
      "getInstalledApps" -> handleGetInstalledApps(call, result)
      "openSystemApp" -> handleOpenSystemApp(call, result)
      "launchApp" -> handleLaunchApp(call, result)
      "openAppSettings" -> handleOpenAppSettings(call, result)
      else -> result.notImplemented()
    }
  }

  private fun handleGetPlatformVersion(result: Result) {
    result.success("Android ${android.os.Build.VERSION.RELEASE}")
  }

  private fun handleGetInstalledApps(call: MethodCall, result: Result) {
    try {
      val appType = call.argument<String>("appType") ?: "all"
      val includeIcons = call.argument<Boolean>("includeIcons") ?: false
      val appFetcher = AppFetcher(context)
      val apps = appFetcher.getInstalledApps(appType, includeIcons)
      
      val appMaps = try {
        apps.map { it.toMap() }.also { maps ->
          Log.d("AppFetcher", "Created ${maps.size} maps")
          Log.d("AppFetcher", "First map example: ${maps.firstOrNull()}")
        }
      } catch (e: Exception) {
        Log.e("AppFetcher", "Error converting apps to maps", e)
        result.error("MAP_CONVERSION_ERROR", "Failed to convert apps to maps: ${e.message}", null)
        return
      }

      try {
        result.success(appMaps)
        Log.d("AppFetcher", "Successfully sent data to Flutter")
      } catch (e: Exception) {
        Log.e("AppFetcher", "Error sending data to Flutter", e)
        result.error("RESULT_ERROR", "Failed to send data to Flutter: ${e.message}", null)
      }
    } catch (e: Exception) {
      Log.e("AppFetcher", "Error in handleGetInstalledApps", e)
      result.error("APP_FETCH_ERROR", e.message, null)
    }
  }

  private fun handleOpenSystemApp(call: MethodCall, result: Result) {
    try {
      val appName = call.argument<String>("appName")
        ?: throw Exception("appName is required")
      val appLauncher = AppLauncher(context)
      appLauncher.openSystemApp(appName)
      result.success(null)
    } catch (e: Exception) {
      result.error("LAUNCH_ERROR", e.message, null)
    }
  }

  private fun handleLaunchApp(call: MethodCall, result: Result) {
    try {
      val packageName = call.argument<String>("packageName")
        ?: throw Exception("packageName is required")
      val appLauncher = AppLauncher(context)
      appLauncher.launchApp(packageName)
      result.success(null)
    } catch (e: Exception) {
      result.error("LAUNCH_ERROR", e.message, null)
    }
  }

  private fun handleOpenAppSettings(call: MethodCall, result: Result) {
    try {
      val packageName = call.argument<String>("packageName")
        ?: throw Exception("packageName is required")
      val appLauncher = AppLauncher(context)
      appLauncher.openAppSettings(packageName)
      result.success(null)
    } catch (e: Exception) {
      result.error("SETTINGS_ERROR", e.message, null)
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}



// package com.simitron.apps_utils

// import android.content.Context
// import androidx.annotation.NonNull

// import io.flutter.embedding.engine.plugins.FlutterPlugin
// import io.flutter.plugin.common.MethodCall
// import io.flutter.plugin.common.MethodChannel
// import io.flutter.plugin.common.MethodChannel.MethodCallHandler
// import io.flutter.plugin.common.MethodChannel.Result

// /** AppsUtilsPlugin */
// class AppsUtilsPlugin: FlutterPlugin, MethodCallHandler {
//   /// The MethodChannel that will the communication between Flutter and native Android
//   ///
//   /// This local reference serves to register the plugin with the Flutter Engine and unregister it
//   /// when the Flutter Engine is detached from the Activity
//   private lateinit var channel : MethodChannel

//   override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
//     channel = MethodChannel(flutterPluginBinding.binaryMessenger, "apps_utils")
//     channel.setMethodCallHandler(this)
//   }

//   override fun onMethodCall(call: MethodCall, result: Result) {
//     when (call.method) {

//       // Get the platform version.
//       "getPlatformVersion" -> {
//         result.success("Android ${android.os.Build.VERSION.RELEASE}")
//       }
      
//       // Get all installed apps.
//       "getInstalledApps" -> try {
//         val appType = call.argument<String>("appType") ?: "all"
//         val includeIcons = call.argument<Boolean>("includeIcons") ?: false
//         val appFetcher = AppFetcher(context)
//         val apps = appFetcher.getInstalledApps(appType, includeIcons)
        
//         // Convert AppInfo objects to maps for Flutter using toMap()
//         val appMaps = apps.map { it.toMap() }
//         result.success(appMaps)
//       } catch (e: Exception) {
//         result.error("APP_FETCH_ERROR", e.message, null)
//       }
      
//       // Open a specific system application.
//       "openSystemApp" -> try {
//         val appName = call.argument<String>("appName")
//           ?: throw Exception("appName is required")
//         val appLauncher = AppLauncher(context)
//         appLauncher.openSystemApp(appName)
//         result.success(null)
//       } catch (e: Exception) {
//         result.error("LAUNCH_ERROR", e.message, null)
//       }
      
//       // Launch an app with a given package name.
//       "launchApp" -> try {
//         val packageName = call.argument<String>("packageName")
//           ?: throw Exception("packageName is required")
//         val appLauncher = AppLauncher(context)
//         appLauncher.launchApp(packageName)
//         result.success(null)
//       } catch (e: Exception) {
//         result.error("LAUNCH_ERROR", e.message, null)
//       }

//       // Open the settings for an app with a given package name.
//       "openAppSettings" -> try {
//         val packageName = call.argument<String>("packageName")
//           ?: throw Exception("packageName is required")
//         val appLauncher = AppLauncher(context)
//         appLauncher.openAppSettings(packageName)
//         result.success(null)
//       } catch (e: Exception) {
//         result.error("SETTINGS_ERROR", e.message, null)
//       }
      
//       else -> result.notImplemented()
//     }
//   }

//   override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
//     channel.setMethodCallHandler(null)
//   }
// }
