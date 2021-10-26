import 'dart:convert';

import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/models/podcasts/podcasts_model.dart';
import 'package:freecodecamp/service/podcasts_service.dart';
import 'package:freecodecamp/ui/views/podcast/podcast_urls.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stacked/stacked.dart';
import 'package:podcast_search/podcast_search.dart';
import 'dart:developer';
import 'dart:io';
import 'package:uuid/uuid.dart';

// Business logic and view state

class PodcastListViewModel extends BaseViewModel {
  final _databaseService = locator<PodcastsDatabaseService>();
  var uuid = Uuid();
  late List<Podcasts> podcasts;
  late Directory appDir;

  Future<List<Podcasts>> fetchPodcasts() async {
    // Make this faster by checking if podcasts are present in db or not instead
    // of fetching everytime and saving to db
    await _databaseService.initialise();
    appDir = await getApplicationDocumentsDirectory();
    File podcastIdsListFile = File('${appDir.path}/podcastUrls.json');
    if (!podcastIdsListFile.existsSync()) {
      log("Created json file");
      podcastIdsListFile.createSync(recursive: true);
    }
    String response = podcastIdsListFile.readAsStringSync();
    if (response.isEmpty) {
      response = '{}';
    }
    Map<String, dynamic> podcastIdsList = await json.decode(response);
    log(podcastIdsList.toString());
    for (var podcastUrl in podcastUrls) {
      log('Fetching $podcastUrl');
      try {
        Podcast podcast = await Podcast.loadFeed(url: podcastUrl);
        String podcastId;
        if (!podcastIdsList.containsKey(podcastUrl)) {
          podcastId = uuid.v4();
          podcastIdsList[podcastUrl] = podcastId;
        } else {
          podcastId = podcastIdsList[podcastUrl];
        }
        await _databaseService.addPodcast(podcast, podcastId);
        log("""Podcast added {
          id: $podcastId
          url: ${podcast.url} ${podcast.url == podcastUrl}
          link: ${podcast.link}
          title: ${podcast.title}
          description: ${podcast.description!.substring(0, 100)}
          image: ${podcast.image}
          copyright: ${podcast.copyright}
          episodes length: ${podcast.episodes!.length}
        }""");
      } catch (e) {
        log("Network issues $e");
      }
    }
    podcastIdsListFile.writeAsStringSync(json.encode(podcastIdsList));

    return await _databaseService.getAllPodcasts();
  }
}
