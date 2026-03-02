import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecodecamp/core/providers/service_providers.dart';
import 'package:freecodecamp/models/podcasts/episodes_model.dart';
import 'package:freecodecamp/models/podcasts/podcasts_model.dart';
import 'package:freecodecamp/service/developer_service.dart';
import 'package:freecodecamp/service/dio_service.dart';
import 'package:freecodecamp/service/podcast/podcasts_service.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class EpisodeListState {
  const EpisodeListState({
    this.showMoreDescription = false,
    this.epsLength = 0,
  });

  final bool showMoreDescription;
  final int epsLength;

  EpisodeListState copyWith({
    bool? showMoreDescription,
    int? epsLength,
  }) {
    return EpisodeListState(
      showMoreDescription: showMoreDescription ?? this.showMoreDescription,
      epsLength: epsLength ?? this.epsLength,
    );
  }
}

class EpisodeListNotifier extends FamilyNotifier<EpisodeListState, Podcasts> {
  late PodcastsDatabaseService _databaseService;
  late DeveloperService _developerService;
  final _dio = DioService.dio;

  late Future<List<Episodes>> _episodes;
  Future<List<Episodes>> get episodes => _episodes;

  PagingController<int, Episodes>? _pagingController;
  PagingController<int, Episodes>? get pagingController => _pagingController;

  @override
  EpisodeListState build(Podcasts podcast) {
    _databaseService = ref.watch(podcastsDatabaseServiceProvider);
    _developerService = ref.watch(developerServiceProvider);
    ref.onDispose(() {
      _pagingController?.dispose();
    });
    return const EpisodeListState();
  }

  void initState(bool isDownloadView) async {
    await _databaseService.initialise();
    if (isDownloadView) {
      _episodes = _databaseService.getEpisodes(arg);
      final length = (await _episodes).length;
      state = state.copyWith(epsLength: length);
    } else {
      _pagingController = PagingController(
        getNextPageKey: (s) => (s.keys?.last ?? -1) + 1,
        fetchPage: (pageKey) => fetchEpisodes(arg.id, pageKey),
      );
    }
    // notify consumers that pagingController is ready
    state = state.copyWith();
  }

  Future<List<Episodes>> fetchEpisodes(String podcastId,
      [int pageKey = 0]) async {
    String baseUrl = (await _developerService.developmentMode())
        ? 'https://api.mobile.freecodecamp.dev/'
        : 'https://api.mobile.freecodecamp.org/';
    final res = await _dio.get(
      '${baseUrl}podcasts/$podcastId/episodes?page=$pageKey',
    );
    final List<dynamic> episodesJson = res.data['episodes'];
    final epsLength = res.data['podcast']['numOfEps'] as int;
    state = state.copyWith(epsLength: epsLength);
    final List<Episodes> eps =
        episodesJson.map((e) => Episodes.fromAPIJson(e)).toList();
    final prevCount = _pagingController?.items?.length ?? 0;
    if (prevCount + 20 >= epsLength) {
      _pagingController?.value = _pagingController!.value.copyWith(
        hasNextPage: false,
      );
    }
    return eps;
  }

  void setShowMoreDescription(bool value) {
    state = state.copyWith(showMoreDescription: value);
  }
}

final episodeListProvider =
    NotifierProviderFamily<EpisodeListNotifier, EpisodeListState, Podcasts>(
  EpisodeListNotifier.new,
);
