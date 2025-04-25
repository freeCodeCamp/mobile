import 'dart:async';
import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/models/podcasts/episodes_model.dart';
import 'package:freecodecamp/models/podcasts/podcasts_model.dart';
import 'package:freecodecamp/service/audio/audio_service.dart';
import 'package:freecodecamp/service/podcast/download_service.dart';
import 'package:freecodecamp/service/podcast/podcasts_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stacked/stacked.dart';

class EpisodeViewModel extends BaseViewModel {
  final audioService = locator<AppAudioService>().audioHandler;
  final _databaseService = locator<PodcastsDatabaseService>();
  final DownloadService downloadService = locator<DownloadService>();

  StreamSubscription<Duration>? _progressListener;
  StreamSubscription<Duration>? get progressListener => _progressListener;

  double _sliderValue = 0.0;
  double get sliderValue => _sliderValue;

  bool _isPlaying = false;
  bool get isPlaying => _isPlaying;

  double _playBackSpeed = 1.0;
  double get playBackSpeed => _playBackSpeed;

  String _timeElapsed = '--:--';
  String get timeElapsed => _timeElapsed;

  String _timeLeft = '--:--';
  String get timeLeft => _timeLeft;

  bool _isDownloading = false;
  bool get isDownloading => _isDownloading;

  bool _isDownloaded = false;
  bool get isDownloaded => _isDownloaded;

  final List<double> speedOptions = [0.75, 1.0, 1.25, 1.5, 2.0];

  set setSliderValue(double value) {
    _sliderValue = value;
    notifyListeners();
  }

  set setTimeElapsed(String value) {
    _timeElapsed = value;
    notifyListeners();
  }

  set setTimeLeft(String value) {
    _timeLeft = value;
    notifyListeners();
  }

  set setProgressListener(StreamSubscription<Duration>? value) {
    _progressListener = value;
    notifyListeners();
  }

  set setPlayBackSpeed(double value) {
    _playBackSpeed = value;
    notifyListeners();
  }

  set setIsDownloading(bool value) {
    _isDownloading = value;
    notifyListeners();
  }

  set setIsDownloaded(bool value) {
    _isDownloaded = value;
    notifyListeners();
  }

  set setIsPlaying(bool value) {
    _isPlaying = value;
    notifyListeners();
  }

  void initProgressListener(Episodes episode) {
    setProgressListener = AudioService.position.listen(
      (event) {
        int duration = episode.duration!.inSeconds;
        double sliderValue = event.inSeconds / duration;
        setSliderValue = sliderValue;
        handleTimeVortex(duration, event.inSeconds);
      },
    );
  }

  void handleTimeVortex(int duration, int inSeconds) {
    setTimeElapsed = timeDisplay(inSeconds);
    setTimeLeft = timeDisplay(duration - inSeconds - 1);
  }

  String timeDisplay(int totalSeconds) {
    int totalMinutes = totalSeconds ~/ 60;
    int totalHours = totalMinutes ~/ 60;

    int totalMinDisplay = totalMinutes % 60;
    int totalSecDisplay = totalSeconds % 60;

    String addZero(int val) {
      String v = val.toString();

      return v.length == 1 ? '0$v' : v;
    }

    String display = totalHours > 0 ? '$totalHours:' : '';
    display +=
        totalHours > 0 ? '${addZero(totalMinDisplay)}:' : '$totalMinDisplay:';
    display += addZero(totalSecDisplay);
    return display;
  }

  void removeEpisode(Episodes episode, Podcasts podcast) async {
    await _databaseService.removeEpisode(episode);
    await _databaseService.removePodcast(podcast);
    setIsDownloaded = false;
  }

  void downloadBtnClick(Episodes episode, Podcasts podcast) async {
    Directory appDir = await getApplicationSupportDirectory();

    if (!isDownloaded && isDownloading) {
      downloadService.download(episode, podcast);
    } else if (isDownloaded) {
      File audioFile =
          File('${appDir.path}/episodes/${podcast.id}/${episode.id}.mp3');
      if (audioFile.existsSync()) {
        audioFile.deleteSync();
      }

      removeEpisode(episode, podcast);
    }
  }

  void hasDownloadedEpisode(Episodes episode) async {
    setIsDownloaded = await _databaseService.episodeExists(episode);
  }

  void downloadComplete() {
    setIsDownloading = false;
    setIsDownloaded = true;
    downloadService.setDownloadId = '';
  }

  void initDownloadListener() {
    downloadService.downloadingStream.listen(
      (event) {
        setIsDownloading = event;

        if (event == false) {
          setIsDownloaded = true;
          setIsDownloading = false;
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

  void handlePlayBackSpeed(speed) {
    setPlayBackSpeed = speed;
    audioService.setSpeed(speed);
  }

  void loadEpisode(Episodes episode, Podcasts podcast) async {
    bool downloaded = await _databaseService.episodeExists(episode);

    audioService.loadEpisode(episode, downloaded, podcast);
  }
}
