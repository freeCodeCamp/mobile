import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/models/podcasts/podcasts_model.dart';
import 'package:freecodecamp/service/podcasts_service.dart';
import 'package:freecodecamp/ui/views/podcast/podcast_urls.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:stacked/stacked.dart';
import 'package:uuid/uuid.dart';

// Business logic and view state

class PodcastListViewModel extends BaseViewModel {
  final _databaseService = locator<PodcastsDatabaseService>();
  // ignore: prefer_const_constructors
  var uuid = Uuid();
  late List<Podcasts> podcasts;
  late Directory appDir;
  int _index = 0;

  int get index => _index;

  void setIndex(i) {
    _index = i;
    notifyListeners();
  }

  Future<List<Podcasts>> fetchPodcasts(bool isDownloadView) async {
    // Make this faster by checking if podcasts are present in db or not instead
    // of fetching everytime and saving to db
    await _databaseService.initialise();
    if (isDownloadView) {
      return await _databaseService.getDownloadedPodcasts();
    } else {
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
          for (int i = 0; i < podcast.episodes!.length; i++) {
            if (podcast.episodes![i].contentUrl != null) {
              await _databaseService.addEpisode(podcast.episodes![i], podcastId);
            }
          }
          log('Downloading podcast image');
          File podcastImgFile =
              File('${appDir.path}/images/podcast/$podcastId.jpg');
          if (!podcastImgFile.existsSync()) {
            podcastImgFile.createSync(recursive: true);
          }
          var response = await http.get(Uri.parse(podcast.image!));
          podcastImgFile.writeAsBytesSync(response.bodyBytes);
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
}
