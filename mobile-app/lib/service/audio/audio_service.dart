import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:freecodecamp/models/code-radio/code_radio_model.dart';
import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:freecodecamp/models/podcasts/episodes_model.dart';
import 'package:freecodecamp/models/podcasts/podcasts_model.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  String _episodeId = '';
  String _audioType = '';

  StreamSubscription? cacheSub;

  String get episodeId => _episodeId;
  set setEpisodeId(String state) {
    _episodeId = state;
  }

  String get audioType => _audioType;

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
    _audioType = '';
    return super.stop();
  }

  @override
  Future<int> fastForward() async {
    await _audioPlayer.seek(
      Duration(seconds: _audioPlayer.position.inSeconds + 30),
    );

    return _audioPlayer.position.inSeconds;
  }

  @override
  Future<int> rewind() async {
    await _audioPlayer.seek(
      Duration(seconds: _audioPlayer.position.inSeconds - 10),
    );

    return _audioPlayer.position.inSeconds;
  }

  @override
  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  @override
  Future<void> setSpeed(double speed) async {
    await _audioPlayer.setSpeed(speed);
  }

  @override
  Future<void> onTaskRemoved() async {
    await _audioPlayer.stop();
    return super.onTaskRemoved();
  }

  Duration? duration() {
    return _audioPlayer.duration;
  }

  double getSpeed() {
    return _audioPlayer.speed;
  }

  Future<void> loadEpisode(
    Episodes episode,
    bool isDownloaded,
    Podcasts podcast,
  ) async {
    Directory appDir = await getApplicationDocumentsDirectory();
    try {
      MediaItem audioMediaItem = MediaItem(
        id: episode.id,
        title: episode.title,
        album: podcast.title,
        duration: episode.duration,
        artUri:
            File('${appDir.path}/images/podcast/${episode.podcastId}.jpg').uri,
      );
      if (isDownloaded) {
        await _audioPlayer.setAudioSource(
          AudioSource.uri(
            File('${appDir.path}/episodes/${episode.podcastId}/${episode.id}.mp3')
                .uri,
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

      SharedPreferences prefs = await SharedPreferences.getInstance();
      int? possibleValue = prefs.getInt('${episode.id}_progress');
      if (possibleValue != null) {
        _audioPlayer.seek(Duration(seconds: possibleValue));
      } else {
        _audioPlayer.seek(Duration(seconds: 0));
      }

      _audioType = 'episode';
      queue.add([audioMediaItem]);
      mediaItem.add(audioMediaItem);

      if (cacheSub != null) {
        cacheSub!.cancel();
      }

      cacheSub = _audioPlayer.positionStream.listen((pos) async {
        // position stream has an initial value of zero before seeking
        // to the position that is stored in the cache. Which means
        // "seconds" needs to be bigger than zero.
        if (pos.inSeconds > 1) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setInt('${episode.id}_progress', pos.inSeconds);
        }
      });
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
      await _audioPlayer.setAudioSources([
        AudioSource.uri(Uri.parse(radio.listenUrl), tag: currentSong),
        AudioSource.uri(Uri.parse(radio.listenUrl), tag: nextSong)
      ]);
      await _audioPlayer.load();
      _audioType = 'coderadio';
      setEpisodeId = '';
      queue.add([currentSong, nextSong]);
      mediaItem.add(currentSong);
    } catch (e) {
      log('Cannot play audio: $e');
    }
  }

  bool isPlaying(String src, {String? episodeId}) {
    if (src == 'podcast') {
      return _audioPlayer.playing &&
          _audioPlayer.audioSource?.sequence[0].tag.id == episodeId &&
          _audioType == 'episode';
    } else if (src == 'coderadio') {
      return _audioPlayer.playing && _audioType == 'coderadio';
    } else {
      return false;
    }
  }

  Duration parseTimeStamp(String? timeStamp) {
    if (timeStamp == null || timeStamp == '0') {
      return const Duration(milliseconds: 0);
    }

    return Duration(
      milliseconds: (double.parse(timeStamp) * 1000).round(),
    );
  }

  // TODO: Move to a common constants like file for curriculum stuff
  String returnUrl(String fileName) {
    return 'https://cdn.freecodecamp.org/curriculum/english/animation-assets/sounds/$fileName';
  }

  bool canSeek(bool forward, int currentDuration, AudioClip audio) {
    currentDuration =
        currentDuration + parseTimeStamp(audio.startTimeStamp).inSeconds;

    if (forward) {
      return currentDuration + 2 <
          parseTimeStamp(audio.finishTimeStamp).inSeconds;
    } else {
      return currentDuration - 2 >
          parseTimeStamp(audio.startTimeStamp).inSeconds;
    }
  }

  Future<void> loadCurriculumAudio(AudioClip audio) async {
    await _audioPlayer.setAudioSource(
      ClippingAudioSource(
        start: parseTimeStamp(audio.startTimeStamp),
        end: audio.finishTimeStamp == null
            ? null
            : parseTimeStamp(audio.finishTimeStamp),
        child: AudioSource.uri(
          Uri.parse(returnUrl(audio.fileName)),
        ),
      ),
    );
    await _audioPlayer.load();
    setEpisodeId = '';
    _audioType = 'curriculum';
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
          ),
        );
      },
    );
  }
}
