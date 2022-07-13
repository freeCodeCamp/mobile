import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fk_user_agent/fk_user_agent.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/models/podcasts/episodes_model.dart';
import 'package:freecodecamp/models/podcasts/podcasts_model.dart';
import 'package:freecodecamp/service/podcasts_service.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:developer' as dev;

class DownloadService {
  final Dio dio = Dio();
  static final DownloadService _downloadService = DownloadService._internal();
  final _databaseService = locator<PodcastsDatabaseService>();

  static final StreamController<String> _progStream =
      StreamController<String>.broadcast();
  StreamController get progStream => _progStream;

  final Stream<String> _porgress = _progStream.stream;
  Stream<String> get progress => _porgress;

  static final StreamController<bool> _downloading =
      StreamController<bool>.broadcast();

  final Stream<bool> _downloadingStream = _downloading.stream;
  Stream<bool> get downloadingStream => _downloadingStream;

  set setDownloadId(String state) {
    _downloadId = state;
  }

  String _downloadId = '';
  String get downloadId => _downloadId;

  factory DownloadService() {
    return _downloadService;
  }

  void download(Episodes episode, Podcasts podcast) async {
    Directory app = await getApplicationDocumentsDirectory();
    dev.log(_downloadId);
    _downloading.sink.add(true);

    String path = '${app.path}/episodes/${podcast.id}/${episode.id}.mp3';

    await dio.download(episode.contentUrl!, path,
        onReceiveProgress: (int recevied, int total) {
      _progStream.sink.add(((recevied / total) * 100).toStringAsFixed(0));
    }, options: Options(headers: {'User-Agent': FkUserAgent.userAgent}));
    _downloading.sink.add(false);
    setDownloadId = '';
    _progStream.sink.add('');
    await _databaseService.addPodcast(podcast);
    await _databaseService.addEpisode(episode);
  }

  DownloadService._internal();
}
