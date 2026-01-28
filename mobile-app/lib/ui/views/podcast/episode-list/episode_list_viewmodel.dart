import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/models/podcasts/episodes_model.dart';
import 'package:freecodecamp/models/podcasts/podcasts_model.dart';
import 'package:freecodecamp/service/developer_service.dart';
import 'package:freecodecamp/service/dio_service.dart';
import 'package:freecodecamp/service/podcast/podcasts_service.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:stacked/stacked.dart';

class EpisodeListViewModel extends BaseViewModel {
  EpisodeListViewModel(this.podcast);

  final _databaseService = locator<PodcastsDatabaseService>();
  final _developerService = locator<DeveloperService>();
  final Podcasts podcast;
  int epsLength = 0;
  final _dio = DioService.dio;

  late Future<List<Episodes>> _episodes;
  Future<List<Episodes>> get episodes => _episodes;

  bool _showMoreDescription = false;
  bool get showDescription => _showMoreDescription;

  set setShowMoreDescription(bool state) {
    _showMoreDescription = state;
    notifyListeners();
  }

  PagingController<int, Episodes>? _pagingController;
  PagingController<int, Episodes>? get pagingController => _pagingController;

  void initState(bool isDownloadView) async {
    await _databaseService.initialise();
    if (isDownloadView) {
      _episodes = _databaseService.getEpisodes(podcast);
      epsLength = (await episodes).length;
    } else {
      _pagingController = PagingController(
        getNextPageKey: (state) => (state.keys?.last ?? -1) + 1,
        fetchPage: (pageKey) => fetchEpisodes(podcast.id, pageKey),
      );
    }
    notifyListeners();
  }

  Future<List<Episodes>> fetchEpisodes(String podcastId,
      [int pageKey = 0]) async {
    String baseUrl = (await _developerService.developmentMode())
        ? 'https://api.mobile.freecodecamp.dev/'
        : 'https://api.mobile.freecodecamp.org/';
    final res = await _dio.get(
      '${baseUrl}podcasts/$podcastId/episodes?page=$pageKey',
    );
    final List<dynamic> episodes = res.data['episodes'];
    epsLength = res.data['podcast']['numOfEps'];
    notifyListeners();
    final List<Episodes> eps =
        episodes.map((e) => Episodes.fromAPIJson(e)).toList();
    final prevCount = _pagingController?.items?.length ?? 0;
    if (prevCount + 20 >= epsLength) {
      _pagingController?.value = _pagingController!.value.copyWith(
        hasNextPage: false,
      );
    }
    return eps;
  }

  @override
  void dispose() {
    _pagingController?.dispose();
    super.dispose();
  }
}
