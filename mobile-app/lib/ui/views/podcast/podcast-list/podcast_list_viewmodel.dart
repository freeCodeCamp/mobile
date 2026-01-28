import 'dart:io';

import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/models/podcasts/podcasts_model.dart';
import 'package:freecodecamp/service/developer_service.dart';
import 'package:freecodecamp/service/dio_service.dart';
import 'package:freecodecamp/service/podcast/podcasts_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stacked/stacked.dart';

const fccPodcastUrls = [
  // English
  'https://freecodecamp.libsyn.com/rss',
  // Spanish
  'https://anchor.fm/s/ff0092f4/podcast/rss',
  // Chinese
  'https://anchor.fm/s/ff054de4/podcast/rss',
  // Portuguese
  'https://anchor.fm/s/ff026c00/podcast/rss',
];

class PodcastListViewModel extends BaseViewModel {
  final _databaseService = locator<PodcastsDatabaseService>();
  final _developerService = locator<DeveloperService>();
  static late Directory appDir;
  int _index = 0;
  final _dio = DioService.dio;

  int get index => _index;

  void setIndex(i) {
    _index = i;
    notifyListeners();
  }

  Future<void> init() async {
    appDir = await getApplicationDocumentsDirectory();
  }

  void refresh() {
    notifyListeners();
  }

  Future<List<Podcasts>> fetchPodcasts(bool isDownloadView) async {
    String baseUrl = (await _developerService.developmentMode())
        ? 'https://api.mobile.freecodecamp.dev'
        : 'https://api.mobile.freecodecamp.org';
    if (isDownloadView) {
      await _databaseService.initialise();
      return await _databaseService.getPodcasts();
    } else {
      final res = await _dio.get('$baseUrl/podcasts');
      final List<dynamic> podcasts = res.data;
      final podcastList =
          podcasts.map((podcast) => Podcasts.fromAPIJson(podcast)).toList();
      final fccPodcasts = podcastList
          .where((podcast) => fccPodcastUrls.contains(podcast.url))
          .toList();
      final otherPodcasts = podcastList
          .where((podcast) => !fccPodcastUrls.contains(podcast.url))
          .toList();
      return [...fccPodcasts, ...otherPodcasts];
    }
  }
}
