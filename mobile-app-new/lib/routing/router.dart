import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app_new/routing/code_radio.dart' as code_radio_routes;
import 'package:mobile_app_new/routing/learn.dart' as learn_routes;
import 'package:mobile_app_new/routing/news.dart' as news_routes;

final _initialLocation = const learn_routes.LearnLandingRoute().location;

final router = GoRouter(
  debugLogDiagnostics: kDebugMode,
  initialLocation: _initialLocation,
  routes: [
    ...learn_routes.$appRoutes,
    ...news_routes.$appRoutes,
    ...code_radio_routes.$appRoutes,
  ],
  errorBuilder: (context, state) => Scaffold(
    appBar: AppBar(title: const Text('Page Not Found')),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SelectableText(state.error?.toString() ?? 'page not found'),
          TextButton(
            onPressed: () => context.go(_initialLocation),
            child: const Text('Go Home'),
          ),
        ],
      ),
    ),
  ),
);
