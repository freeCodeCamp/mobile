import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'progress_repository.g.dart';

@riverpod
PodcastProgressRepository podcastProgressRepository(Ref ref) =>
    PodcastProgressRepository();

class PodcastProgressRepository {
  static String _positionKey(String episodeId) => '${episodeId}_progress';

  static const _recentKey = 'podcast_recent_episodes';

  SharedPreferences? _prefs;

  Future<SharedPreferences> _instance() async =>
      _prefs ??= await SharedPreferences.getInstance();

  Future<int?> readPosition(String episodeId) async =>
      (await _instance()).getInt(_positionKey(episodeId));

  Future<void> writePosition(String episodeId, int seconds) async =>
      (await _instance()).setInt(_positionKey(episodeId), seconds);

  Future<void> clearPositions(Iterable<String> episodeIds) async {
    final prefs = await _instance();
    for (final id in episodeIds) {
      await prefs.remove(_positionKey(id));
    }
  }

  Future<List<String>> readRecentEpisodeIds() async =>
      (await _instance()).getStringList(_recentKey) ?? const [];

  Future<void> writeRecentEpisodeIds(List<String> ids) async =>
      (await _instance()).setStringList(_recentKey, ids);
}
