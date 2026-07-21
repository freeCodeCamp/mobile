import 'package:go_router/go_router.dart';
import 'package:mobile_app_new/main.dart';
import 'package:mobile_app_new/router/news.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) =>
          const MyHomePage(title: 'Flutter Demo Home Page'),
    ),
    ...newsRoutes,
  ],
);
