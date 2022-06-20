import 'dart:async';
import 'dart:developer';

import 'package:freecodecamp/models/podcasts/episodes_model.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

class EpisodeAudioService {
  static final EpisodeAudioService _episodeAudioService =
      EpisodeAudioService._internal();
  final AudioPlayer _audioPlayer = AudioPlayer();

  String _episodeId = '';
  String get episodeId => _episodeId;

  static final StreamController<bool> _isPlayingEpisode =
      StreamController.broadcast();

  StreamController<bool> get isPlayingEpisode => _isPlayingEpisode;

  final Stream<bool> _isPlayingEpisodeStream = _isPlayingEpisode.stream;
  Stream<bool> get isPlayingEpisodeStream => _isPlayingEpisodeStream;

  set setEpisodeId(String state) {
    _episodeId = state;
  }

  factory EpisodeAudioService() {
    return _episodeAudioService;
  }

  Future<void> loadEpisode(Episodes episode, bool isDownloaded) async {
    try {
      if (isDownloaded) {
        await _audioPlayer.setAudioSource(
          AudioSource.uri(
            Uri.parse(
                'file:///data/user/0/org.freecodecamp/app_flutter/episodes/${episode.podcastId}/${episode.id}.mp3'),
            tag: MediaItem(
              id: episode.id,
              title: episode.title,
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
              id: episode.id,
              title: episode.title,
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

  Future<void> playAudio(Episodes episode, bool isDownloaded) async {
    if (_audioPlayer.playerState.processingState == ProcessingState.idle) {
      await loadEpisode(episode, isDownloaded);
    }
    if (episode.id != _audioPlayer.audioSource?.sequence[0].tag.id) {
      await _audioPlayer.stop();
      await loadEpisode(episode, isDownloaded);
    }
    _audioPlayer.play();
    isPlayingEpisode.sink.add(true);
  }

  Future<void> pauseAudio() async {
    _audioPlayer.pause();
    isPlayingEpisode.sink.add(false);
  }

  void disposePlayer() {
    _audioPlayer.dispose();
  }

  EpisodeAudioService._internal();
}
