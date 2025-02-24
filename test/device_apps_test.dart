import 'package:device_apps/device_apps.dart';
import 'package:device_apps/device_apps_method_channel.dart';
import 'package:device_apps/device_apps_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockDeviceUtilsPlatform
    with MockPlatformInterfaceMixin
    implements DeviceAppsPlatform {
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
  final DeviceAppsPlatform initialPlatform = DeviceAppsPlatform.instance;

  test('$MethodChannelDeviceApps is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelDeviceApps>());
  });

  test('getPlatformVersion', () async {
    MockDeviceUtilsPlatform fakePlatform = MockDeviceUtilsPlatform();
    DeviceAppsPlatform.instance = fakePlatform;

    expect(await DeviceApps.getPlatformVersion(), '42');
  });
}
