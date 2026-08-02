// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [$newsFeedRoute];

RouteBase get $newsFeedRoute => GoRouteData.$route(
  path: '/news',
  hasOverriddenOnExit: false,
  factory: $NewsFeedRoute._fromState,
);

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
