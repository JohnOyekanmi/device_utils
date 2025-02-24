import 'package:apps_utils/apps_utils.dart';
import 'package:apps_utils/apps_utils_method_channel.dart';
import 'package:apps_utils/apps_utils_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockDeviceUtilsPlatform
    with MockPlatformInterfaceMixin
    implements AppsUtilsPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<List<Map<String, dynamic>>> getInstalledApps({
    String appType = 'all',
    bool includeIcons = false,
  }) =>
      Future.value([]);

  @override
  Future<void> openSystemApp(String appName) => Future.value();

  @override
  Future<void> launchApp(String packageName) => Future.value();

  @override
  Future<void> openAppSettings(String packageName) => Future.value();
}

void main() {
  final AppsUtilsPlatform initialPlatform = AppsUtilsPlatform.instance;

  test('$MethodChannelAppsUtils is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelAppsUtils>());
  });

  test('getPlatformVersion', () async {
    MockDeviceUtilsPlatform fakePlatform = MockDeviceUtilsPlatform();
    AppsUtilsPlatform.instance = fakePlatform;

    expect(await AppsUtils.getPlatformVersion(), '42');
  });
}
