import 'dart:developer';

import 'package:freecodecamp/models/code-radio/code_radio_model.dart';
import 'package:freecodecamp/models/podcasts/episodes_model.dart';
import 'package:freecodecamp/models/podcasts/podcasts_model.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_service/audio_service.dart';

class AppAudioService {
  static final AppAudioService _appAudioService = AppAudioService._internal();

  late AudioPlayerHandler audioHandler;

  factory AppAudioService() {
    return _appAudioService;
  }

  Future<void> init() async {
    audioHandler = await AudioService.init(
      builder: () => AudioPlayerHandler(),
      config: const AudioServiceConfig(
        androidNotificationChannelId: 'org.freecodecamp.channel.audio',
        androidNotificationChannelName: 'Audio playback',
        androidNotificationOngoing: true,
        androidStopForegroundOnPause: true,
      ),
    );
  }

  AppAudioService._internal();
}

class AudioPlayerHandler extends BaseAudioHandler {
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  AudioPlayerHandler() {
    _notifyAudioHandlerAboutPlaybackEvents();
  }

  @override
  Future<void> play() async {
    // if (episode.id != _audioPlayer.audioSource?.sequence[0].tag.id) {
    //   log('DIFFERENT EPISODE');
    //   await _audioPlayer.stop();
    //   await loadEpisode(episode, isDownloaded);
    // }
    _audioPlayer.play();
  }

  @override
  Future<void> pause() async {
    await _audioPlayer.pause();
  }

  @override
  Future<void> stop() async {
    await _audioPlayer.stop();
    return super.stop();
  }

  // @override
  // Future<void> playFromUri() async {}

  Future<void> loadEpisode(
    Episodes episode,
    bool isDownloaded,
    Podcasts podcast,
  ) async {
    try {
      MediaItem audioMediaItem = MediaItem(
        id: episode.id,
        title: episode.title,
        album: podcast.title,
        duration: episode.duration,
        artUri: Uri.parse(
            'file:///data/user/0/org.freecodecamp/app_flutter/images/podcast/${episode.podcastId}.jpg'),
      );
      if (isDownloaded) {
        await _audioPlayer.setAudioSource(
          AudioSource.uri(
            Uri.parse(
                'file:///data/user/0/org.freecodecamp/app_flutter/episodes/${episode.podcastId}/${episode.id}.mp3'),
            tag: audioMediaItem,
          ),
          preload: true,
        );
      } else {
        await _audioPlayer.setAudioSource(
          AudioSource.uri(
            Uri.parse(episode.contentUrl!),
            tag: audioMediaItem,
          ),
          preload: true,
        );
      }
      await _audioPlayer.load();
      queue.add([audioMediaItem]);
      mediaItem.add(audioMediaItem);
    } catch (e) {
      log('Cannot play audio: $e');
    }
  }

  Future<void> codeRadioMusic(CodeRadio radio) async {
    try {
      MediaItem currentSong = MediaItem(
        id: radio.nowPlaying.id,
        title: radio.nowPlaying.title,
        album: radio.nowPlaying.album,
        artUri: Uri.parse(radio.nowPlaying.artUrl),
      );
      MediaItem nextSong = MediaItem(
        id: radio.nextPlaying.id,
        album: radio.nextPlaying.album,
        title: radio.nextPlaying.title,
        artUri: Uri.parse(radio.nextPlaying.artUrl),
      );
      await _audioPlayer.setAudioSource(ConcatenatingAudioSource(children: [
        AudioSource.uri(Uri.parse(radio.listenUrl), tag: currentSong),
        AudioSource.uri(Uri.parse(radio.listenUrl), tag: nextSong)
      ]));
      await _audioPlayer.load();
      queue.add([currentSong, nextSong]);
      mediaItem.add(currentSong);
    } catch (e) {
      log('Cannot play audio: $e');
    }
  }

  bool isPlaying(String src, {String? episodeId}) {
    if (src == 'podcast') {
      return _audioPlayer.playing &&
          _audioPlayer.audioSource?.sequence[0].tag.id == episodeId;
    } else if (src == 'coderadio') {
      return _audioPlayer.playing;
    } else {
      return false;
    }
  }

  void _notifyAudioHandlerAboutPlaybackEvents() {
    _audioPlayer.playbackEventStream.listen((PlaybackEvent event) {
      final playing = _audioPlayer.playing;
      playbackState.add(playbackState.value.copyWith(
        controls: [
          if (playing) MediaControl.pause else MediaControl.play,
          MediaControl.stop,
        ],
        systemActions: const {
          MediaAction.seek,
          MediaAction.seekBackward,
          MediaAction.seekForward,
        },
        androidCompactActionIndices: const [0, 1], // CHECK
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
      ));
    });
  }
}
