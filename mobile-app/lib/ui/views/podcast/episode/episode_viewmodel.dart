import 'dart:async';
import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecodecamp/core/providers/service_providers.dart';
import 'package:freecodecamp/models/podcasts/episodes_model.dart';
import 'package:freecodecamp/models/podcasts/podcasts_model.dart';
import 'package:freecodecamp/service/audio/audio_service.dart';
import 'package:freecodecamp/service/podcast/download_service.dart';
import 'package:freecodecamp/service/podcast/podcasts_service.dart';
import 'package:path_provider/path_provider.dart';

class EpisodeState {
  const EpisodeState({
    this.sliderValue = 0.0,
    this.isPlaying = false,
    this.playBackSpeed = 1.0,
    this.timeElapsed = '--:--',
    this.timeLeft = '--:--',
    this.isDownloading = false,
    this.isDownloaded = false,
  });

  final double sliderValue;
  final bool isPlaying;
  final double playBackSpeed;
  final String timeElapsed;
  final String timeLeft;
  final bool isDownloading;
  final bool isDownloaded;

  EpisodeState copyWith({
    double? sliderValue,
    bool? isPlaying,
    double? playBackSpeed,
    String? timeElapsed,
    String? timeLeft,
    bool? isDownloading,
    bool? isDownloaded,
  }) {
    return EpisodeState(
      sliderValue: sliderValue ?? this.sliderValue,
      isPlaying: isPlaying ?? this.isPlaying,
      playBackSpeed: playBackSpeed ?? this.playBackSpeed,
      timeElapsed: timeElapsed ?? this.timeElapsed,
      timeLeft: timeLeft ?? this.timeLeft,
      isDownloading: isDownloading ?? this.isDownloading,
      isDownloaded: isDownloaded ?? this.isDownloaded,
    );
  }
}

class EpisodeNotifier extends Notifier<EpisodeState> {
  late AppAudioService _appAudioService;
  late PodcastsDatabaseService _databaseService;
  late DownloadService _downloadService;

  StreamSubscription<Duration>? _progressListener;

  final List<double> speedOptions = [0.75, 1.0, 1.25, 1.5, 2.0];

  @override
  EpisodeState build() {
    _appAudioService = ref.watch(appAudioServiceProvider);
    _databaseService = ref.watch(podcastsDatabaseServiceProvider);
    _downloadService = ref.watch(downloadServiceProvider);

    ref.onDispose(() {
      _progressListener?.cancel();
    });

    return const EpisodeState();
  }

  AppAudioService get appAudioService => _appAudioService;
  DownloadService get downloadService => _downloadService;

  void initProgressListener(Episodes episode) {
    if (_appAudioService.audioHandler.episodeId == episode.id ||
        _appAudioService.audioHandler.episodeId.isEmpty) {
      _progressListener = AudioService.position.listen(
        (event) {
          int duration = episode.duration!.inSeconds;
          double sliderValue = event.inSeconds / duration;
          state = state.copyWith(sliderValue: sliderValue);
          handleTimeVortex(duration, event.inSeconds);
        },
      );
    }
  }

  void handleTimeVortex(int duration, int inSeconds) {
    state = state.copyWith(
      timeElapsed: timeDisplay(inSeconds),
      timeLeft: timeDisplay(duration - inSeconds - 1),
    );
  }

  String timeDisplay(int totalSeconds) {
    int hours = totalSeconds ~/ 3600;
    int minutes = (totalSeconds % 3600) ~/ 60;
    int seconds = totalSeconds % 60;

    String twoDigits(int n) => n.toString().padLeft(2, '0');

    if (hours > 0) {
      return '$hours:${twoDigits(minutes)}:${twoDigits(seconds)}';
    } else {
      return '$minutes:${twoDigits(seconds)}';
    }
  }

  void removeEpisode(Episodes episode, Podcasts podcast) async {
    await _databaseService.removeEpisode(episode);
    await _databaseService.removePodcast(podcast);
    state = state.copyWith(isDownloaded: false);
  }

  void downloadBtnClick(Episodes episode, Podcasts podcast) async {
    _downloadService.setDownloadId = episode.id;
    Directory appDir = await getApplicationSupportDirectory();

    if (!state.isDownloaded && state.isDownloading) {
      _downloadService.download(episode, podcast);
    } else if (state.isDownloaded) {
      File audioFile =
          File('${appDir.path}/episodes/${podcast.id}/${episode.id}.mp3');
      if (audioFile.existsSync()) {
        audioFile.deleteSync();
      }

      removeEpisode(episode, podcast);
    }
  }

  void hasDownloadedEpisode(Episodes episode) async {
    state = state.copyWith(
      isDownloaded: await _databaseService.episodeExists(episode),
    );
  }

  void initDownloadListener(Episodes episode) {
    if (_downloadService.isDownloading &&
        _downloadService.downloadId == episode.id) {
      state = state.copyWith(isDownloading: true);
    }
    _downloadService.downloadingStream.listen(
      (event) async {
        if (_downloadService.downloadId == episode.id) {
          if (event == false) {
            state = state.copyWith(isDownloaded: true, isDownloading: false);
          }
        }
      },
    );
  }

  void initPlaybackListener() {
    _appAudioService.audioHandler.playbackState.listen((event) {
      if (event.playing && !state.isPlaying) {
        state = state.copyWith(isPlaying: true);
      } else if (!event.playing && state.isPlaying) {
        state = state.copyWith(isPlaying: false);
      }
    });
  }

  void setAudioProgress(double value, Episodes episode) {
    _appAudioService.audioHandler.seek(
      Duration(seconds: (value * episode.duration!.inSeconds).toInt()),
    );
    state = state.copyWith(sliderValue: value);
  }

  void setSliderValue(double value) {
    state = state.copyWith(sliderValue: value);
  }

  void setIsDownloading(bool value) {
    state = state.copyWith(isDownloading: value);
  }

  void disposeProgressListener() {
    _progressListener?.cancel();
  }

  void forward(Episodes episode) async {
    int newPos = await _appAudioService.audioHandler.fastForward();

    double value = newPos / episode.duration!.inSeconds;

    state = state.copyWith(sliderValue: value < 1 ? value : 1.0);
  }

  void rewind(Episodes episode) async {
    int newPos = await _appAudioService.audioHandler.rewind();

    double value = newPos / episode.duration!.inSeconds;

    state = state.copyWith(sliderValue: value > 0 ? value : 0.0);
  }

  void playOrPause(Episodes episode, Podcasts podcast) {
    if (_appAudioService.audioHandler
        .isPlaying('podcast', episodeId: episode.id)) {
      _appAudioService.audioHandler.pause();
    } else {
      loadEpisode(episode, podcast);
      _appAudioService.audioHandler.play();
    }
  }

  void handlePlayBackSpeed(speed) {
    state = state.copyWith(playBackSpeed: speed as double);
    _appAudioService.audioHandler.setSpeed(speed);
  }

  void initPlayBackSpeed() {
    state = state.copyWith(
      playBackSpeed: _appAudioService.audioHandler.getSpeed(),
    );
  }

  void loadEpisode(Episodes episode, Podcasts podcast) async {
    bool downloaded = await _databaseService.episodeExists(episode);

    if (_appAudioService.audioHandler.episodeId != episode.id) {
      _appAudioService.audioHandler.setEpisodeId = episode.id;
      _appAudioService.audioHandler.loadEpisode(episode, downloaded, podcast);
      initProgressListener(episode);
    }
  }
}

final episodeProvider =
    NotifierProvider<EpisodeNotifier, EpisodeState>(EpisodeNotifier.new);
