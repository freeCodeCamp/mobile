import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:freecodecamp/podcasts/controllers/library_controller.dart';
import 'package:freecodecamp/podcasts/models/episode_model.dart';
import 'package:freecodecamp/podcasts/models/podcast_model.dart';
import 'package:freecodecamp/podcasts/services/library_service.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
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
  final _pendingTransfers = <String, CancelToken>{};
  int _buildGeneration = 0;

  // Cancellation hides progress before the transfer, artwork, and storage settle.
  bool hasPendingTransfers() => _pendingTransfers.isNotEmpty;

  // NOTE: Pinned only while transfers are in flight, so an idle notifier is disposed.
  KeepAliveLink? _link;

  @override
  Map<String, DownloadStatus> build() {
    _buildGeneration++;
    _link?.close();
    _link = _pendingTransfers.isEmpty ? null : ref.keepAlive();
    ref.onDispose(() {
      _link?.close();
      _link = null;
      for (final token in _pendingTransfers.values) {
        token.cancel('download provider disposed');
      }
    });
    return const {};
  }

  Future<void> start(Podcast podcast, Episode episode) async {
    if (!ref.mounted || _pendingTransfers.containsKey(episode.id)) return;

    final token = CancelToken();
    final generation = _buildGeneration;
    _pendingTransfers[episode.id] = token;
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
              if (_isCurrentTransfer(episode.id, token, generation) &&
                  !token.isCancelled) {
                _set(episode.id, DownloadStatus.running(progress));
              }
            },
          );

      if (!_isCurrentTransfer(episode.id, token, generation)) return;
      _clear(episode.id);

      // The library owns "downloaded"; this notifier only reports progress.
      await ref.read(podcastLibraryProvider.notifier).refresh();
    } on DioException catch (e) {
      if (!_isCurrentTransfer(episode.id, token, generation)) return;
      if (CancelToken.isCancel(e) || token.isCancelled) {
        _clear(episode.id);
      } else {
        log('Podcast download failed for ${episode.id}: $e');
        _set(episode.id, const DownloadStatus.failed());
      }
    } catch (e) {
      if (!_isCurrentTransfer(episode.id, token, generation) ||
          token.isCancelled) {
        return;
      }
      log('Podcast download failed for ${episode.id}: $e');
      _set(episode.id, const DownloadStatus.failed());
    } finally {
      if (identical(_pendingTransfers[episode.id], token)) {
        _pendingTransfers.remove(episode.id);
        _releaseWhenIdle();
      }
    }
  }

  bool _isCurrentTransfer(
    String episodeId,
    CancelToken token,
    int generation,
  ) =>
      ref.mounted &&
      generation == _buildGeneration &&
      identical(_pendingTransfers[episodeId], token);

  void _releaseWhenIdle() {
    if (_pendingTransfers.isNotEmpty) return;

    _link?.close();
    _link = null;
  }

  void cancel(String episodeId) {
    _pendingTransfers[episodeId]?.cancel('cancelled by user');
    _clear(episodeId);
    _releaseWhenIdle();
  }

  void _set(String episodeId, DownloadStatus status) {
    if (!ref.mounted) return;
    state = {...state, episodeId: status};
  }

  void _clear(String episodeId) {
    if (!ref.mounted) return;
    state = {...state}..remove(episodeId);
  }
}
