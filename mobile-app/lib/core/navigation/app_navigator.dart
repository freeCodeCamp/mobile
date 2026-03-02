// A thin navigation wrapper that does NOT depend on Stacked.
//
// The [AppNavigator] class holds a [GlobalKey<NavigatorState>] that is also
// set on the [MaterialApp], so any code that previously relied on a global
// navigator key can switch to [AppNavigator.navigatorKey] without changing
// call-site logic.
//
// Usage:
//   // Navigate to a named route:
//   AppNavigator.navigateTo(Routes.profileView);
//
//   // Navigate with arguments:
//   AppNavigator.navigateTo(
//     Routes.episodeView,
//     arguments: EpisodeViewArguments(episode: ep, podcast: p),
//   );
//
//   // Pop the top-most route:
//   AppNavigator.pop();

import 'package:flutter/material.dart';

class AppNavigator {
  AppNavigator._();

  /// The single [GlobalKey<NavigatorState>] used throughout the app.
  /// Pass this to [MaterialApp.navigatorKey].
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  // ---------------------------------------------------------------------------
  // Navigation helpers
  // ---------------------------------------------------------------------------

  static NavigatorState? get _navigator => navigatorKey.currentState;

  /// Push a named route onto the navigator.
  static Future<T?> navigateTo<T>(
    String routeName, {
    Object? arguments,
  }) {
    return _navigator!.pushNamed<T>(routeName, arguments: arguments);
  }

  /// Replace the current route with a new named route.
  static Future<T?> replaceWith<T>(
    String routeName, {
    Object? arguments,
  }) {
    return _navigator!.pushReplacementNamed<T, dynamic>(
      routeName,
      arguments: arguments,
    );
  }

  /// Pop the top-most route off the navigator.
  static void pop<T>([T? result]) {
    _navigator?.pop<T>(result);
  }

  /// Pop until the predicate is satisfied (e.g., pop to a specific route).
  static void popUntil(RoutePredicate predicate) {
    _navigator?.popUntil(predicate);
  }

  /// Pop the current route and push a new named route.
  static Future<T?> popAndPushNamed<T>(
    String routeName, {
    Object? arguments,
  }) {
    return _navigator!.popAndPushNamed<T, dynamic>(
      routeName,
      arguments: arguments,
    );
  }
}
