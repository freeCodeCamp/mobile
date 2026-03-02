import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecodecamp/core/providers/service_providers.dart';
import 'package:freecodecamp/models/podcasts/podcasts_model.dart';
import 'package:freecodecamp/service/developer_service.dart';
import 'package:freecodecamp/service/dio_service.dart';
import 'package:freecodecamp/service/podcast/podcasts_service.dart';
import 'package:path_provider/path_provider.dart';

const fccPodcastUrls = [
  // English
  'https://freecodecamp.libsyn.com/rss',
  // Spanish
  'https://anchor.fm/s/ff0092f4/podcast/rss',
  // Chinese
  'https://anchor.fm/s/ff054de4/podcast/rss',
  // Portuguese
  'https://anchor.fm/s/ff026c00/podcast/rss',
];

class PodcastListState {
  const PodcastListState({this.index = 0});

  final int index;

  PodcastListState copyWith({int? index}) {
    return PodcastListState(index: index ?? this.index);
  }
}

class PodcastListNotifier extends Notifier<PodcastListState> {
  late PodcastsDatabaseService _databaseService;
  late DeveloperService _developerService;
  static late Directory appDir;
  final _dio = DioService.dio;

  @override
  PodcastListState build() {
    _databaseService = ref.watch(podcastsDatabaseServiceProvider);
    _developerService = ref.watch(developerServiceProvider);
    return const PodcastListState();
  }

  void setIndex(int i) {
    state = state.copyWith(index: i);
  }

  Future<void> init() async {
    appDir = await getApplicationDocumentsDirectory();
  }

  Future<List<Podcasts>> fetchPodcasts(bool isDownloadView) async {
    String baseUrl = (await _developerService.developmentMode())
        ? 'https://api.mobile.freecodecamp.dev'
        : 'https://api.mobile.freecodecamp.org';
    if (isDownloadView) {
      await _databaseService.initialise();
      return await _databaseService.getPodcasts();
    } else {
      final res = await _dio.get('$baseUrl/podcasts');
      final List<dynamic> podcasts = res.data;
      final podcastList =
          podcasts.map((podcast) => Podcasts.fromAPIJson(podcast)).toList();
      final fccPodcasts = podcastList
          .where((podcast) => fccPodcastUrls.contains(podcast.url))
          .toList();
      final otherPodcasts = podcastList
          .where((podcast) => !fccPodcastUrls.contains(podcast.url))
          .toList();
      return [...fccPodcasts, ...otherPodcasts];
    }
  }
}

final podcastListProvider =
    NotifierProvider<PodcastListNotifier, PodcastListState>(
  PodcastListNotifier.new,
);
