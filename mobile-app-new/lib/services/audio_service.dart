import 'dart:async';
import 'dart:developer';

import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mobile_app_new/code_radio/models/code_radio_model.dart';
import 'package:mobile_app_new/fcc_theme.dart';
import 'package:mobile_app_new/podcasts/models/episode_model.dart';
import 'package:mobile_app_new/podcasts/models/podcast_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'audio_service.g.dart';

typedef _MediaControls = ({
  List<MediaControl> controls,
  Set<MediaAction> systemActions,
  List<int> compactIndices,
});

sealed class AudioTypeConfig {
  const AudioTypeConfig();
}

class CodeRadioAudioConfig extends AudioTypeConfig {
  const CodeRadioAudioConfig();
}

class PodcastAudioConfig extends AudioTypeConfig {
  const PodcastAudioConfig(this.episodeId);

  final String episodeId;
}

// NOTE: The handler is created before runApp and injected, so reading
// this without that override is a wiring mistake rather than a lazy init.
@Riverpod(keepAlive: true)
AudioPlayerHandler audioHandler(Ref ref) => throw UnimplementedError(
  'audioHandlerProvider must be overridden in main() with initAudioService()',
);

Future<AudioPlayerHandler> initAudioService() => AudioService.init(
  builder: () => AudioPlayerHandler(),
  config: const AudioServiceConfig(
    androidNotificationChannelId: 'org.freecodecamp.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
    androidStopForegroundOnPause: true,
    androidNotificationIcon: 'drawable/notification_icon',
    notificationColor: FccColors.gray90,
  ),
);

class AudioPlayerHandler extends BaseAudioHandler {
  AudioPlayerHandler() {
    _notifyAudioHandlerAboutPlaybackEvents();
  }

  static const _skipForward = Duration(seconds: 30);
  static const _skipBackward = Duration(seconds: 10);
  static const _defaultSpeed = 1.0;

  final AudioPlayer _audioPlayer = AudioPlayer();

  AudioTypeConfig? _audioConfig;

  Uri? _codeRadioUrl;

  // NOTE: Pausing a live stream does not pause the source: the buffer keeps filling
  // while the playhead sits still, so resuming plays out the backlog instead
  // of what the station is broadcasting now. Reconnecting on resume is the
  // only way back to the live edge.
  bool _resumeNeedsLiveEdge = false;

  String? get codeRadioSongId =>
      _audioConfig is CodeRadioAudioConfig ? mediaItem.value?.id : null;

  bool get isPlayingCodeRadio =>
      _audioPlayer.playing && _audioConfig is CodeRadioAudioConfig;

  String? get episodeId => switch (_audioConfig) {
    PodcastAudioConfig(:final episodeId) => episodeId,
    _ => null,
  };

  Stream<Duration> get positionStream => _audioPlayer.positionStream;

  Duration? get duration => _audioPlayer.duration;

  @override
  Future<void> play() async {
    if (_resumeNeedsLiveEdge) {
      _resumeNeedsLiveEdge = false;

      if (_audioConfig is CodeRadioAudioConfig) {
        await _rejoinCodeRadioLiveEdge();
      }
    }

    _audioPlayer.play();
  }

  @override
  Future<void> pause() async {
    if (_audioConfig is CodeRadioAudioConfig) _resumeNeedsLiveEdge = true;

    await _audioPlayer.pause();
  }

  @override
  Future<void> stop() async {
    _audioConfig = null;
    _codeRadioUrl = null;
    _resumeNeedsLiveEdge = false;

    await _audioPlayer.stop();

    playbackState.add(
      playbackState.value.copyWith(
        processingState: AudioProcessingState.idle,
        playing: false,
        controls: const [],
        systemActions: const {},
        androidCompactActionIndices: const [],
        updatePosition: Duration.zero,
        bufferedPosition: Duration.zero,
        speed: _defaultSpeed,
      ),
    );

    mediaItem.add(null);
    queue.add(const []);

    return super.stop();
  }

  @override
  Future<void> seek(Duration position) => _audioPlayer.seek(position);

  @override
  Future<void> fastForward() => _seekBy(_skipForward);

  @override
  Future<void> rewind() => _seekBy(-_skipBackward);

  @override
  Future<void> setSpeed(double speed) => _audioPlayer.setSpeed(speed);

  @override
  Future<void> onTaskRemoved() async {
    await stop();
    return super.onTaskRemoved();
  }

  Future<void> _seekBy(Duration offset) async {
    final target = _audioPlayer.position + offset;
    final end = _audioPlayer.duration;

    if (target < Duration.zero) return _audioPlayer.seek(Duration.zero);
    if (end != null && target > end) return _audioPlayer.seek(end);

    return _audioPlayer.seek(target);
  }

