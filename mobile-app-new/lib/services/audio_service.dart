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

class CurriculumAudioConfig extends AudioTypeConfig {
  const CurriculumAudioConfig(this.clipId);

  final String clipId;
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
    _trackCodeRadioLiveEdge();
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
  // only way back to the live edge. just_audio pauses and resumes the player
  // itself on interruptions and unplugging, so the flag follows playingStream.
  bool _resumeNeedsLiveEdge = false;

  // NOTE: Every load takes a new id, so a load interrupted by a newer one
  // returns without stopping, restoring or publishing over the newer source.
  int _loadId = 0;

  // NOTE: While a source is swapping, position events can still come from the
  // old one, so no episode is reported until the new one is in place.
  bool _loading = false;

  String? get codeRadioSongId =>
      _audioConfig is CodeRadioAudioConfig ? mediaItem.value?.id : null;

  bool get isPlayingCodeRadio =>
      _audioPlayer.playing && _audioConfig is CodeRadioAudioConfig;

  String? get episodeId => switch (_audioConfig) {
    PodcastAudioConfig(:final episodeId) when !_loading => episodeId,
    _ => null,
  };

  String? get curriculumClipId => switch (_audioConfig) {
    CurriculumAudioConfig(:final clipId) => clipId,
    _ => null,
  };

  Stream<Duration> get positionStream => _audioPlayer.positionStream;

  Duration? get duration => _audioPlayer.duration;

  @override
  Future<void> play() async {
    if (_audioConfig == null) return;

    if (_resumeNeedsLiveEdge) {
      _resumeNeedsLiveEdge = false;

      if (_audioConfig is CodeRadioAudioConfig) {
        await _rejoinCodeRadioLiveEdge();
      }
    }

    _audioPlayer.play();
  }

  @override
  Future<void> pause() => _audioPlayer.pause();

  @override
  Future<void> stop() async {
    _loadId++;
    _loading = false;
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
    final load = ++_loadId;
    final previous = _audioConfig;
    _loading = true;

    try {
      final song = _toMediaItem(radio.nowPlaying.song);
      final url = Uri.parse(radio.station.listenUrl);

      _codeRadioUrl = url;
      _resumeNeedsLiveEdge = false;
      _audioConfig = const CodeRadioAudioConfig();

      await _audioPlayer.setSpeed(_defaultSpeed);
      await _audioPlayer.setAudioSource(AudioSource.uri(url));
      if (load != _loadId) return;

      _publish(song);
    } catch (e) {
      if (load != _loadId) return;

      _audioConfig = previous;
      log('loadCodeRadio: Cannot play audio: $e');
    } finally {
      if (load == _loadId) _loading = false;
    }
  }

  void updateCodeRadioSong(Song song) => _publish(_toMediaItem(song));

  Future<void> _rejoinCodeRadioLiveEdge() async {
    final url = _codeRadioUrl;
    if (url == null) return;

    try {
      await _audioPlayer.setAudioSource(AudioSource.uri(url));
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

    final load = ++_loadId;
    _loading = true;
    _codeRadioUrl = null;
    _resumeNeedsLiveEdge = false;
    _audioConfig = PodcastAudioConfig(episode.id);

    try {
      await _audioPlayer.setSpeed(_defaultSpeed);
      await _audioPlayer.setAudioSource(AudioSource.uri(source));

      if (startAt != null && startAt > Duration.zero) {
        await _audioPlayer.seek(startAt);
      }
      if (load != _loadId) return false;

      _publish(item);
      return true;
    } catch (e) {
      if (load != _loadId) return false;

      log('loadEpisode: Cannot play audio: $e');
      await stop();
      return false;
    } finally {
      if (load == _loadId) _loading = false;
    }
  }

  Future<bool> loadCurriculumAudio(
    Uri source, {
    required String clipId,
    required String title,
    Duration start = Duration.zero,
    Duration? end,
  }) async {
    final item = MediaItem(id: clipId, title: title, album: 'freeCodeCamp');

    final load = ++_loadId;
    _loading = true;
    _codeRadioUrl = null;
    _resumeNeedsLiveEdge = false;
    _audioConfig = CurriculumAudioConfig(clipId);

    try {
      await _audioPlayer.setSpeed(_defaultSpeed);
      await _audioPlayer.setAudioSource(
        ClippingAudioSource(
          start: start,
          end: end,
          child: AudioSource.uri(source),
        ),
      );
      if (load != _loadId) return false;

      _publish(item);
      return true;
    } catch (e) {
      if (load != _loadId) return false;

      log('loadCurriculumAudio: Cannot play audio: $e');
      await stop();
      return false;
    } finally {
      if (load == _loadId) _loading = false;
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
      CodeRadioAudioConfig() || CurriculumAudioConfig() || null => (
        controls: [playPause, MediaControl.stop],
        systemActions: const <MediaAction>{},
        compactIndices: const [0, 1],
      ),
    };
  }

  void _trackCodeRadioLiveEdge() {
    _audioPlayer.playingStream.listen((playing) {
      if (_audioConfig is! CodeRadioAudioConfig) return;

      if (!playing) {
        _resumeNeedsLiveEdge = true;
      } else if (_resumeNeedsLiveEdge) {
        _resumeNeedsLiveEdge = false;
        unawaited(_rejoinCodeRadioLiveEdge());
      }
    });
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
