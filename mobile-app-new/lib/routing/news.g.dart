// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
  $newsShellRoute,
  $newsImageRoute,
  $newsTagFeedRoute,
  $newsAuthorRoute,
  $newsPostRoute,
];

RouteBase get $newsShellRoute => ShellRouteData.$route(
  factory: $NewsShellRouteExtension._fromState,
  routes: [
    GoRouteData.$route(
      path: '/news/bookmarks',
      hasOverriddenOnExit: false,
      factory: $NewsBookmarksRoute._fromState,
    ),
    GoRouteData.$route(
      path: '/news',
      hasOverriddenOnExit: false,
      factory: $NewsFeedRoute._fromState,
    ),
    GoRouteData.$route(
      path: '/news/search',
      hasOverriddenOnExit: false,
      factory: $NewsSearchRoute._fromState,
    ),
  ],
);

extension $NewsShellRouteExtension on NewsShellRoute {
  static NewsShellRoute _fromState(GoRouterState state) =>
      const NewsShellRoute();
}

mixin $NewsBookmarksRoute on GoRouteData {
  static NewsBookmarksRoute _fromState(GoRouterState state) =>
      const NewsBookmarksRoute();

  @override
  String get location => GoRouteData.$location('/news/bookmarks');

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

mixin $NewsFeedRoute on GoRouteData {
  static NewsFeedRoute _fromState(GoRouterState state) => const NewsFeedRoute();

  @override
  String get location => GoRouteData.$location('/news');

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

mixin $NewsSearchRoute on GoRouteData {
  static NewsSearchRoute _fromState(GoRouterState state) =>
      const NewsSearchRoute();

  @override
  String get location => GoRouteData.$location('/news/search');

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

RouteBase get $newsImageRoute => GoRouteData.$route(
  path: '/news/image',
  hasOverriddenOnExit: false,
  factory: $NewsImageRoute._fromState,
);

mixin $NewsImageRoute on GoRouteData {
  static NewsImageRoute _fromState(GoRouterState state) =>
      NewsImageRoute($extra: state.extra as String);

  NewsImageRoute get _self => this as NewsImageRoute;

  @override
  String get location => GoRouteData.$location('/news/image');

  @override
  void go(BuildContext context) => context.go(location, extra: _self.$extra);

  @override
  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: _self.$extra);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: _self.$extra);

  @override
  void replace(BuildContext context) =>
      context.replace(location, extra: _self.$extra);
}

RouteBase get $newsTagFeedRoute => GoRouteData.$route(
  path: '/news/tag/:tagSlug',
  hasOverriddenOnExit: false,
  factory: $NewsTagFeedRoute._fromState,
);

mixin $NewsTagFeedRoute on GoRouteData {
  static NewsTagFeedRoute _fromState(GoRouterState state) => NewsTagFeedRoute(
    tagSlug: state.pathParameters['tagSlug']!,
    $extra: state.extra as String?,
  );

  NewsTagFeedRoute get _self => this as NewsTagFeedRoute;

  @override
  String get location =>
      GoRouteData.$location('/news/tag/${Uri.encodeComponent(_self.tagSlug)}');

  @override
  void go(BuildContext context) => context.go(location, extra: _self.$extra);

  @override
  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: _self.$extra);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: _self.$extra);

  @override
  void replace(BuildContext context) =>
      context.replace(location, extra: _self.$extra);
}

RouteBase get $newsAuthorRoute => GoRouteData.$route(
  path: '/news/author/:username',
  hasOverriddenOnExit: false,
  factory: $NewsAuthorRoute._fromState,
);

mixin $NewsAuthorRoute on GoRouteData {
  static NewsAuthorRoute _fromState(GoRouterState state) => NewsAuthorRoute(
    username: state.pathParameters['username']!,
    $extra: state.extra as Author?,
  );

  NewsAuthorRoute get _self => this as NewsAuthorRoute;

  @override
  String get location => GoRouteData.$location(
    '/news/author/${Uri.encodeComponent(_self.username)}',
  );

  @override
  void go(BuildContext context) => context.go(location, extra: _self.$extra);

  @override
  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: _self.$extra);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: _self.$extra);

  @override
  void replace(BuildContext context) =>
      context.replace(location, extra: _self.$extra);
}

RouteBase get $newsPostRoute => GoRouteData.$route(
  path: '/news/:slug',
  hasOverriddenOnExit: false,
  factory: $NewsPostRoute._fromState,
);

mixin $NewsPostRoute on GoRouteData {
  static NewsPostRoute _fromState(GoRouterState state) =>
      NewsPostRoute(slug: state.pathParameters['slug']!);

  NewsPostRoute get _self => this as NewsPostRoute;

  @override
  String get location =>
      GoRouteData.$location('/news/${Uri.encodeComponent(_self.slug)}');

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
