import 'dart:convert';
import 'dart:developer';

import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/models/podcasts/episodes_model.dart';
import 'package:freecodecamp/models/podcasts/podcasts_model.dart';
import 'package:freecodecamp/service/podcasts_service.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:stacked/stacked.dart';

const baseUrl = "http://10.0.2.2:3000/";

class EpisodeListViewModel extends BaseViewModel {
  final _databaseService = locator<PodcastsDatabaseService>();
  final Podcasts podcast;
  int epsLength = 0;
  late Future<List<Episodes>> _episodes;
  Future<List<Episodes>> get episodes => _episodes;

  EpisodeListViewModel(this.podcast);

  void initState(bool isDownloadView) {
    _databaseService.initialise();
    if (isDownloadView) {
      // _episodes = _databaseService.getDownloadedEpisodes(podcast.id);
      _episodes = fetchEpisodes(podcast.id);
    } else {
      // episodes = await _databaseService.getEpisodes(podcast.id);
      _episodes = fetchEpisodes(podcast.id);
    }
    notifyListeners();
    // Parse html description
    // log("PARSED ${parse(podcast.description!).documentElement?.text}");
  }

  Future<List<Episodes>> fetchEpisodes(String podcastId) async {
    final res = await http
        .get(Uri.parse(baseUrl + "podcasts/" + podcastId + "/episodes"));
    final List<dynamic> episodes = json.decode(res.body)["episodes"];
    epsLength = episodes.length;
    notifyListeners();
    return episodes.map((episode) => Episodes.fromJson(episode)).toList();
  }
}
