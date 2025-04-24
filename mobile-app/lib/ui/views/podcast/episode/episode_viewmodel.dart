import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/models/podcasts/episodes_model.dart';
import 'package:freecodecamp/models/podcasts/podcasts_model.dart';
import 'package:freecodecamp/service/audio/audio_service.dart';
import 'package:freecodecamp/service/podcast/podcasts_service.dart';
import 'package:stacked/stacked.dart';

class EpisodeViewModel extends BaseViewModel {
  final audioService = locator<AppAudioService>().audioHandler;
  final _databaseService = locator<PodcastsDatabaseService>();

  StreamSubscription<Duration>? _progressListener;
  StreamSubscription<Duration>? get progressListener => _progressListener;

  double _sliderValue = 0.0;
  double get sliderValue => _sliderValue;

  bool _isPlaying = false;
  bool get isPlaying => _isPlaying;

  set setSliderValue(double value) {
    _sliderValue = value;
    notifyListeners();
  }

  set setProgressListener(StreamSubscription<Duration>? value) {
    _progressListener = value;
    notifyListeners();
  }

  set setIsPlaying(bool value) {
    _isPlaying = value;
    notifyListeners();
  }

  void initProgressListener(Episodes episode) {
    setProgressListener = AudioService.position.listen(
      (event) {
        if (audioService.episodeId == episode.id) {
          setSliderValue = event.inSeconds.toDouble() /
              episode.duration!.inSeconds.toDouble();
        }
      },
    );
  }

  void initPlaybackListener() {
    audioService.playbackState.listen((event) {
      if (event.playing && !isPlaying) {
        setIsPlaying = true;
      } else if (!event.playing && isPlaying) {
        setIsPlaying = false;
      }
    });
  }

  void setAudioProgress(double value, Episodes episode) {
    audioService.seek(
      Duration(seconds: (value * episode.duration!.inSeconds).toInt()),
    );
    setSliderValue = value.toDouble();
  }

  void foward(Episodes episode) async {
    int newPos = await audioService.fastForward();

    double value = newPos / episode.duration!.inSeconds;

    setSliderValue = value < 1 ? value : 1.0;
  }

  void rewind(Episodes episode) async {
    int newPos = await audioService.rewind();

    double value = newPos / episode.duration!.inSeconds;

    setSliderValue = value > 0 ? value : 0.0;
  }

  void playOrPause(Episodes episode) {
    if (audioService.isPlaying('podcast', episodeId: episode.id)) {
      audioService.pause();
    } else {
      audioService.play();
    }
  }

  void loadEpisode(Episodes episode, Podcasts podcast) async {
    bool downloaded = await _databaseService.episodeExists(episode);

    audioService.loadEpisode(episode, downloaded, podcast);
  }
}
