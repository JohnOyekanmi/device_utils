enum AppType {
  all,
  system,
  user,
}

extension AppTypeExtension on AppType {
  String get name {
    switch (this) {
      case AppType.all:
        return 'all';
      case AppType.system:
        return 'system';
      case AppType.user:
        return 'user';
    }
  }
}

extension StringToAppType on String {
  AppType toAppType() {
    switch (this) {
      case 'all':
        return AppType.all;
      case 'system':
        return AppType.system;
      case 'user':
        return AppType.user;
      default:
        throw ArgumentError('Invalid app type: $this');
    }
  }
}
