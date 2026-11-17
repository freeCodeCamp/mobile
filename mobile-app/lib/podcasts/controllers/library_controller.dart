import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecodecamp/podcasts/constants.dart';
import 'package:freecodecamp/podcasts/models/podcast_model.dart';
import 'package:freecodecamp/podcasts/services/library_service.dart';
import 'package:freecodecamp/services/audio_service.dart';
import 'package:freecodecamp/utils/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'library_controller.g.dart';

@Riverpod(retry: noRetry)
class PodcastLibraryNotifier extends _$PodcastLibraryNotifier {
  int _buildGeneration = 0;

  @override
  Future<PodcastLibrary> build() {
    _buildGeneration++;
    return ref.watch(podcastLibraryServiceProvider).getLibrary();
  }

  Future<void> refresh() async {
    final generation = _buildGeneration;
    final library = await ref.read(podcastLibraryServiceProvider).getLibrary();
    if (ref.mounted && generation == _buildGeneration) {
      state = AsyncData(library);
    }
  }

  Future<void> remove(String podcastId, String episodeId) =>
      removeEpisodes(podcastId, [episodeId]);

  Future<void> removeEpisodes(String podcastId, Iterable<String> episodeIds) =>
      _removeDownloads(episodeIdsByPodcastId: {podcastId: episodeIds.toSet()});

  Future<void> removePodcasts(Iterable<String> podcastIds) =>
      _removeDownloads(podcastIds: podcastIds.toSet());

  Future<void> _removeDownloads({
    Set<String> podcastIds = const {},
    Map<String, Set<String>> episodeIdsByPodcastId = const {},
  }) async {
    if (podcastIds.isEmpty &&
        episodeIdsByPodcastId.values.every((ids) => ids.isEmpty)) {
      return;
    }

    final handler = ref.read(audioHandlerProvider);
    final service = ref.read(podcastLibraryServiceProvider);
    final generation = _buildGeneration;
    final pendingRemoval = ref.keepAlive();
    try {
      final selected = {...episodeIdsByPodcastId};
      if (podcastIds.isNotEmpty) {
        final library = await service.getLibrary();
        for (final podcastId in podcastIds) {
          selected[podcastId] = {
            ...?selected[podcastId],
            ...?library.episodesByPodcastId[podcastId]?.map(
              (episode) => episode.id,
            ),
          };
        }
      }

      final playingEpisodeId = handler.episodeId;
      if (playingEpisodeId != null &&
          selected.values.any((ids) => ids.contains(playingEpisodeId))) {
        await handler.stop();
      }

      try {
        for (final MapEntry(key: podcastId, value: episodeIds)
            in selected.entries) {
          for (final episodeId in episodeIds) {
            await service.removeEpisode(podcastId, episodeId);
          }
        }
      } finally {
        final library = await service.getLibrary();
        if (ref.mounted && generation == _buildGeneration) {
          state = AsyncData(library);
        }
      }
    } finally {
      pendingRemoval.close();
    }
  }
}

@riverpod
AsyncValue<List<Podcast>> podcastDownloadedPodcasts(Ref ref) {
  return ref.watch(podcastLibraryProvider).whenData((library) {
    final downloaded = library.podcasts.where(
      (podcast) => library.episodesByPodcastId[podcast.id]?.isNotEmpty ?? false,
    );
    return [
      for (final feedUrl in fccPodcastUrls)
        ...downloaded.where((podcast) => podcast.feedUrl == feedUrl),
      ...downloaded.where(
        (podcast) => !fccPodcastUrls.contains(podcast.feedUrl),
      ),
    ];
  });
}

@riverpod
int podcastDownloadedEpisodeCount(Ref ref, String podcastId) => ref.watch(
  podcastLibraryProvider.select(
    (library) => library.value?.episodesByPodcastId[podcastId]?.length ?? 0,
  ),
);

@riverpod
Future<int?> podcastDownloadedPodcastSize(Ref ref, String podcastId) {
  final episodes = ref.watch(
    podcastLibraryProvider.select(
      (library) => library.value?.episodesByPodcastId[podcastId],
    ),
  );
  if (episodes == null || episodes.isEmpty) return Future.value();
  return ref
      .watch(podcastLibraryServiceProvider)
      .downloadedPodcastSize(podcastId, episodes.map((episode) => episode.id));
}

@riverpod
Future<int?> podcastDownloadedSize(
  Ref ref,
  String podcastId,
  String episodeId,
) async {
  final downloaded = ref.watch(
    podcastLibraryProvider.select(
      (library) =>
          library.value?.episodesByPodcastId[podcastId]?.any(
            (episode) => episode.id == episodeId,
          ) ??
          false,
    ),
  );
  if (!downloaded) return null;
  return ref
      .watch(podcastLibraryServiceProvider)
      .downloadedSize(podcastId, episodeId);
}
