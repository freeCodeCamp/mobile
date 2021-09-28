import 'dart:developer';

import 'package:just_audio/just_audio.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:stacked/stacked.dart';

class EpisodeViewModel extends BaseViewModel {
  final audioPlayer = AudioPlayer();
  bool playing = false;
  final Episode episode;

  EpisodeViewModel(this.episode);

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  void init(String url) {
    audioPlayer.setUrl(url);
    audioPlayer.load();
  }

  void playBtnClick() {
    log("CLICKED PLAY BUTTON ${episode.title}");
    if (!playing) {
      audioPlayer.play();
      playing = true;
    } else {
      audioPlayer.pause();
      playing = false;
    }
    notifyListeners();
  }

  void downloadBtnClick() => log("CLICKED DOWNLOAD BUTTON ${episode.title}");
}
