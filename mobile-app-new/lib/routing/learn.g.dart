// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'learn.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [$learnLandingRoute];

RouteBase get $learnLandingRoute => GoRouteData.$route(
  path: '/learn',
  hasOverriddenOnExit: false,
  factory: $LearnLandingRoute._fromState,
);

mixin $LearnLandingRoute on GoRouteData {
  static LearnLandingRoute _fromState(GoRouterState state) => LearnLandingRoute(
    title: state.uri.queryParameters['title'] ?? 'Hello there',
  );

  LearnLandingRoute get _self => this as LearnLandingRoute;

  @override
  String get location => GoRouteData.$location(
    '/learn',
    queryParams: {if (_self.title != 'Hello there') 'title': _self.title},
  );

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
