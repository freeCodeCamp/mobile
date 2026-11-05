// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
  $loginRoute,
  $accountRoute,
  $profileRoute,
  $editProfileRoute,
  $profileProjectRoute,
  $profileExperienceRoute,
  $profileVisibilityRoute,
];

RouteBase get $loginRoute => GoRouteData.$route(
  path: '/login',
  hasOverriddenOnExit: false,
  factory: $LoginRoute._fromState,
);

mixin $LoginRoute on GoRouteData {
  static LoginRoute _fromState(GoRouterState state) => const LoginRoute();

  @override
  String get location => GoRouteData.$location('/login');

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

RouteBase get $accountRoute => GoRouteData.$route(
  path: '/account',
  hasOverriddenOnExit: false,
  factory: $AccountRoute._fromState,
);

mixin $AccountRoute on GoRouteData {
  static AccountRoute _fromState(GoRouterState state) => const AccountRoute();

  @override
  String get location => GoRouteData.$location('/account');

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

RouteBase get $profileRoute => GoRouteData.$route(
  path: '/profile',
  hasOverriddenOnExit: false,
  factory: $ProfileRoute._fromState,
);

mixin $ProfileRoute on GoRouteData {
  static ProfileRoute _fromState(GoRouterState state) => const ProfileRoute();

  @override
  String get location => GoRouteData.$location('/profile');

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

RouteBase get $editProfileRoute => GoRouteData.$route(
  path: '/profile/edit',
  hasOverriddenOnExit: false,
  factory: $EditProfileRoute._fromState,
);

mixin $EditProfileRoute on GoRouteData {
  static EditProfileRoute _fromState(GoRouterState state) =>
      const EditProfileRoute();

  @override
  String get location => GoRouteData.$location('/profile/edit');

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

RouteBase get $profileProjectRoute => GoRouteData.$route(
  path: '/profile/edit/project',
  hasOverriddenOnExit: false,
  factory: $ProfileProjectRoute._fromState,
);

mixin $ProfileProjectRoute on GoRouteData {
  static ProfileProjectRoute _fromState(GoRouterState state) =>
      ProfileProjectRoute(projectId: state.uri.queryParameters['project-id']);

  ProfileProjectRoute get _self => this as ProfileProjectRoute;

  @override
  String get location => GoRouteData.$location(
    '/profile/edit/project',
    queryParams: {if (_self.projectId != null) 'project-id': _self.projectId},
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

RouteBase get $profileExperienceRoute => GoRouteData.$route(
  path: '/profile/edit/experience',
  hasOverriddenOnExit: false,
  factory: $ProfileExperienceRoute._fromState,
);

mixin $ProfileExperienceRoute on GoRouteData {
  static ProfileExperienceRoute _fromState(GoRouterState state) =>
      ProfileExperienceRoute(
        experienceId: state.uri.queryParameters['experience-id'],
      );

  ProfileExperienceRoute get _self => this as ProfileExperienceRoute;

  @override
  String get location => GoRouteData.$location(
    '/profile/edit/experience',
    queryParams: {
      if (_self.experienceId != null) 'experience-id': _self.experienceId,
    },
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

RouteBase get $profileVisibilityRoute => GoRouteData.$route(
  path: '/profile/visibility',
  hasOverriddenOnExit: false,
  factory: $ProfileVisibilityRoute._fromState,
);

mixin $ProfileVisibilityRoute on GoRouteData {
  static ProfileVisibilityRoute _fromState(GoRouterState state) =>
      const ProfileVisibilityRoute();

  @override
  String get location => GoRouteData.$location('/profile/visibility');

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
