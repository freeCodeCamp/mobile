import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:freecodecamp/routing/auth.dart' as auth_routes;
import 'package:freecodecamp/routing/code_radio.dart' as code_radio_routes;
import 'package:freecodecamp/routing/learn.dart' as learn_routes;
import 'package:freecodecamp/routing/news.dart' as news_routes;
import 'package:freecodecamp/routing/podcasts.dart' as podcasts_routes;
import 'package:freecodecamp/routing/settings.dart' as settings_routes;
import 'package:go_router/go_router.dart';

final _initialLocation = const learn_routes.LearnLandingRoute().location;

final router = GoRouter(
  debugLogDiagnostics: kDebugMode,
  initialLocation: _initialLocation,
  routes: [
    ...learn_routes.$appRoutes,
    ...news_routes.$appRoutes,
    ...code_radio_routes.$appRoutes,
    ...podcasts_routes.$appRoutes,
    ...auth_routes.$appRoutes,
    ...settings_routes.$appRoutes,
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
