import 'package:collection/collection.dart';
import 'package:freecodecamp/podcasts/controllers/library_controller.dart';
import 'package:freecodecamp/podcasts/models/episode_model.dart';
import 'package:freecodecamp/podcasts/models/podcast_model.dart';
import 'package:freecodecamp/utils/riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'downloaded_episodes_viewmodel.freezed.dart';
part 'downloaded_episodes_viewmodel.g.dart';

@freezed
abstract class PodcastDownloadedEpisodesState
    with _$PodcastDownloadedEpisodesState {
  const factory PodcastDownloadedEpisodesState({
    Podcast? podcast,
    @Default([]) List<Episode> episodes,
  }) = _PodcastDownloadedEpisodesState;
}

@Riverpod(retry: noRetry)
class PodcastDownloadedEpisodesNotifier
    extends _$PodcastDownloadedEpisodesNotifier {
  Podcast? _lastKnownPodcast;
  int _generation = 0;

  @override
  Future<PodcastDownloadedEpisodesState> build(String podcastId) async {
    final generation = ++_generation;
    final library = await ref.watch(podcastLibraryProvider.future);
    final podcast =
        library.podcasts.firstWhereOrNull(
          (podcast) => podcast.id == podcastId,
        ) ??
        _lastKnownPodcast;
    if (ref.mounted && generation == _generation) {
      _lastKnownPodcast = podcast;
    }
    final episodes =
        <Episode>[
          if (podcast != null) ...?library.episodesByPodcastId[podcastId],
        ]..sort(
          (a, b) => (b.publicationDate ?? DateTime(0)).compareTo(
            a.publicationDate ?? DateTime(0),
          ),
        );
    return PodcastDownloadedEpisodesState(podcast: podcast, episodes: episodes);
  }

  void retry() => ref.invalidate(podcastLibraryProvider);
}
