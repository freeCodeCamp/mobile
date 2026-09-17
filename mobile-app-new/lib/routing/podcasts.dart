import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app_new/podcasts/models/episode_model.dart';
import 'package:mobile_app_new/podcasts/models/podcast_model.dart';
import 'package:mobile_app_new/podcasts/ui/downloads/downloads_view.dart';
import 'package:mobile_app_new/podcasts/ui/episode/episode_view.dart';
import 'package:mobile_app_new/podcasts/ui/episode_list/episode_list_view.dart';
import 'package:mobile_app_new/podcasts/ui/episode_list/episode_list_viewmodel.dart';
import 'package:mobile_app_new/podcasts/ui/podcast_list/podcast_list_view.dart';
import 'package:mobile_app_new/podcasts/ui/podcasts_shell.dart';

part 'podcasts.g.dart';

const podcastListPath = '/podcasts';
const podcastDownloadsPath = '/podcasts/downloads';
const podcastEpisodeListPath = '/podcasts/:podcastId';
const podcastEpisodePath = '/podcasts/:podcastId/:episodeId';

@TypedShellRoute<PodcastsShellRoute>(
  routes: [
    TypedGoRoute<PodcastListRoute>(path: podcastListPath),
    TypedGoRoute<PodcastDownloadsRoute>(path: podcastDownloadsPath),
  ],
)
class PodcastsShellRoute extends ShellRouteData {
  const PodcastsShellRoute();

  @override
  Widget builder(BuildContext context, GoRouterState state, Widget navigator) {
    return PodcastsShell(child: navigator);
  }
}

class PodcastListRoute extends GoRouteData with $PodcastListRoute {
  const PodcastListRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      const NoTransitionPage(child: PodcastListView());
}

class PodcastDownloadsRoute extends GoRouteData with $PodcastDownloadsRoute {
  const PodcastDownloadsRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      const NoTransitionPage(child: PodcastDownloadsView());
}

@TypedGoRoute<PodcastEpisodeListRoute>(path: podcastEpisodeListPath)
class PodcastEpisodeListRoute extends GoRouteData
    with $PodcastEpisodeListRoute {
  const PodcastEpisodeListRoute({
    required this.podcastId,
    this.downloaded = false,
  });

  final String podcastId;
  final bool downloaded;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      PodcastEpisodeListView(
        source: downloaded
            ? PodcastEpisodeSource.downloaded(podcastId)
            : PodcastEpisodeSource.remote(podcastId),
      );
}

@TypedGoRoute<PodcastEpisodeRoute>(path: podcastEpisodePath)
class PodcastEpisodeRoute extends GoRouteData with $PodcastEpisodeRoute {
  const PodcastEpisodeRoute({
    required this.podcastId,
    required this.episodeId,
    required this.$extra,
  });

  final String podcastId;
  final String episodeId;

  // NOTE: Required rather than nullable. There is a single-episode endpoint
  // that would let this route resolve from its path alone, but nothing
  // deep-links to podcasts today and notification deep-linking is a
  // post-migration feature, so the fallback is not built yet. Safe only while
  // that stays true AND MaterialApp.router has no restorationScopeId.
  final (Podcast, Episode) $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      PodcastEpisodeView(podcast: $extra.$1, episode: $extra.$2);
}
