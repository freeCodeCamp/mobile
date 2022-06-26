import 'dart:developer';
import 'dart:io';

import 'package:freecodecamp/models/podcasts/episodes_model.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:path_provider/path_provider.dart';

class EpisodeAudioService {
  static final EpisodeAudioService _episodeAudioService =
      EpisodeAudioService._internal();
  final AudioPlayer _audioPlayer = AudioPlayer();
  final bool isAndroid = Platform.isAndroid;
  late final Directory appDir;

  factory EpisodeAudioService() {
    return _episodeAudioService;
  }

  Future<void> init() async {
    appDir = await getApplicationDocumentsDirectory();
  }

  Future<void> loadEpisode(Episodes episode, bool isDownloaded) async {
    try {
      MediaItem episodeMediaItem = MediaItem(
        id: episode.id,
        title: episode.title,
        album: 'freeCodeCamp Podcast',
        artUri:
            File('${appDir.path}/images/podcast/${episode.podcastId}.jpg').uri,
      );
      // 'file:///data/user/0/org.freecodecamp/app_flutter/images/podcast/${episode.podcastId}.jpg'),
      if (isDownloaded) {
        await _audioPlayer.setAudioSource(
          AudioSource.uri(
            // Uri.parse(
            //     'file:///data/user/0/org.freecodecamp/app_flutter/episodes/${episode.podcastId}/${episode.id}.mp3'),
            File('${appDir.path}/episodes/${episode.podcastId}/${episode.id}.mp3')
                .uri,
            tag: episodeMediaItem,
          ),
          preload: false,
        );
      } else {
        await _audioPlayer.setAudioSource(
          AudioSource.uri(
            Uri.parse(episode.contentUrl!),
            tag: episodeMediaItem,
          ),
          preload: false,
        );
      }
      await _audioPlayer.load();
    } catch (e) {
      log('Cannot play audio: $e');
    }
  }

  Future<void> playAudio(Episodes episode, bool isDownloaded) async {
    if (_audioPlayer.playerState.processingState == ProcessingState.idle) {
      await loadEpisode(episode, isDownloaded);
    }
    if (episode.id != _audioPlayer.audioSource?.sequence[0].tag.id) {
      log('DIFFERENT EPISODE');
      await _audioPlayer.stop();
      await loadEpisode(episode, isDownloaded);
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
