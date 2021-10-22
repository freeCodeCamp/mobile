import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/models/downloaded_episodes.dart';
import 'package:freecodecamp/service/episodes_service.dart';
import 'package:stacked/stacked.dart';
import 'package:podcast_search/podcast_search.dart';
import 'dart:developer';

// Business logic and view state

class PodcastViewModel extends BaseViewModel {
  final _databaseService = locator<EpisodeDatabaseService>();
  late List<DownloadedEpisodes> epsStored;

  Future<List<DownloadedEpisodes>> fetchPodcastEpisodes() async {
    await _databaseService.initialise();
    epsStored = await _databaseService.getAllEpisodes();
    int epsStoredLen = epsStored.length;
    const podcastURL = 'https://freecodecamp.libsyn.com/rss';

    try {
      Podcast podcast = await Podcast.loadFeed(url: podcastURL);
      log("Fetched podcast episodes: ${podcast.episodes?.length}");
      int epsFetchedLen = podcast.episodes!.length;
      if (epsFetchedLen > epsStoredLen) {
        for (int i = 0; i < epsFetchedLen; i++) {
          _databaseService.addEpisode(podcast.episodes?[i]);
        }
        epsStored = await _databaseService.getAllEpisodes();
      }
    } catch (e) {
      log("Network issues $e");
    }
    return epsStored;
  }
}
