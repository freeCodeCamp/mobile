import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/models/podcasts/episodes_model.dart';
import 'package:freecodecamp/service/audio/audio_service.dart';
import 'package:stacked/stacked.dart';

class EpisodeViewModel extends BaseViewModel {
  final audioService = locator<AppAudioService>().audioHandler;

  StreamSubscription<Duration>? _progressListener;
  StreamSubscription<Duration>? get progressListener => _progressListener;

  double _sliderValue = 0.0;
  double get sliderValue => _sliderValue;

  set setSliderValue(double value) {
    _sliderValue = value;
    notifyListeners();
  }

  set setProgressListener(StreamSubscription<Duration>? value) {
    _progressListener = value;
    notifyListeners();
  }

  void init(Episodes episode) {
    setProgressListener = AudioService.position.listen(
      (event) {
        if (audioService.episodeId == episode.id) {
          setSliderValue = event.inSeconds.toDouble() /
              episode.duration!.inSeconds.toDouble();
        }
      },
    );
  }

  void setAudioProgress(double value, Episodes episode) {
    audioService.seek(
      Duration(seconds: (value * episode.duration!.inSeconds).toInt()),
    );
    setSliderValue = value.toDouble();
  }

  void pauseAudio() {
    audioService.pause();
  }
}
