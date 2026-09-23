import 'dart:developer';

import 'dart:io';

import 'package:mobile_app_new/podcasts/models/episode_model.dart';
import 'package:mobile_app_new/podcasts/models/podcast_model.dart';
import 'package:dio/dio.dart';
import 'package:mobile_app_new/podcasts/repositories/download_repository.dart';
import 'package:mobile_app_new/podcasts/repositories/storage_repository.dart';
import 'package:mobile_app_new/services/notification_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'library_service.g.dart';

typedef PodcastLibrary = ({
  List<Podcast> podcasts,
  Map<String, List<Episode>> episodesByPodcastId,
  Map<String, File> artworkByPodcastId,
});

@riverpod
PodcastLibraryService podcastLibraryService(Ref ref) {
  return PodcastLibraryService(
    ref.watch(podcastStorageRepositoryProvider),
    ref.watch(podcastDownloadRepositoryProvider),
    ref.watch(notificationServiceProvider),
  );
}

class PodcastLibraryService {
  PodcastLibraryService(this._repo, this._files, this._notifications);

  final PodcastStorageRepository _repo;
  final PodcastDownloadRepository _files;
  final NotificationService _notifications;

  Future<void> download(
    Podcast podcast,
    Episode episode, {
    CancelToken? cancelToken,
    void Function(double progress)? onProgress,
  }) async {
    await _files.downloadEpisode(
      podcastId: episode.podcastId,
      episodeId: episode.id,
      url: episode.audioUrl,
      cancelToken: cancelToken,
      onProgress: onProgress,
    );

    await _files.saveArtwork(podcast.id, podcast.imageLink);

    await _repo.upsertEpisode(
      podcast: podcast.toJson(),
      episode: episode.toJson(),
    );

    await _notifications.showNotification(
      'Download complete',
      '${podcast.title} - ${episode.title}',
    );
  }

  Future<PodcastLibrary> getLibrary() async {
    final snapshot = await _repo.readPodcasts();

    final podcasts = <Podcast>[];
    final episodesByPodcastId = <String, List<Episode>>{};

    for (final row in snapshot.podcasts) {
      final podcast = _toPodcast(row.podcast);
      if (podcast == null) continue;

      final episodes = [for (final raw in row.episodes) ?_toEpisode(raw)];

      podcasts.add(podcast);
      episodesByPodcastId[podcast.id] = episodes;
    }

    return (
      podcasts: podcasts,
      episodesByPodcastId: episodesByPodcastId,
      artworkByPodcastId: await _files.existingArtworkFiles(
        podcasts.map((podcast) => podcast.id),
      ),
    );
  }

  Future<void> removeEpisode(String podcastId, String episodeId) async {
    final podcastEmptied = await _repo.removeEpisode(
      podcastId: podcastId,
      episodeId: episodeId,
    );

    await _files.deleteEpisodeFile(podcastId, episodeId);
    if (podcastEmptied) await _files.deleteArtwork(podcastId);
  }

  // NOTE: Deletes audio and artwork on disk that the store has no row for.
  // Runs unattended at startup, so a failure here must stay contained.
  Future<void> sweepOrphanedFiles() async {
    try {
      final store = await _repo.readIds();

      if (!store.readable) {
        log('Podcast cleanup: store unreadable or incomplete, skipping sweep');
        return;
      }

      final removed = await _files.deleteOrphans(store.episodeIdsByPodcastId);
      if (removed.count == 0) return;

      log(
        'Podcast cleanup: removed ${removed.count} orphaned files '
        '(${(removed.bytes / 1024 / 1024).toStringAsFixed(1)} MB)',
      );
    } catch (e) {
      log('Podcast cleanup: sweep failed ($e)');
    }
  }

  // Tolerant by design: this is user data that predates v8, and one unreadable
  // row should cost that row rather than the whole downloads list. The models
  // throw on a missing required field, so the skip happens here.
  Podcast? _toPodcast(PodcastStoreEntry entry) {
    try {
      return Podcast.fromJson(entry);
    } catch (e) {
      log('Podcast downloads: skipping unreadable podcast row ($e)');
      return null;
    }
  }

  Episode? _toEpisode(Map<String, dynamic> raw) {
    try {
      return Episode.fromJson(raw);
    } catch (e) {
      log('Podcast downloads: skipping unreadable episode row ($e)');
      return null;
    }
  }
}
