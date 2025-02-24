import 'package:apps_utils/apps_utils_method_channel.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelAppsUtils platform = MethodChannelAppsUtils();
  const MethodChannel channel = MethodChannel('apps_utils');

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
    await platform.openSystemApp('com.simitron.apps_utils');
  });

  test('launchApp', () async {
    await platform.launchApp('com.simitron.apps_utils');
  });

  test('openAppSettings', () async {
    await platform.openAppSettings('com.simitron.apps_utils');
  });

  test('getInstalledApps with appType', () async {
    expect(await platform.getInstalledApps(appType: 'system'), []);
  });

  test('getInstalledApps with includeIcons', () async {
    expect(await platform.getInstalledApps(includeIcons: true), []);
  });

  test('openSystemApp', () async {
    await platform.openSystemApp('com.simitron.apps_utils');
  });

  test('launchApp', () async {
    await platform.launchApp('com.simitron.apps_utils');
  });
}
