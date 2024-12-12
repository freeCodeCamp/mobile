import 'dart:developer';

import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:just_audio/just_audio.dart';
import 'package:stacked/stacked.dart';

class AudioPlayerViewmodel extends BaseViewModel {
  AudioPlayer player = AudioPlayer();

  String returnUrl(String fileName) {
    return 'https://cdn.freecodecamp.org/curriculum/english/animation-assets/sounds/$fileName';
  }

  Duration parseTimeStamp(String timeStamp) {
    if (timeStamp == '0') {
      return const Duration(milliseconds: 0);
    }
    return Duration(
      milliseconds: (double.parse(timeStamp) * 1000).round(),
    );
  }

  Duration searchTimeStamp(
    bool forwards,
    int currentPosition,
    EnglishAudio audio,
  ) {
    log('Current Position: $currentPosition');
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

  bool canSeek(bool forward, int currentDuration, EnglishAudio audio) {
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

  void loadAudio(EnglishAudio audio) {
    player.setAudioSource(
      ClippingAudioSource(
        start: parseTimeStamp(audio.startTimeStamp),
        end: parseTimeStamp(audio.finishTimeStamp),
        child: AudioSource.uri(
          Uri.parse(
            returnUrl(audio.fileName),
          ),
        ),
      ),
    );
  }
}
