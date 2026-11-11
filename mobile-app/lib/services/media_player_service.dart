import 'package:audio_service/audio_service.dart';
import 'package:freecodecamp/podcasts/models/episode_model.dart';
import 'package:freecodecamp/podcasts/models/podcast_model.dart';
import 'package:freecodecamp/services/audio_service.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'media_player_service.freezed.dart';
part 'media_player_service.g.dart';

@freezed
abstract class MediaPlayerState with _$MediaPlayerState {
  const factory MediaPlayerState({
    MediaItem? item,
    required PlaybackState playback,
    @Default(false) bool isRadio,
    (Podcast, Episode)? episode,
    Duration? duration,
  }) = _MediaPlayerState;

  const MediaPlayerState._();

  bool get isVisible => item != null && (isRadio || episode != null);

  bool get isBusy =>
      playback.processingState == AudioProcessingState.loading ||
      playback.processingState == AudioProcessingState.buffering;
}

@Riverpod(keepAlive: true)
class MediaPlayerNotifier extends _$MediaPlayerNotifier {
  @override
  MediaPlayerState build() {
    final handler = ref.watch(audioHandlerProvider);
    final mediaSubscription = handler.mediaItem.listen((_) {
      if (ref.mounted) state = _snapshot(handler);
    });
    final playbackSubscription = handler.playbackState.listen((_) {
      if (ref.mounted) state = _snapshot(handler);
    });
    ref.onDispose(() {
      mediaSubscription.cancel();
      playbackSubscription.cancel();
    });
    return _snapshot(handler);
  }

  MediaPlayerState _snapshot(AudioPlayerHandler handler) {
    final item = handler.mediaItem.value;
    final playback = handler.playbackState.value;
    if (item == null) return MediaPlayerState(playback: playback);

    final published = handler.published;
    final isLoading = playback.processingState == AudioProcessingState.loading;

    return MediaPlayerState(
      item: item,
      playback: playback,
      isRadio: published is PublishedCodeRadio,
      episode: switch (published) {
        PublishedPodcast(:final podcast, :final episode) => (podcast, episode),
        _ => null,
      },
      // NOTE: While a new source loads, the player still reports its duration,
      // not the published item's.
      duration: isLoading ? item.duration : handler.duration ?? item.duration,
    );
  }

  bool _isCurrent(AudioPlayerHandler handler, String itemId) =>
      handler.mediaItem.value?.id == itemId &&
      (handler.episodeId != null || handler.codeRadioSongId != null);

  Future<void> toggle(String itemId) async {
    final handler = ref.read(audioHandlerProvider);
    if (!_isCurrent(handler, itemId)) return;
    if (handler.playbackState.value.playing) {
      await handler.pause();
    } else {
      await handler.play();
    }
  }

  Future<void> dismiss(String itemId) async {
    final handler = ref.read(audioHandlerProvider);
    if (_isCurrent(handler, itemId)) await handler.stop();
  }
}
