import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/models/podcasts/episodes_model.dart';
import 'package:freecodecamp/service/episodes_service.dart';
import 'package:stacked/stacked.dart';

import 'dart:developer';

// Business logic and view state

class PodcastDownloadViewModel extends BaseViewModel {
  final _databaseService = locator<EpisodesDatabaseService>();
  late List<Episodes> epsDownloaded;

  Future<List<Episodes>> fetchPodcastEpisodes() async {
    await _databaseService.initialise();
    epsDownloaded = await _databaseService.getEpisodes();
    log('Number of downloaded episodes: ${epsDownloaded.length}');
    return epsDownloaded;
  }
}
