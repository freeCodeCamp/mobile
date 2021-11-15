import 'dart:developer';

import 'package:freecodecamp/models/podcasts/episodes_model.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

class EpisodeAudioService {
  static final EpisodeAudioService _episodeAudioService = EpisodeAudioService._internal();
  final AudioPlayer _audioPlayer = AudioPlayer();

  factory EpisodeAudioService() {
    return _episodeAudioService;
  }

  Future<void> loadEpisode(Episodes episode) async {
    try {
      if (episode.downloaded) {
        await _audioPlayer.setAudioSource(
          AudioSource.uri(
            Uri.parse(
                'file:///data/user/0/org.freecodecamp/app_flutter/episodes/${episode.podcastId}/${episode.guid}.mp3'),
            tag: MediaItem(
              id: episode.guid,
              title: episode.title!,
              album: 'freeCodeCamp Podcast',
              artUri: Uri.parse(
                  'file:///data/user/0/org.freecodecamp/app_flutter/images/podcast/${episode.podcastId}.jpg'),
            ),
          ),
          preload: false,
        );
      } else {
        await _audioPlayer.setAudioSource(
          AudioSource.uri(
            Uri.parse(episode.contentUrl!),
            tag: MediaItem(
              id: episode.guid,
              title: episode.title!,
              album: 'freeCodeCamp Podcast',
              artUri: Uri.parse(
                  'file:///data/user/0/org.freecodecamp/app_flutter/images/podcast/${episode.podcastId}.jpg'),
            ),
          ),
          preload: false,
        );
      }
      await _audioPlayer.load();
    } catch (e) {
      log('Cannot play audio: $e');
    }
  }

  Future<void> playAudio(Episodes episode) async {
    if (_audioPlayer.playerState.processingState == ProcessingState.idle) {
      await loadEpisode(episode);
    }
    if (episode.guid != _audioPlayer.audioSource?.sequence[0].tag.id) {
      log('DIFFERENT EPISODE');
      await _audioPlayer.stop();
      await loadEpisode(episode);
    }
    _audioPlayer.play();
  }

  Future<void> pauseAudio() async {
    _audioPlayer.pause();
  }

  void disposePlayer() {
    _audioPlayer.dispose();
  }

  bool isPlaying(String episodeId) {
    return _audioPlayer.playing &&
        _audioPlayer.audioSource?.sequence[0].tag.id == episodeId;
  }

  EpisodeAudioService._internal();
}
