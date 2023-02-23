import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/widgets.dart';
import 'package:freecodecamp/app/app.router.dart';

class AnalyticsObserver extends RouteObserver {
  AnalyticsObserver({required this.analytics});

  final FirebaseAnalytics analytics;

  void _sendScreenView(Route<dynamic> route) {
    String screenName = route.settings.name ?? 'could-not-find-view';

    if (route.settings.arguments != null) {
      if (route.settings.arguments.runtimeType == SuperBlockViewArguments) {
        final routeArgs = route.settings.arguments as SuperBlockViewArguments;
        screenName += '/${routeArgs.superBlockDashedName}';
      } else if (route.settings.arguments.runtimeType ==
          NewsTutorialViewArguments) {
        final routeArgs = route.settings.arguments as NewsTutorialViewArguments;
        screenName += '/${routeArgs.title}';
      } else if (route.settings.arguments.runtimeType ==
          NewsBookmarkTutorialViewArguments) {
        final routeArgs =
            route.settings.arguments as NewsBookmarkTutorialViewArguments;
        screenName += '/${routeArgs.tutorial.tutorialTitle}';
      } else {
        screenName += '/${route.settings.arguments}';
      }
    }
    print('Setting screen to $screenName');
    analytics.setCurrentScreen(
        screenName: screenName, screenClassOverride: screenName);
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _sendScreenView(route);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute != null) {
      _sendScreenView(newRoute);
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute != null) {
      _sendScreenView(previousRoute);
    }
  }
}
