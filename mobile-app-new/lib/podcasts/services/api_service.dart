import 'dart:developer';

import 'package:mobile_app_new/podcasts/constants.dart';
import 'package:mobile_app_new/podcasts/models/episode_model.dart';
import 'package:mobile_app_new/podcasts/models/podcast_model.dart';
import 'package:mobile_app_new/podcasts/repositories/api_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'api_service.g.dart';

typedef EpisodesPage = ({
  Podcast podcast,
  List<Episode> episodes,
  bool hasMore,
});

const _episodesPerPage = 20;

@riverpod
PodcastApiService podcastApiService(Ref ref) {
  final repo = ref.watch(podcastApiRepositoryProvider);
  return PodcastApiService(repo);
}

class PodcastApiService {
  final PodcastApiRepository _repo;

  PodcastApiService(this._repo);

  Future<List<Podcast>> getPodcasts() async {
    final podcasts = [
      for (final raw in await _repo.getPodcasts()) ?_toPodcast(raw),
    ];

    return [
      ...podcasts.where((podcast) => fccPodcastUrls.contains(podcast.feedUrl)),
      ...podcasts.where((podcast) => !fccPodcastUrls.contains(podcast.feedUrl)),
    ];
  }

  Podcast? _toPodcast(Map<String, dynamic> raw) {
    try {
      return Podcast.fromJson(raw);
    } catch (e) {
      log('Podcast ${raw['_id']} is missing required fields; skipping ($e)');
      return null;
    }
  }

  Future<EpisodesPage> getEpisodes(String podcastId, {int page = 0}) async {
    final raw = await _repo.getEpisodes(podcastId, page: page);

    final playable = raw.episodes.where((episode) {
      final url = episode['audioUrl'];
      if (url is String && url.isNotEmpty) return true;

      // TODO: Capture in Crashlytics so we can fix by adding the missing audioUrl to the API
      log('Podcast episode ${episode['_id']} has no audioUrl; skipping');
      return false;
    });

    return (
      podcast: Podcast.fromJson(raw.podcast),
      episodes: playable.map(Episode.fromJson).toList(),
      hasMore: raw.episodes.length >= _episodesPerPage,
    );
  }
}
