import 'dart:developer';

import 'package:freecodecamp/models/podcasts/episodes_model.dart';
import 'package:freecodecamp/models/podcasts/podcasts_model.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_service/audio_service.dart';

// May not be required as service is instantiated in main.dart and attached
// to below Audio Player Handler.
// class AppAudioService {
//   static final AppAudioService _audioService = AppAudioService._internal();

//   late AudioHandler _audioHandler;

//   factory AppAudioService() {
//     return _audioService;
//   }

//   Future<void> init() async {
//     _audioHandler = await AudioService.init(
//       builder: () => AudioPlayerHandler(),
//       config: const AudioServiceConfig(
//         androidNotificationChannelId: 'org.freecodecamp.channel.audio',
//         androidNotificationChannelName: 'Audio playback',
//         androidNotificationOngoing: true,
//         androidStopForegroundOnPause: true,
//       ),
//     );
//   }

//   AppAudioService._internal();
// }

class AudioPlayerHandler extends BaseAudioHandler {
  final AudioPlayer _audioPlayer = AudioPlayer();

  // @override
  // AudioPlayerHandler() {}

  // Future<void> play(Episodes episode, bool isDownloaded) async {
  @override
  Future<void> play() async {
    // if (_audioPlayer.playerState.processingState == ProcessingState.idle) {
    //   await loadEpisode(episode, isDownloaded);
    // }
    // if (episode.id != _audioPlayer.audioSource?.sequence[0].tag.id) {
    //   log('DIFFERENT EPISODE');
    //   await _audioPlayer.stop();
    //   await loadEpisode(episode, isDownloaded);
    // }
    playbackState.add(playbackState.value.copyWith(
      playing: true,
      controls: [MediaControl.pause],
    ));
    _audioPlayer.play();
  }

  @override
  Future<void> pause() async {
    playbackState.add(playbackState.value.copyWith(
      playing: false,
      controls: [MediaControl.play],
    ));
    await _audioPlayer.pause();
  }

  @override
  Future<void> stop() async {
    await _audioPlayer.stop();
    playbackState.add(playbackState.value.copyWith(
      processingState: AudioProcessingState.idle,
    ));
  }

  Future<void> loadEpisode(
    Episodes episode,
    bool isDownloaded,
    Podcasts podcast,
  ) async {
    playbackState.add(playbackState.value.copyWith(
      controls: [MediaControl.play],
      processingState: AudioProcessingState.loading,
    ));
    try {
      if (isDownloaded) {
        _audioPlayer
            .setAudioSource(
          AudioSource.uri(
            Uri.parse(
                'file:///data/user/0/org.freecodecamp/app_flutter/episodes/${episode.podcastId}/${episode.id}.mp3'),
            tag: MediaItem(
              id: episode.id,
              title: episode.title,
              album: podcast.title,
              artUri: Uri.parse(
                  'file:///data/user/0/org.freecodecamp/app_flutter/images/podcast/${episode.podcastId}.jpg'),
            ),
          ),
          preload: true,
        )
            .then((_) {
          playbackState.add(playbackState.value.copyWith(
            processingState: AudioProcessingState.ready,
          ));
        });
      } else {
        _audioPlayer
            .setAudioSource(
          AudioSource.uri(
            Uri.parse(episode.contentUrl!),
            tag: MediaItem(
              id: episode.id,
              title: episode.title,
              album: podcast.title,
              artUri: Uri.parse(
                  'file:///data/user/0/org.freecodecamp/app_flutter/images/podcast/${episode.podcastId}.jpg'),
            ),
          ),
          preload: true,
        )
            .then((_) {
          playbackState.add(playbackState.value.copyWith(
            processingState: AudioProcessingState.ready,
          ));
        });
      }
      await _audioPlayer.load();
    } catch (e) {
      log('Cannot play audio: $e');
    }
  }

  bool isPlaying(String episodeId) {
    return _audioPlayer.playing &&
        _audioPlayer.audioSource?.sequence[0].tag.id == episodeId;
  }
}
