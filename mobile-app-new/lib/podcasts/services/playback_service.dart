import 'dart:async';
import 'dart:developer';

import 'package:audio_service/audio_service.dart';
import 'package:mobile_app_new/podcasts/models/episode_model.dart';
import 'package:mobile_app_new/podcasts/models/podcast_model.dart';
import 'package:mobile_app_new/podcasts/repositories/download_repository.dart';
import 'package:mobile_app_new/podcasts/repositories/progress_repository.dart';
import 'package:mobile_app_new/podcasts/repositories/storage_repository.dart';
import 'package:mobile_app_new/services/audio_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'playback_service.g.dart';

typedef EpisodePlaybackUris = ({Uri audio, Uri? artwork});

const _writeInterval = Duration(seconds: 5);

const _recentEpisodeLimit = 10;

// NOTE: Below this, an episode restarts rather than spending a slot on a tap.
const _minimumSavedPosition = Duration(seconds: 30);

// NOTE: Above this, an episode is considered complete and the position is cleared.
const _completionMargin = Duration(seconds: 30);

@riverpod
PodcastPlaybackService podcastPlaybackService(Ref ref) {
  final service = PodcastPlaybackService(
    ref.watch(audioHandlerProvider),
    ref.watch(podcastProgressRepositoryProvider),
    ref.watch(podcastStorageRepositoryProvider),
    ref.watch(podcastDownloadRepositoryProvider),
  );

  ref.onDispose(service.dispose);
  service.start();

  return service;
}

class PodcastPlaybackService {
  PodcastPlaybackService(this._handler, this._repo, this._store, this._files);

  final AudioPlayerHandler _handler;
  final PodcastProgressRepository _repo;
  final PodcastStorageRepository _store;
  final PodcastDownloadRepository _files;

  StreamSubscription<Duration>? _positionSub;
  StreamSubscription<PlaybackState>? _stateSub;

  String? _episodeId;
  Duration _position = Duration.zero;
  Duration? _duration;
  Duration _lastWritten = Duration.zero;
  bool _wasPlaying = false;

  void start() {
    _positionSub ??= _handler.positionStream.listen(_onPosition);
    _stateSub ??= _handler.playbackState.listen(_onPlaybackState);
  }

  Future<Duration?> readPosition(String episodeId) async {
    final seconds = await _repo.readPosition(episodeId);
    return seconds == null ? null : Duration(seconds: seconds);
  }

  Future<EpisodePlaybackUris> playbackUris(
    Podcast podcast,
    Episode episode,
  ) async {
    final isDownloaded = await _store.containsEpisode(
      podcastId: episode.podcastId,
      episodeId: episode.id,
    );

    return (
      audio: await _audioSource(episode, isDownloaded: isDownloaded),
      artwork: await _artworkSource(podcast, isDownloaded: isDownloaded),
    );
  }

  Future<Uri> _audioSource(
    Episode episode, {
    required bool isDownloaded,
  }) async {
    if (isDownloaded) {
      final file = await _files.episodeFile(episode.podcastId, episode.id);

      if (await file.exists()) return file.uri;

      log(
        'Podcast playback: ${episode.id} marked downloaded but file is missing',
      );
    }

    return Uri.parse(episode.audioUrl);
  }

  Future<Uri?> _artworkSource(
    Podcast podcast, {
    required bool isDownloaded,
  }) async {
    if (isDownloaded) {
      final file = await _files.artworkFile(podcast.id);

      if (await file.exists()) return file.uri;
    }

    return podcast.imageLink.isEmpty ? null : Uri.parse(podcast.imageLink);
  }

  void _onPosition(Duration position) {
    final episodeId = _handler.episodeId;

    if (episodeId == null) return;

    if (episodeId != _episodeId) {
      _episodeId = episodeId;
      _lastWritten = Duration.zero;
    }

    _position = position;
    _duration = _handler.duration;

    if ((position - _lastWritten).abs() < _writeInterval) return;

    _lastWritten = position;
    unawaited(_savePosition(episodeId, position, _duration));
  }

  void _onPlaybackState(PlaybackState state) {
    final wasPlaying = _wasPlaying;
    _wasPlaying = state.playing;

    if (!wasPlaying || state.playing) return;

    final episodeId = _episodeId;
    if (episodeId == null) return;

    _lastWritten = _position;
    unawaited(_savePosition(episodeId, _position, _duration));
  }

  Future<void> _savePosition(
    String episodeId,
    Duration position,
    Duration? total,
  ) async {
    if (total != null &&
        total > Duration.zero &&
        position >= total - _completionMargin) {
      return _clearPosition(episodeId);
    }

    if (position < _minimumSavedPosition) return;

    await _repo.writePosition(episodeId, position.inSeconds);
    await _markRecentlyPlayed(episodeId);
  }

  Future<void> _clearPosition(String episodeId) async {
    await _repo.clearPositions([episodeId]);

    final recent = await _repo.readRecentEpisodeIds();
    if (!recent.contains(episodeId)) return;

    await _repo.writeRecentEpisodeIds(
      recent.where((id) => id != episodeId).toList(),
    );
  }

  Future<void> _markRecentlyPlayed(String episodeId) async {
    final recent = await _repo.readRecentEpisodeIds();

    if (recent.isNotEmpty && recent.last == episodeId) return;

    final updated = [...recent.where((id) => id != episodeId), episodeId];

    if (updated.length > _recentEpisodeLimit) {
      final evicted = updated.sublist(0, updated.length - _recentEpisodeLimit);
      await _repo.clearPositions(evicted);
      updated.removeRange(0, evicted.length);
    }

    await _repo.writeRecentEpisodeIds(updated);
  }

  void dispose() {
    _positionSub?.cancel();
    _stateSub?.cancel();
    _positionSub = null;
    _stateSub = null;
  }
}
