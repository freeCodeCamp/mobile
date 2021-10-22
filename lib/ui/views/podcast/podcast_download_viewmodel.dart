import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/models/downloaded_episodes.dart';
import 'package:freecodecamp/service/episodes_service.dart';
import 'package:stacked/stacked.dart';

import 'dart:developer';

// Business logic and view state

class PodcastDownloadViewModel extends BaseViewModel {
  final _databaseService = locator<EpisodeDatabaseService>();
  late List<DownloadedEpisodes> epsDownloaded;

  Future<List<DownloadedEpisodes>> fetchPodcastEpisodes() async {
    await _databaseService.initialise();
    epsDownloaded = await _databaseService.getDownloadedEpisodes();
    log('Number of downloaded episodes: ${epsDownloaded.length}');
    return epsDownloaded;
  }
}
