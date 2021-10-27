import 'dart:developer';

import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/models/podcasts/episodes_model.dart';
import 'package:freecodecamp/service/podcasts_service.dart';
import 'package:stacked/stacked.dart';

// Business logic and view state

class PodcastDownloadViewModel extends BaseViewModel {
  final _databaseService = locator<PodcastsDatabaseService>();
  late List<Episodes> epsDownloaded;

  Future<List<Episodes>> fetchPodcastEpisodes() async {
    await _databaseService.initialise();
    epsDownloaded = await _databaseService.getDownloadedEpisodes();
    log('Number of downloaded episodes: ${epsDownloaded.length}');
    return epsDownloaded;
  }
}
