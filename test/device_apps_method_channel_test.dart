import 'package:device_apps/device_apps_method_channel.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelDeviceApps platform = MethodChannelDeviceApps();
  const MethodChannel channel = MethodChannel('device_apps');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });

  test('getInstalledApps', () async {
    expect(await platform.getInstalledApps(), []);
  });

  test('openSystemApp', () async {
    await platform.openSystemApp('com.simitron.device_apps');
  });

  test('launchApp', () async {
    await platform.launchApp('com.simitron.device_apps');
  });

  test('openAppSettings', () async {
    await platform.openAppSettings('com.simitron.device_apps');
  });

  test('getInstalledApps with appType', () async {
    expect(await platform.getInstalledApps(appType: 'system'), []);
  });

  test('getInstalledApps with includeIcons', () async {
    expect(await platform.getInstalledApps(includeIcons: true), []);
  });

  test('openSystemApp', () async {
    await platform.openSystemApp('com.simitron.device_apps');
  });

  test('launchApp', () async {
    await platform.launchApp('com.simitron.device_apps');
  });
}
