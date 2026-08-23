// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [$newsShellRoute];

RouteBase get $newsShellRoute => ShellRouteData.$route(
  factory: $NewsShellRouteExtension._fromState,
  routes: [
    GoRouteData.$route(
      path: '/news/bookmarks',
      hasOverriddenOnExit: false,
      factory: $NewsBookmarksRoute._fromState,
    ),
    GoRouteData.$route(
      path: '/news',
      hasOverriddenOnExit: false,
      factory: $NewsFeedRoute._fromState,
    ),
    GoRouteData.$route(
      path: '/news/search',
      hasOverriddenOnExit: false,
      factory: $NewsSearchRoute._fromState,
    ),
  ],
);

extension $NewsShellRouteExtension on NewsShellRoute {
  static NewsShellRoute _fromState(GoRouterState state) =>
      const NewsShellRoute();
}

mixin $NewsBookmarksRoute on GoRouteData {
  static NewsBookmarksRoute _fromState(GoRouterState state) =>
      const NewsBookmarksRoute();

  @override
  String get location => GoRouteData.$location('/news/bookmarks');

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

mixin $NewsFeedRoute on GoRouteData {
  static NewsFeedRoute _fromState(GoRouterState state) => const NewsFeedRoute();

  @override
  String get location => GoRouteData.$location('/news');

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

mixin $NewsSearchRoute on GoRouteData {
  static NewsSearchRoute _fromState(GoRouterState state) =>
      const NewsSearchRoute();

  @override
  String get location => GoRouteData.$location('/news/search');

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
