import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'device_apps_method_channel.dart';

abstract class DeviceAppsPlatform extends PlatformInterface {
  /// Constructs a DeviceUtilsPlatform.
  DeviceAppsPlatform() : super(token: _token);

  static final Object _token = Object();

  static DeviceAppsPlatform _instance = MethodChannelDeviceApps();

  /// The default instance of [DeviceAppsPlatform] to use.
  ///
  /// Defaults to [MethodChannelDeviceApps].
  static DeviceAppsPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [DeviceAppsPlatform] when
  /// they register themselves.
  static set instance(DeviceAppsPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  /// Get all installed apps.
  Future<List<Map<String, dynamic>>> getInstalledApps({
    String appType = 'all',
    bool includeIcons = false,
  });

  /// Open a specific system application.
  Future<void> openSystemApp(String appName);

  /// Launch an app with a given package name.
  Future<void> launchApp(String packageName);

  /// Open the settings for an app with a given package name.
  Future<void> openAppSettings(String packageName);
}
