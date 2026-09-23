import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobile_app_new/podcasts/models/episode_model.dart';
import 'package:mobile_app_new/podcasts/models/podcast_model.dart';
import 'package:mobile_app_new/podcasts/services/playback_service.dart';
import 'package:mobile_app_new/services/audio_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'player_controller.freezed.dart';
part 'player_controller.g.dart';

@freezed
abstract class PodcastPlayerState with _$PodcastPlayerState {
  const factory PodcastPlayerState({
    String? episodeId,
    String? loadingEpisodeId,
    @Default(false) bool isPlaying,
    @Default(false) bool isBuffering,
    Duration? duration,
    @Default(1.0) double speed,
  }) = _PodcastPlayerState;

  const PodcastPlayerState._();

  bool isCurrent(String id) => episodeId == id;

  bool isPlayingEpisode(String id) => isCurrent(id) && isPlaying;

  bool isBusyWith(String id) =>
      loadingEpisodeId == id || (isCurrent(id) && isBuffering);
}

// NOTE: Kept off PodcastPlayerState deliberately. This ticks up to 60x a
// second
@riverpod
Stream<Duration> podcastPlaybackPosition(Ref ref) =>
    ref.watch(audioHandlerProvider).positionStream;

@riverpod
class PodcastPlayerNotifier extends _$PodcastPlayerNotifier {
  // NOTE: Pinned while an episode is loaded, released once the handler holds
  // none at all.
  KeepAliveLink? _link;

  @override
  PodcastPlayerState build() {
    final handler = ref.watch(audioHandlerProvider);

    ref.watch(podcastPlaybackServiceProvider);

    final subscription = handler.playbackState.listen((playback) {
      if (!ref.mounted) return;
      state = _fromPlayback(
        handler,
        playback,
        loadingEpisodeId: state.loadingEpisodeId,
      );
      _syncKeepAlive();
    });

    ref.onDispose(() {
      subscription.cancel();
      _link?.close();
      _link = null;
    });

    return _fromPlayback(handler, handler.playbackState.value);
  }

  void _syncKeepAlive() {
    if (state.episodeId != null || state.loadingEpisodeId != null) {
      _link ??= ref.keepAlive();
      return;
    }

    _link?.close();
    _link = null;
  }

  PodcastPlayerState _fromPlayback(
    AudioPlayerHandler handler,
    PlaybackState playback, {
    String? loadingEpisodeId,
  }) {
    final episodeId = handler.episodeId;

    return PodcastPlayerState(
      loadingEpisodeId: loadingEpisodeId,
      episodeId: episodeId,
      isPlaying: episodeId != null && playback.playing,
      isBuffering:
          episodeId != null &&
          const {
            AudioProcessingState.loading,
            AudioProcessingState.buffering,
          }.contains(playback.processingState),
      duration: handler.duration,
      speed: playback.speed,
    );
  }

  Future<void> toggle(Podcast podcast, Episode episode) async {
    final handler = ref.read(audioHandlerProvider);

    if (handler.episodeId == episode.id) {
      return state.isPlaying ? handler.pause() : handler.play();
    }

    state = state.copyWith(loadingEpisodeId: episode.id);
    _syncKeepAlive();

    try {
      final uris = await ref
          .read(podcastPlaybackServiceProvider)
          .playbackUris(podcast, episode);

      final loaded = await handler.loadEpisode(
        episode,
        podcast,
        source: uris.audio,
        artUri: uris.artwork,
        startAt: await ref
            .read(podcastPlaybackServiceProvider)
            .readPosition(episode.id),
      );

      if (loaded) await handler.play();
    } finally {
      if (ref.mounted) {
        state = state.copyWith(loadingEpisodeId: null);
        _syncKeepAlive();
      }
    }
  }

  Future<void> seek(Duration position) =>
      ref.read(audioHandlerProvider).seek(position);

  Future<void> fastForward() => ref.read(audioHandlerProvider).fastForward();

  Future<void> rewind() => ref.read(audioHandlerProvider).rewind();

  Future<void> setSpeed(double speed) =>
      ref.read(audioHandlerProvider).setSpeed(speed);
}
