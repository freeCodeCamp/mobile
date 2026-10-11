// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'learn.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
  $learnLandingRoute,
  $learnDailyChallengeArchiveRoute,
  $learnDailyChallengeRoute,
  $learnSuperBlockRoute,
  $learnModuleRoute,
  $learnChallengeRoute,
];

RouteBase get $learnLandingRoute => GoRouteData.$route(
  path: '/learn',
  hasOverriddenOnExit: false,
  factory: $LearnLandingRoute._fromState,
);

mixin $LearnLandingRoute on GoRouteData {
  static LearnLandingRoute _fromState(GoRouterState state) =>
      const LearnLandingRoute();

  @override
  String get location => GoRouteData.$location('/learn');

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

RouteBase get $learnDailyChallengeArchiveRoute => GoRouteData.$route(
  path: '/learn/daily-challenges',
  hasOverriddenOnExit: false,
  factory: $LearnDailyChallengeArchiveRoute._fromState,
);

mixin $LearnDailyChallengeArchiveRoute on GoRouteData {
  static LearnDailyChallengeArchiveRoute _fromState(GoRouterState state) =>
      const LearnDailyChallengeArchiveRoute();

  @override
  String get location => GoRouteData.$location('/learn/daily-challenges');

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

RouteBase get $learnDailyChallengeRoute => GoRouteData.$route(
  path: '/learn/daily-challenges/:day',
  hasOverriddenOnExit: false,
  factory: $LearnDailyChallengeRoute._fromState,
);

mixin $LearnDailyChallengeRoute on GoRouteData {
  static LearnDailyChallengeRoute _fromState(GoRouterState state) =>
      LearnDailyChallengeRoute(day: state.pathParameters['day']!);

  LearnDailyChallengeRoute get _self => this as LearnDailyChallengeRoute;

  @override
  String get location => GoRouteData.$location(
    '/learn/daily-challenges/${Uri.encodeComponent(_self.day)}',
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

RouteBase get $learnSuperBlockRoute => GoRouteData.$route(
  path: '/learn/:superBlock',
  hasOverriddenOnExit: false,
  factory: $LearnSuperBlockRoute._fromState,
);

mixin $LearnSuperBlockRoute on GoRouteData {
  static LearnSuperBlockRoute _fromState(GoRouterState state) =>
      LearnSuperBlockRoute(superBlock: state.pathParameters['superBlock']!);

  LearnSuperBlockRoute get _self => this as LearnSuperBlockRoute;

  @override
  String get location =>
      GoRouteData.$location('/learn/${Uri.encodeComponent(_self.superBlock)}');

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

RouteBase get $learnModuleRoute => GoRouteData.$route(
  path: '/learn/:superBlock/:module',
  hasOverriddenOnExit: false,
  factory: $LearnModuleRoute._fromState,
);

mixin $LearnModuleRoute on GoRouteData {
  static LearnModuleRoute _fromState(GoRouterState state) => LearnModuleRoute(
    superBlock: state.pathParameters['superBlock']!,
    module: state.pathParameters['module']!,
  );

  LearnModuleRoute get _self => this as LearnModuleRoute;

  @override
  String get location => GoRouteData.$location(
    '/learn/${Uri.encodeComponent(_self.superBlock)}/${Uri.encodeComponent(_self.module)}',
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

RouteBase get $learnChallengeRoute => GoRouteData.$route(
  path: '/learn/:superBlock/:block/:challengeId',
  hasOverriddenOnExit: false,
  factory: $LearnChallengeRoute._fromState,
);

mixin $LearnChallengeRoute on GoRouteData {
  static LearnChallengeRoute _fromState(GoRouterState state) =>
      LearnChallengeRoute(
        superBlock: state.pathParameters['superBlock']!,
        block: state.pathParameters['block']!,
        challengeId: state.pathParameters['challengeId']!,
      );

  LearnChallengeRoute get _self => this as LearnChallengeRoute;

  @override
  String get location => GoRouteData.$location(
    '/learn/${Uri.encodeComponent(_self.superBlock)}/${Uri.encodeComponent(_self.block)}/${Uri.encodeComponent(_self.challengeId)}',
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
