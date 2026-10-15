import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobile_app_new/podcasts/controllers/library_controller.dart';
import 'package:mobile_app_new/podcasts/models/episode_model.dart';
import 'package:mobile_app_new/podcasts/models/podcast_model.dart';
import 'package:mobile_app_new/podcasts/services/api_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'episode_list_viewmodel.freezed.dart';
part 'episode_list_viewmodel.g.dart';

@freezed
sealed class PodcastEpisodeSource with _$PodcastEpisodeSource {
  const factory PodcastEpisodeSource.remote(String podcastId) = RemoteEpisodes;
  const factory PodcastEpisodeSource.downloaded(String podcastId) =
      DownloadedEpisodes;
}

@freezed
abstract class PodcastEpisodesState with _$PodcastEpisodesState {
  const factory PodcastEpisodesState({
    required Podcast podcast,
    @Default([]) List<Episode> episodes,
    @Default(0) int page,
    @Default(false) bool hasNextPage,
    @Default(false) bool isLoadingMore,
    // NOTE: Set when appending a page failed; the episodes already loaded stay valid.
    Object? loadMoreError,
  }) = _PodcastEpisodesState;
}

@riverpod
class PodcastEpisodesNotifier extends _$PodcastEpisodesNotifier {
  Podcast? _lastKnownPodcast;

  @override
  FutureOr<PodcastEpisodesState> build(PodcastEpisodeSource source) async {
    switch (source) {
      case RemoteEpisodes(:final podcastId):
        final page = await ref
            .watch(podcastApiServiceProvider)
            .getEpisodes(podcastId);

        _lastKnownPodcast = page.podcast;

        return PodcastEpisodesState(
          podcast: page.podcast,
          episodes: page.episodes,
          hasNextPage: page.hasMore,
        );

      case DownloadedEpisodes(:final podcastId):
        final library = await ref.watch(podcastLibraryProvider.future);

        final podcast =
            library.podcasts.firstWhereOrNull(
              (podcast) => podcast.id == podcastId,
            ) ??
            _lastKnownPodcast;

        if (podcast == null) {
          throw StateError('Podcast $podcastId has no downloaded episodes');
        }

        _lastKnownPodcast = podcast;

        return PodcastEpisodesState(
          podcast: podcast,
          episodes: library.episodesByPodcastId[podcastId] ?? const [],
        );
    }
  }

  Future<void> fetchNextPage({bool isRetry = false}) async {
    final current = state.value;
    if (current == null || !current.hasNextPage || current.isLoadingMore) {
      return;
    }

    // A failed append waits for an explicit retry instead of refiring on scroll.
    if (current.loadMoreError != null && !isRetry) return;

    if (source case RemoteEpisodes(:final podcastId)) {
      state = AsyncData(
        current.copyWith(isLoadingMore: true, loadMoreError: null),
      );

      final next = current.page + 1;

      try {
        final page = await ref
            .read(podcastApiServiceProvider)
            .getEpisodes(podcastId, page: next);

        state = AsyncData(
          current.copyWith(
            episodes: [...current.episodes, ...page.episodes],
            page: next,
            hasNextPage: page.hasMore,
            isLoadingMore: false,
          ),
        );
      } catch (error) {
        state = AsyncData(
          current.copyWith(isLoadingMore: false, loadMoreError: error),
        );
      }
    }
  }
}
