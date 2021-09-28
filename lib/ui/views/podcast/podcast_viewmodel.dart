import 'package:stacked/stacked.dart';
import 'package:podcast_search/podcast_search.dart';
import 'dart:developer';

// Business logic and view state

class PodcastViewModel extends BaseViewModel {
  Future<List<Episode>> fetchPodcastEpisodes() async {
    const podcastURL = 'https://freecodecamp.libsyn.com/rss';
    // final podcastURL = 'https://themattwalshblog.com/category/podcast/feed';

    Podcast podcast = await Podcast.loadFeed(url: podcastURL);
    log("Podcast episodes: ${podcast.episodes?.length}");
    return podcast.episodes!;
  }
}
