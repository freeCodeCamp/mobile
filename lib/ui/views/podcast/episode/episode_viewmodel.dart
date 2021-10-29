import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/models/podcasts/episodes_model.dart';
import 'package:freecodecamp/models/podcasts/podcasts_model.dart';
import 'package:freecodecamp/service/podcasts_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stacked/stacked.dart';

class EpisodeViewModel extends BaseViewModel {
  final _databaseService = locator<PodcastsDatabaseService>();
  final audioPlayer = AudioPlayer();
  final Episodes episode;
  final Podcasts podcast;
  late final Directory appDir;
  late bool downloaded = episode.downloaded;
  bool playing = false;
  bool downloading = false;
  String progress = '0';
  var dio = Dio();

  EpisodeViewModel(this.episode, this.podcast);

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  Future init(String url) async {
    await _databaseService.initialise();
    appDir = await getApplicationDocumentsDirectory();
    log("DIR: ${appDir.path} ${appDir.uri}");
    log(episode.toString());
    downloaded = episode.downloaded;
    // STRESS-TEST: Check if this one works properly when no net present
    log('Loading audio');
    try {
      if (episode.downloaded) {
        await audioPlayer.setAudioSource(
          AudioSource.uri(
            Uri.parse(
                'file:///data/user/0/org.freecodecamp/app_flutter/episodes/${podcast.id}/${episode.guid}.mp3'),
            tag: MediaItem(
              id: episode.guid,
              title: episode.title!,
              album: 'freeCodeCamp Podcast',
              artUri: Uri.parse(
                  'file:///data/user/0/org.freecodecamp/app_flutter/images/podcast/${podcast.id}.jpg'),
            ),
          ),
        );
      } else {
        await audioPlayer.setAudioSource(
          AudioSource.uri(
            Uri.parse(url),
            tag: MediaItem(
              id: episode.guid,
              title: episode.title!,
              album: 'freeCodeCamp Podcast',
              artUri: Uri.parse(
                  'file:///data/user/0/org.freecodecamp/app_flutter/images/podcast/${podcast.id}.jpg'),
            ),
          ),
        );
      }
      await audioPlayer.load();
    } catch (e) {
      log("Cannot play audio $e");
    }
    log('Episode initialised');
  }

  // Make this even more better UI and logic wise. Also check for notification update
  void downloadAudio(String uri) async {
    downloading = true;
    notifyListeners();
    log('DOWNLOADIN...');
    await dio.download(uri,
        appDir.path + '/episodes/' + podcast.id + '/' + episode.guid + '.mp3',
        onReceiveProgress: (int recevied, int total) {
      progress = ((recevied / total) * 100).toStringAsFixed(2);
      // log('$recevied / $total : ${((recevied / total) * 100).toStringAsFixed(2)}');
      notifyListeners();
    }).whenComplete(() {
      downloading = false;
      log('Downloaded episode ${episode.title}');
    });
    notifyListeners();
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

  void downloadBtnClick() {
    log("CLICKED DOWNLOAD BUTTON ${episode.title}, status $downloaded");
    if (!downloaded && !downloading) {
      log("STARTING DOWNLOAD");
      downloadAudio(episode.contentUrl!);
      downloaded = !downloaded;
      episode.downloaded = downloaded;
      _databaseService.toggleDownloadEpisode(episode.guid, downloaded);
      notifyListeners();
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
      notifyListeners();
    }
  }
}
