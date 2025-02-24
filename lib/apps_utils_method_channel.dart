import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'apps_utils_platform_interface.dart';

/// An implementation of [AppsUtilsPlatform] that uses method channels.
class MethodChannelAppsUtils extends AppsUtilsPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('apps_utils');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<List<Map<String, dynamic>>> getInstalledApps({
    String appType = 'all',
    bool includeIcons = false,
  }) async {
    try {
      final dynamic rawResult = await methodChannel.invokeMethod(
        'getInstalledApps',
        {
          'appType': appType,
          'includeIcons': includeIcons,
        },
      );

      if (rawResult is! List) {
        throw Exception('Expected List but got ${rawResult.runtimeType}');
      }

      return rawResult.map((dynamic item) {
        if (item is! Map) {
          throw Exception('Expected Map but got ${item.runtimeType}');
        }
        return Map<String, dynamic>.from(item);
      }).toList();
    } on PlatformException catch (e) {
      throw Exception('Failed to get installed apps: ${e.message}');
    }
  }

  @override
  Future<void> openSystemApp(String appName) async {
    try {
      await methodChannel.invokeMethod('openSystemApp', {
        'appName': appName,
      });
    } on PlatformException catch (e) {
      throw Exception('Failed to open system app: ${e.message}');
    }
  }

  @override
  Future<void> launchApp(String packageName) async {
    try {
      await methodChannel.invokeMethod('launchApp', {
        'packageName': packageName,
      });
    } on PlatformException catch (e) {
      throw Exception('Failed to launch app: ${e.message}');
    }
  }

  @override
  Future<void> openAppSettings(String packageName) async {
    try {
      await methodChannel.invokeMethod('openAppSettings', {
        'packageName': packageName,
      });
    } on PlatformException catch (e) {
      throw Exception('Failed to open app settings: ${e.message}');
    }
  }
}
