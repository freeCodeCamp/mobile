import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:freecodecamp/service/audio/audio_service.dart';
import 'package:stacked/stacked.dart';

class AudioPlayerViewmodel extends BaseViewModel {
  final audioService = locator<AppAudioService>().audioHandler;

  StreamController<Duration> position = StreamController<Duration>.broadcast();

  Duration? _totalDuration;
  Duration? get totalDuration => _totalDuration;

  Duration searchTimeStamp(
    bool forwards,
    int currentPosition,
    EnglishScene audio,
  ) {
    if (forwards) {
      return Duration(
        seconds: currentPosition + 2,
      );
    } else {
      return Duration(
        milliseconds: currentPosition - 2,
      );
    }
  }

  void initPositionListener() {
    AudioService.position.listen((event) {
      if (position.isClosed) {
        return;
      }

      position.add(event);
    });
  }

  void onDispose() {
    position.close();
    audioService.stop();
  }
}
