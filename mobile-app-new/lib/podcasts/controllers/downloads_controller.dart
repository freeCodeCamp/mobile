import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobile_app_new/podcasts/controllers/library_controller.dart';
import 'package:mobile_app_new/podcasts/models/episode_model.dart';
import 'package:mobile_app_new/podcasts/models/podcast_model.dart';
import 'package:mobile_app_new/podcasts/services/library_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'downloads_controller.freezed.dart';
part 'downloads_controller.g.dart';

@freezed
sealed class DownloadStatus with _$DownloadStatus {
  const factory DownloadStatus.running(double progress) = DownloadRunning;
  const factory DownloadStatus.failed() = DownloadFailed;
}

@riverpod
class PodcastDownloadsNotifier extends _$PodcastDownloadsNotifier {
  final _cancelTokens = <String, CancelToken>{};

  // NOTE: Pinned only while transfers are in flight, so an idle notifier is disposed.
  KeepAliveLink? _link;

  @override
  Map<String, DownloadStatus> build() => const {};

  Future<void> start(Podcast podcast, Episode episode) async {
    if (_cancelTokens.containsKey(episode.id)) return;

    final token = CancelToken();
    _cancelTokens[episode.id] = token;
    _link ??= ref.keepAlive();
    _set(episode.id, const DownloadStatus.running(0));

    try {
      await ref
          .read(podcastLibraryServiceProvider)
          .download(
            podcast,
            episode,
            cancelToken: token,
            onProgress: (progress) {
              if (_cancelTokens.containsKey(episode.id)) {
                _set(episode.id, DownloadStatus.running(progress));
              }
            },
          );

      _clear(episode.id);

      // The library owns "downloaded"; this notifier only reports progress.
      await ref.read(podcastLibraryProvider.notifier).refresh();
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) {
        _clear(episode.id);
      } else {
        log('Podcast download failed for ${episode.id}: $e');
        _set(episode.id, const DownloadStatus.failed());
      }
    } catch (e) {
      log('Podcast download failed for ${episode.id}: $e');
      _set(episode.id, const DownloadStatus.failed());
    } finally {
      _cancelTokens.remove(episode.id);
      _releaseWhenIdle();
    }
  }

  void _releaseWhenIdle() {
    if (_cancelTokens.isNotEmpty) return;

    _link?.close();
    _link = null;
  }

  void cancel(String episodeId) {
    _cancelTokens.remove(episodeId)?.cancel('cancelled by user');
    _clear(episodeId);
    _releaseWhenIdle();
  }

  void _set(String episodeId, DownloadStatus status) {
    state = {...state, episodeId: status};
  }

  void _clear(String episodeId) {
    state = {...state}..remove(episodeId);
  }
}
