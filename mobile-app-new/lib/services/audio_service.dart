import 'dart:async';
import 'dart:developer';

import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mobile_app_new/code_radio/models/code_radio_model.dart';
import 'package:mobile_app_new/fcc_theme.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'audio_service.g.dart';

sealed class AudioTypeConfig {
  const AudioTypeConfig();
}

class CodeRadioAudioConfig extends AudioTypeConfig {
  const CodeRadioAudioConfig();
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

  final AudioPlayer _audioPlayer = AudioPlayer();

  AudioTypeConfig? _audioConfig;

  Uri? _codeRadioUrl;

  // NOTE: Pausing a live stream does not pause the source: the buffer keeps filling
  // while the playhead sits still, so resuming plays out the backlog instead
  // of what the station is broadcasting now. Reconnecting on resume is the
  // only way back to the live edge.
  bool _resumeNeedsLiveEdge = false;

  AudioTypeConfig? get audioConfig => _audioConfig;

  String? get codeRadioSongId =>
      _audioConfig is CodeRadioAudioConfig ? mediaItem.value?.id : null;

  bool get isPlayingCodeRadio =>
      _audioPlayer.playing && _audioConfig is CodeRadioAudioConfig;

  @override
  Future<void> play() async {
    if (_resumeNeedsLiveEdge) {
      _resumeNeedsLiveEdge = false;

      if (_audioConfig is CodeRadioAudioConfig) {
        await _rejoinCodeRadioLiveEdge();
      }
    }

    await _audioPlayer.play();
  }

  @override
  Future<void> pause() async {
    if (_audioConfig is CodeRadioAudioConfig) _resumeNeedsLiveEdge = true;

    await _audioPlayer.pause();
  }

  @override
  Future<void> stop() async {
    await _audioPlayer.stop();
    _audioConfig = null;
    _codeRadioUrl = null;
    _resumeNeedsLiveEdge = false;
    return super.stop();
  }

  @override
  Future<void> seek(Duration position) => _audioPlayer.seek(position);

  @override
  Future<void> onTaskRemoved() async {
    await stop();
    return super.onTaskRemoved();
  }

  Future<void> loadCodeRadio(CodeRadio radio) async {
    try {
      final song = _toMediaItem(radio.nowPlaying.song);
      final url = Uri.parse(radio.station.listenUrl);

      await _audioPlayer.setAudioSource(AudioSource.uri(url, tag: song));

      _codeRadioUrl = url;
      _resumeNeedsLiveEdge = false;
      _audioConfig = const CodeRadioAudioConfig();
      _publish(song);
    } catch (e) {
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

  void _notifyAudioHandlerAboutPlaybackEvents() {
    _audioPlayer.playbackEventStream.listen(
      (PlaybackEvent event) {
        final playing = _audioPlayer.playing;
        playbackState.add(
          playbackState.value.copyWith(
            controls: [
              if (playing) MediaControl.pause else MediaControl.play,
              MediaControl.stop,
            ],
            systemActions: const {},
            androidCompactActionIndices: const [0, 1],
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
