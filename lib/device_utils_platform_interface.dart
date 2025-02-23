import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'device_utils_method_channel.dart';

abstract class DeviceUtilsPlatform extends PlatformInterface {
  /// Constructs a DeviceUtilsPlatform.
  DeviceUtilsPlatform() : super(token: _token);

  static final Object _token = Object();

  static DeviceUtilsPlatform _instance = MethodChannelDeviceUtils();

  /// The default instance of [DeviceUtilsPlatform] to use.
  ///
  /// Defaults to [MethodChannelDeviceUtils].
  static DeviceUtilsPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [DeviceUtilsPlatform] when
  /// they register themselves.
  static set instance(DeviceUtilsPlatform instance) {
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
