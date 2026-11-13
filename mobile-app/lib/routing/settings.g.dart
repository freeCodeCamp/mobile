// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
  $settingsRoute,
  $settingsDeleteAccountRoute,
  $downloadsRoute,
];

RouteBase get $settingsRoute => GoRouteData.$route(
  path: '/settings',
  hasOverriddenOnExit: false,
  factory: $SettingsRoute._fromState,
);

mixin $SettingsRoute on GoRouteData {
  static SettingsRoute _fromState(GoRouterState state) => const SettingsRoute();

  @override
  String get location => GoRouteData.$location('/settings');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $settingsDeleteAccountRoute => GoRouteData.$route(
  path: '/settings/delete-account',
  hasOverriddenOnExit: false,
  factory: $SettingsDeleteAccountRoute._fromState,
);

mixin $SettingsDeleteAccountRoute on GoRouteData {
  static SettingsDeleteAccountRoute _fromState(GoRouterState state) =>
      const SettingsDeleteAccountRoute();

  @override
  String get location => GoRouteData.$location('/settings/delete-account');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $downloadsRoute => GoRouteData.$route(
  path: '/settings/downloads',
  hasOverriddenOnExit: false,
  factory: $DownloadsRoute._fromState,
);

mixin $DownloadsRoute on GoRouteData {
  static DownloadsRoute _fromState(GoRouterState state) =>
      const DownloadsRoute();

  @override
  String get location => GoRouteData.$location('/settings/downloads');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}
