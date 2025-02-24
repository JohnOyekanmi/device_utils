# apps_utils

A Flutter plugin for managing device applications, including fetching installed apps, launching system apps, and handling app settings. Currently supports Android devices only.

## Features

- Get list of installed applications
- Launch system applications (camera, clock, etc.)
- Open application settings
- Launch specific applications by package name

## Platform Support

| Android | iOS | MacOS | Web | Linux | Windows |
|---------|-----|-------|-----|--------|---------|
| ✅      | ❌   | ❌     | ❌   | ❌      | ❌       |

## Getting Started

### Required Permissions

Add these permissions to your Android Manifest (`android/app/src/main/AndroidManifest.xml`):

```xml
<!-- Required for fetching installed applications -->
<uses-permission android:name="android.permission.QUERY_ALL_PACKAGES" />
<!-- Required for launching clock/alarm application -->
<uses-permission android:name="com.android.alarm.permission.SET_ALARM" />
```

### Installation

```yaml
dependencies:
  apps_utils: ^latest_version
```

## Usage

### Import the package
```dart
import 'package:apps_utils/apps_utils.dart';
import 'package:apps_utils/models/system_apps.dart';
```

### Get Installed Applications
```dart
// Get all installed apps with icons
final apps = await DeviceUtils.getInstalledApps(
  appType: AppType.all,  // Options: all, system, user
  includeIcons: true,    // Whether to include app icons
);
```

### Launch System Applications
```dart
// Open calendar
await DeviceUtils.openSystemApp(SystemApps.calendar);

// Open camera
await DeviceUtils.openSystemApp(SystemApps.camera);

// Open clock
await DeviceUtils.openSystemApp(SystemApps.clock);

// Open phone
await DeviceUtils.openSystemApp(SystemApps.phone);

// Open settings
await DeviceUtils.openSystemApp(SystemApps.settings);
```

### Launch Specific Application
```dart
// Launch an app using its package name
await DeviceUtils.launchApp('com.example.package');
```

### Open App Settings
```dart
// Open settings for a specific app
await DeviceUtils.openAppSettings('com.example.package');
```

## Example

For a complete implementation example, please check the [example](example) directory in the repository. The example demonstrates:
- Fetching and displaying installed applications
- Launching system apps
- Opening app settings
- Handling errors and permissions

## Notes

- This plugin currently supports Android devices only
- The `QUERY_ALL_PACKAGES` permission is required for fetching installed applications
- The `SET_ALARM` permission is specifically required for opening the clock application
- Some features might behave differently across different Android versions and manufacturer implementations

## Contributing

Feel free to contribute to this project by submitting issues and/or pull requests.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