  Future<void> loadCodeRadio(CodeRadio radio) async {
    final previous = _audioConfig;

    try {
      final song = _toMediaItem(radio.nowPlaying.song);
      final url = Uri.parse(radio.station.listenUrl);

      _codeRadioUrl = url;
      _resumeNeedsLiveEdge = false;
      _audioConfig = const CodeRadioAudioConfig();

      await _audioPlayer.setSpeed(_defaultSpeed);
      await _audioPlayer.setAudioSource(AudioSource.uri(url, tag: song));

      _publish(song);
    } catch (e) {
      _audioConfig = previous;
      log('loadCodeRadio: Cannot play audio: $e');
    }
  }

  void updateCodeRadioSong(Song song) => _publish(_toMediaItem(song));

  Future<void> _rejoinCodeRadioLiveEdge() async {
    final url = _codeRadioUrl;
    final song = mediaItem.value;

    if (url == null || song == null) return;

    try {
      await _audioPlayer.setAudioSource(AudioSource.uri(url, tag: song));
    } catch (e) {
      log('rejoinCodeRadioLiveEdge: Cannot reconnect: $e');
    }
  }

  Future<bool> loadEpisode(
    Episode episode,
    Podcast podcast, {
    required Uri source,
    Uri? artUri,
    Duration? startAt,
  }) async {
    final item = MediaItem(
      id: episode.id,
      title: episode.title,
      album: podcast.title,
      duration: episode.duration,
      artUri: artUri,
    );

    _codeRadioUrl = null;
    _resumeNeedsLiveEdge = false;
    _audioConfig = PodcastAudioConfig(episode.id);

    try {
      await _audioPlayer.setSpeed(_defaultSpeed);
      await _audioPlayer.setAudioSource(AudioSource.uri(source, tag: item));

      if (startAt != null && startAt > Duration.zero) {
        await _audioPlayer.seek(startAt);
      }

      _publish(item);
      return true;
    } catch (e) {
      log('loadEpisode: Cannot play audio: $e');
      await stop();
      return false;
    }
  }

  MediaItem _toMediaItem(Song song) => MediaItem(
    id: song.id,
    title: song.title,
    artist: song.artist,
    album: song.album,
    artUri: Uri.parse(song.art),
  );

  void _publish(MediaItem song) {
    queue.add([song]);
    mediaItem.add(song);
  }

  _MediaControls _controlsFor(bool playing) {
    final playPause = playing ? MediaControl.pause : MediaControl.play;

    return switch (_audioConfig) {
      PodcastAudioConfig() => (
        controls: [
          MediaControl.rewind,
          playPause,
          MediaControl.fastForward,
          MediaControl.stop,
        ],
        systemActions: const {MediaAction.seek},
        compactIndices: const [0, 1, 2],
      ),
      CodeRadioAudioConfig() || null => (
        controls: [playPause, MediaControl.stop],
        systemActions: const <MediaAction>{},
        compactIndices: const [0, 1],
      ),
    };
  }

  void _notifyAudioHandlerAboutPlaybackEvents() {
    _audioPlayer.playbackEventStream.listen(
      (PlaybackEvent event) {
        if (_audioConfig == null) return;

        if (_audioConfig is PodcastAudioConfig &&
            _audioPlayer.processingState == ProcessingState.completed) {
          unawaited(Future.microtask(stop));
          return;
        }

        final playing = _audioPlayer.playing;
        final mediaControls = _controlsFor(playing);

        playbackState.add(
          playbackState.value.copyWith(
            controls: mediaControls.controls,
            systemActions: mediaControls.systemActions,
            androidCompactActionIndices: mediaControls.compactIndices,
            processingState: const {
              ProcessingState.idle: AudioProcessingState.idle,
              ProcessingState.loading: AudioProcessingState.loading,
              ProcessingState.buffering: AudioProcessingState.buffering,
              ProcessingState.ready: AudioProcessingState.ready,
              ProcessingState.completed: AudioProcessingState.completed,
            }[_audioPlayer.processingState]!,
            repeatMode: AudioServiceRepeatMode.none,
            shuffleMode: AudioServiceShuffleMode.none,
            playing: playing,
            updatePosition: _audioPlayer.position,
            bufferedPosition: _audioPlayer.bufferedPosition,
            speed: _audioPlayer.speed,
            queueIndex: event.currentIndex,
          ),
        );
      },
      onError: (Object e, StackTrace st) {
        log('Playback event error: $e\n$st');
      },
    );
  }
}
