import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/models/podcasts/episodes_model.dart';
import 'package:freecodecamp/models/podcasts/podcasts_model.dart';
import 'package:freecodecamp/service/episode_audio_service.dart';
import 'package:freecodecamp/service/notification_service.dart';
import 'package:freecodecamp/service/podcasts_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stacked/stacked.dart';
import 'package:fk_user_agent/fk_user_agent.dart';

class EpisodeViewModel extends BaseViewModel {
  final _databaseService = locator<PodcastsDatabaseService>();
  final _notificationService = locator<NotificationService>();
  final _audioService = locator<EpisodeAudioService>();
  Episodes episode;
  final Podcasts podcast;
  late final Directory appDir;
  late bool downloaded = episode.downloaded;
  bool playing = false;
  bool loading = false;
  bool downloading = false;
  String progress = '0';
  var dio = Dio();

  EpisodeViewModel(this.episode, this.podcast);

  Future init(String url) async {
    await _databaseService.initialise();
    episode = await _databaseService.getEpisode(podcast.id, episode.guid);
    log(episode.toString());
    playing = _audioService.isPlaying(episode.guid);
    downloaded = episode.downloaded;
    notifyListeners();
    await FkUserAgent.init();
    appDir = await getApplicationDocumentsDirectory();
  }

  // Make this even more better UI and logic wise. Also check for notification update
  void downloadAudio(String uri) async {
    downloading = true;
    notifyListeners();
    log('DOWNLOADING... $uri');
    log("USER AGENT ${FkUserAgent.userAgent}");
    var response = await dio.download(uri,
        appDir.path + '/episodes/' + podcast.id + '/' + episode.guid + '.mp3',
        onReceiveProgress: (int recevied, int total) {
      progress = ((recevied / total) * 100).toStringAsFixed(0);
      // log('$recevied / $total : ${((recevied / total) * 100).toStringAsFixed(2)}');
      notifyListeners();
    }, options: Options(headers: {'User-Agent': FkUserAgent.userAgent}));
    downloading = false;
    await _notificationService.showNotification(
      'Download Complete',
      episode.title!,
    );
    log('Downloaded episode ${episode.title}');
    notifyListeners();
  }

  Future<void> playBtnClick() async {
    log("CLICKED PLAY BUTTON ${episode.title}");
    if (!loading) {
      if (!playing) {
        loading = true;
        notifyListeners();
        await _audioService.playAudio(episode);
        playing = true;
      } else {
        await _audioService.pauseAudio();
        playing = false;
      }
      loading = false;
    }
    notifyListeners();
  }

  void downloadBtnClick() {
    log("CLICKED DOWNLOAD BUTTON ${episode.title}, status $downloaded");
    if (!downloaded && !downloading) {
      log("STARTING DOWNLOAD");
      downloadAudio(episode.contentUrl!);
      downloaded = !downloaded;
      episode.downloaded = downloaded;
      _databaseService.toggleDownloadEpisode(episode.guid, downloaded);
    } else if (downloaded) {
      log("DELETING DOWNLOAD");
      File audioFile = File(appDir.path +
          '/episodes/' +
          podcast.id +
          '/' +
          episode.guid +
          '.mp3');
      if (audioFile.existsSync()) {
        audioFile.deleteSync();
      }
      downloaded = !downloaded;
      episode.downloaded = downloaded;
      _databaseService.toggleDownloadEpisode(episode.guid, downloaded);
      progress = '0';
    }
    notifyListeners();
  }
}
