import 'dart:convert';

import 'dart:io';

import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/models/podcasts/podcasts_model.dart';
import 'package:freecodecamp/service/podcasts_service.dart';
import 'package:freecodecamp/service/test_service.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:stacked/stacked.dart';

class PodcastListViewModel extends BaseViewModel {
  final _databaseService = locator<PodcastsDatabaseService>();
  final _testservice = locator<TestService>();
  static late Directory appDir;
  int _index = 0;

  int get index => _index;

  void setIndex(i) {
    _index = i;
    notifyListeners();
  }

  Future<void> init() async {
    appDir = await getApplicationDocumentsDirectory();
  }

  Future<List<Podcasts>> fetchPodcasts(bool isDownloadView) async {
    String baseUrl = (await _testservice.developmentMode())
        ? 'http://10.0.2.2:3000/'
        : 'https://api.mobile.freecodecamp.dev/';
    await _databaseService.initialise();
    if (isDownloadView) {
      return await _databaseService.getPodcasts();
    } else {
      final res = await http.get(Uri.parse(baseUrl + 'podcasts'));
      final List<dynamic> podcasts = json.decode(res.body);
      return podcasts.map((podcast) => Podcasts.fromAPIJson(podcast)).toList();
    }
  }
}
