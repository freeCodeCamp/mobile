import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/models/podcasts/episodes_model.dart';
import 'package:freecodecamp/models/podcasts/podcasts_model.dart';
import 'package:freecodecamp/service/podcasts_service.dart';
import 'package:stacked/stacked.dart';
import 'dart:developer';

class EpisodeListViewModel extends BaseViewModel {
  final _databaseService = locator<PodcastsDatabaseService>();
  final Podcasts podcast;
  late List<Episodes> episodes;
  late int epsLength = 0;

  EpisodeListViewModel(this.podcast);

  Future<List<Episodes>> fetchPodcastEpisodes(bool isDownloadView) async {
    await _databaseService.initialise();
    int temp = epsLength;
    if (isDownloadView) {
      episodes = await _databaseService.getDownloadedEpisodes(podcast.id);
    } else {
      episodes = await _databaseService.getEpisodes(podcast.id);
    }
    epsLength = episodes.length;
    // TODO: notifyListeners rebuilds view leading to above db functions being 
    // called twice. Check if it can be prevented
    if (temp != epsLength) {
      notifyListeners();
    }
    return episodes;
  }
}
