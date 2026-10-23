import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'progress_repository.g.dart';

@riverpod
PodcastProgressRepository podcastProgressRepository(Ref ref) =>
    PodcastProgressRepository();

class PodcastProgressRepository {
  static String _positionKey(String episodeId) => '${episodeId}_progress';

  static const _recentKey = 'podcast_recent_episodes';

  Future<int?> readPosition(String episodeId) async =>
      (await SharedPreferences.getInstance()).getInt(_positionKey(episodeId));

  Future<void> writePosition(String episodeId, int seconds) async =>
      (await SharedPreferences.getInstance()).setInt(
        _positionKey(episodeId),
        seconds,
      );

  Future<void> clearPositions(Iterable<String> episodeIds) async {
    final prefs = await SharedPreferences.getInstance();
    for (final id in episodeIds) {
      await prefs.remove(_positionKey(id));
    }
  }

  Future<List<String>> readRecentEpisodeIds() async =>
      (await SharedPreferences.getInstance()).getStringList(_recentKey) ??
      const [];

  Future<void> writeRecentEpisodeIds(List<String> ids) async =>
      (await SharedPreferences.getInstance()).setStringList(_recentKey, ids);
}
