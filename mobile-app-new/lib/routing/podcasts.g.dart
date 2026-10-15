// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'podcasts.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
  $podcastsShellRoute,
  $podcastEpisodeListRoute,
  $podcastEpisodeRoute,
];

RouteBase get $podcastsShellRoute => ShellRouteData.$route(
  factory: $PodcastsShellRouteExtension._fromState,
  routes: [
    GoRouteData.$route(
      path: '/podcasts',
      hasOverriddenOnExit: false,
      factory: $PodcastListRoute._fromState,
    ),
    GoRouteData.$route(
      path: '/podcasts/downloads',
      hasOverriddenOnExit: false,
      factory: $PodcastDownloadsRoute._fromState,
    ),
  ],
);

extension $PodcastsShellRouteExtension on PodcastsShellRoute {
  static PodcastsShellRoute _fromState(GoRouterState state) =>
      const PodcastsShellRoute();
}

mixin $PodcastListRoute on GoRouteData {
  static PodcastListRoute _fromState(GoRouterState state) =>
      const PodcastListRoute();

  @override
  String get location => GoRouteData.$location('/podcasts');

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

mixin $PodcastDownloadsRoute on GoRouteData {
  static PodcastDownloadsRoute _fromState(GoRouterState state) =>
      const PodcastDownloadsRoute();

  @override
  String get location => GoRouteData.$location('/podcasts/downloads');

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

RouteBase get $podcastEpisodeListRoute => GoRouteData.$route(
  path: '/podcasts/:podcastId',
  hasOverriddenOnExit: false,
  factory: $PodcastEpisodeListRoute._fromState,
);

mixin $PodcastEpisodeListRoute on GoRouteData {
  static PodcastEpisodeListRoute _fromState(GoRouterState state) =>
      PodcastEpisodeListRoute(
        podcastId: state.pathParameters['podcastId']!,
        downloaded:
            _$convertMapValue(
              'downloaded',
              state.uri.queryParameters,
              _$boolConverter,
            ) ??
            false,
      );

  PodcastEpisodeListRoute get _self => this as PodcastEpisodeListRoute;

  @override
  String get location => GoRouteData.$location(
    '/podcasts/${Uri.encodeComponent(_self.podcastId)}',
    queryParams: {
      if (_self.downloaded != false) 'downloaded': _self.downloaded.toString(),
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

T? _$convertMapValue<T>(
  String key,
  Map<String, String> map,
  T? Function(String) converter,
) {
  final value = map[key];
  return value == null ? null : converter(value);
}

bool _$boolConverter(String value) {
  switch (value) {
    case 'true':
      return true;
    case 'false':
      return false;
    default:
      throw UnsupportedError('Cannot convert "$value" into a bool.');
  }
}

RouteBase get $podcastEpisodeRoute => GoRouteData.$route(
  path: '/podcasts/:podcastId/:episodeId',
  hasOverriddenOnExit: false,
  factory: $PodcastEpisodeRoute._fromState,
);

mixin $PodcastEpisodeRoute on GoRouteData {
  static PodcastEpisodeRoute _fromState(GoRouterState state) =>
      PodcastEpisodeRoute(
        podcastId: state.pathParameters['podcastId']!,
        episodeId: state.pathParameters['episodeId']!,
        $extra: state.extra as (Podcast, Episode),
      );

  PodcastEpisodeRoute get _self => this as PodcastEpisodeRoute;

  @override
  String get location => GoRouteData.$location(
    '/podcasts/${Uri.encodeComponent(_self.podcastId)}/${Uri.encodeComponent(_self.episodeId)}',
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
