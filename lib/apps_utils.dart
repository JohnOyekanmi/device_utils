import 'apps_utils_platform_interface.dart';
import 'models/app_info.dart';
import 'models/app_type.dart';
import 'models/system_apps.dart';

// exports - This makes the models available to the outside world without having to import each model file.
export 'models/app_info.dart';
export 'models/app_type.dart';
export 'models/system_apps.dart';

class AppsUtils {
  /// Returns the current platform version.
  static Future<String?> getPlatformVersion() {
    return AppsUtilsPlatform.instance.getPlatformVersion();
  }

  /// Gets a list of installed applications.
  ///
  /// [appType] can be [AppType.all], [AppType.system], or [AppType.user].
  /// [includeIcons] determines whether to include app icons in the response.
  ///
  /// Returns a list of [AppInfo] objects containing details about each installed app.
  static Future<List<AppInfo>> getInstalledApps({
    AppType appType = AppType.all,
    bool includeIcons = false,
  }) async {
    final List<Map<String, dynamic>> response =
        await AppsUtilsPlatform.instance.getInstalledApps(
      appType: appType.name,
      includeIcons: includeIcons,
    );

    return AppInfo.fromJsonList(response);
  }

  /// Opens a system application.
  ///
  /// [appName] can be one of: 'calendar', 'camera', 'clock', 'phone', 'settings'.
  /// Throws an exception if the app cannot be opened.
  ///
  /// See [SystemApps] for a list of supported system applications.
  static Future<void> openSystemApp(String appName) {
    return AppsUtilsPlatform.instance.openSystemApp(appName);
  }

  /// Launches an application by its package name.
  ///
  /// [packageName] is the full package name of the app (e.g., 'com.example.app').
  /// Throws an exception if the app cannot be launched.
  static Future<void> launchApp(String packageName) {
    return AppsUtilsPlatform.instance.launchApp(packageName);
  }

  /// Opens the system settings page for an application.
  ///
  /// [packageName] is the full package name of the app (e.g., 'com.example.app').
  /// Throws an exception if the settings cannot be opened.
  static Future<void> openAppSettings(String packageName) {
    return AppsUtilsPlatform.instance.openAppSettings(packageName);
  }
}
