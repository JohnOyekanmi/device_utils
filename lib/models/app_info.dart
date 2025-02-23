/// A class that represents an app.
///
/// This class is used to store information about an application on the device.
///
/// The [appName] is the name of the app.
/// The [packageName] is the package name of the app.
/// The [isSystemApp] is whether the app is a system app.
/// The [icon] is the icon of the app as bytes.
class AppInfo {
  /// The name of the app.
  final String appName;

  /// The package name of the app.
  final String packageName;

  /// Whether the app is a system app.
  final bool isSystemApp;

  /// The icon of the app as bytes.
  final List<int>? icon;

  /// Constructor for the [AppInfo] class.
  const AppInfo({
    required this.appName,
    required this.packageName,
    required this.isSystemApp,
    this.icon,
  });

  /// Create a new [AppInfo] object from a JSON object.
  factory AppInfo.fromJson(Map<String, dynamic> json) {
    return AppInfo(
      appName: json['appName'] as String? ?? '',
      packageName: json['packageName'] as String? ?? '',
      isSystemApp: json['isSystemApp'] as bool? ?? false,
      icon: json['icon'] != null ? List<int>.from(json['icon']) : null,
    );
  }

  /// Create a list of [AppInfo] objects from a list of JSON objects.
  static List<AppInfo> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((json) => AppInfo.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Create a JSON object from an [AppInfo] object.
  Map<String, dynamic> toJson() {
    return {
      'appName': appName,
      'packageName': packageName,
      'isSystemApp': isSystemApp,
      'icon': icon,
    };
  }

  @override
  String toString() {
    return 'AppInfo(appName: $appName, packageName: $packageName, isSystemApp: $isSystemApp, hasIcon: ${icon != null})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! AppInfo) return false;

    return appName == other.appName &&
        packageName == other.packageName &&
        isSystemApp == other.isSystemApp &&
        _listEquals(icon, other.icon);
  }

  bool _listEquals<T>(List<T>? a, List<T>? b) {
    if (a == null) return b == null;
    if (b == null || a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  @override
  int get hashCode {
    return Object.hash(
      appName,
      packageName,
      isSystemApp,
      icon == null ? null : Object.hashAll(icon!),
    );
  }
}
