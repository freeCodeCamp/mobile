import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mobile_app_new/services/dio_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'api_repository.g.dart';

typedef RawEpisodesPage = ({
  Map<String, dynamic> podcast,
  List<Map<String, dynamic>> episodes,
});

const _prodUrl = 'https://api.mobile.freecodecamp.org';
const _devUrl = 'https://api.mobile.freecodecamp.dev';

@riverpod
PodcastApiRepository podcastApiRepository(Ref ref) => PodcastApiRepository();

class PodcastApiRepository {
  final Dio _dio = DioService.dio;

  String get _baseUrl =>
      dotenv.getBool('DEVELOPMENT_MODE', fallback: false) ? _devUrl : _prodUrl;

  Future<List<Map<String, dynamic>>> getPodcasts() async {
    final response = await _dio.get<List<dynamic>>('$_baseUrl/podcasts');

    return [
      for (final entry in response.data ?? const [])
        if (entry is Map) Map<String, dynamic>.from(entry),
    ];
  }

  Future<RawEpisodesPage> getEpisodes(String podcastId, {int page = 0}) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '$_baseUrl/podcasts/$podcastId/episodes',
      queryParameters: {'page': page},
    );

    final data = response.data ?? const <String, dynamic>{};
    final podcast = data['podcast'];
    final episodes = data['episodes'];

    return (
      podcast: podcast is Map
          ? Map<String, dynamic>.from(podcast)
          : <String, dynamic>{},
      episodes: [
        for (final entry in episodes is List ? episodes : const [])
          if (entry is Map) Map<String, dynamic>.from(entry),
      ],
    );
  }
}
