import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fk_user_agent/fk_user_agent.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/models/podcasts/episodes_model.dart';
import 'package:freecodecamp/models/podcasts/podcasts_model.dart';
import 'package:freecodecamp/service/audio_service.dart';
import 'package:freecodecamp/service/notification_service.dart';
import 'package:freecodecamp/service/podcasts_service.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:stacked/stacked.dart';

class EpisodeViewModel extends BaseViewModel {
  final _databaseService = locator<PodcastsDatabaseService>();
  final _notificationService = locator<NotificationService>();
  final _audioPlayerHandler = locator<AppAudioService>().audioHandler;
  Episodes episode;
  final Podcasts podcast;
  late final Directory appDir;
  // late bool downloaded = episode.downloaded;
  late bool downloaded = false;
  bool playing = false;
  bool loading = false;
  bool downloading = false;
  String progress = '0';
  var dio = Dio();

  EpisodeViewModel(this.episode, this.podcast);

  Future init(Episodes episode, bool isDownloadView) async {
    await _databaseService.initialise();
    await FkUserAgent.init();
    // episode = await _databaseService.getEpisode(podcast.id, episode.guid);
    log(episode.toString());
    playing = _audioPlayerHandler.isPlaying(episode.id);
    downloaded = await _databaseService.episodeExists(episode);
    notifyListeners();
    appDir = await getApplicationDocumentsDirectory();
    if (!isDownloadView) {
      File podcastImgFile =
          File('${appDir.path}/images/podcast/${episode.podcastId}.jpg');
      if (!podcastImgFile.existsSync()) {
        podcastImgFile.createSync(recursive: true);
        var res = await http.get(Uri.parse(podcast.image!));
        podcastImgFile.writeAsBytesSync(res.bodyBytes);
      }
    }
  }

  // Make this even more better UI and logic wise. Also check for notification update
  void downloadAudio(String uri) async {
    downloading = true;
    notifyListeners();
    log('DOWNLOADING... $uri');
    log('USER AGENT ${FkUserAgent.userAgent}');
    // ignore: unused_local_variable
    var response = await dio.download(uri,
        appDir.path + '/episodes/' + podcast.id + '/' + episode.id + '.mp3',
        onReceiveProgress: (int recevied, int total) {
      progress = ((recevied / total) * 100).toStringAsFixed(0);
      // log('$recevied / $total : ${((recevied / total) * 100).toStringAsFixed(2)}');
      notifyListeners();
    }, options: Options(headers: {'User-Agent': FkUserAgent.userAgent}));
    downloading = false;
    await _notificationService.showNotification(
      'Download Complete',
      episode.title,
    );
    await _databaseService.addPodcast(podcast);
    await _databaseService.addEpisode(episode);
    log('Downloaded episode ${episode.title}');
    notifyListeners();
  }

  Future<void> playBtnClick() async {
    log('CLICKED PLAY BUTTON ${episode.title}');
    if (!loading) {
      if (!playing) {
        loading = true;
        notifyListeners();
        await _audioPlayerHandler.loadEpisode(episode, downloaded, podcast);
        await _audioPlayerHandler.play();
        playing = true;
      } else {
        await _audioPlayerHandler.pause();
        playing = false;
      }
      loading = false;
    }
    notifyListeners();
  }

  void removeEpisode() async {
    await _databaseService.removeEpisode(episode);
    await _databaseService.removePodcast(podcast);
    notifyListeners();
  }

  void downloadBtnClick() {
    log('CLICKED DOWNLOAD BUTTON ${episode.title}, status $downloaded');
    if (!downloaded && !downloading) {
      log('STARTING DOWNLOAD');
      downloadAudio(episode.contentUrl!);
      downloaded = !downloaded;
    } else if (downloaded) {
      log('DELETING DOWNLOAD');
      File audioFile = File(
          appDir.path + '/episodes/' + podcast.id + '/' + episode.id + '.mp3');
      if (audioFile.existsSync()) {
        audioFile.deleteSync();
      }
      downloaded = !downloaded;
      removeEpisode();
      progress = '0';
    }
    notifyListeners();
  }
}
