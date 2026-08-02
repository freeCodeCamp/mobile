import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app_new/home_page.dart';

part 'learn.g.dart';

const learnLandingPath = '/learn';

@TypedGoRoute<LearnLandingRoute>(path: learnLandingPath)
class LearnLandingRoute extends GoRouteData with $LearnLandingRoute {
  const LearnLandingRoute({this.title = 'Hello there'});

  final String title;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return MyHomePage(title: title);
  }
}
