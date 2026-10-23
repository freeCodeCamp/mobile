// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'code_radio.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [$codeRadioRoute];

RouteBase get $codeRadioRoute => GoRouteData.$route(
  path: '/code-radio',
  hasOverriddenOnExit: false,
  factory: $CodeRadioRoute._fromState,
);

mixin $CodeRadioRoute on GoRouteData {
  static CodeRadioRoute _fromState(GoRouterState state) =>
      const CodeRadioRoute();

  @override
  String get location => GoRouteData.$location('/code-radio');

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
