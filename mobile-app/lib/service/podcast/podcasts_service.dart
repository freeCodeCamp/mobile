import 'dart:developer';
import 'dart:io';

import 'package:freecodecamp/models/podcasts/episodes_model.dart';
import 'package:freecodecamp/models/podcasts/podcasts_model.dart';
import 'package:freecodecamp/service/podcast/legacy/podcasts_sqlite_migrator.dart';
import 'package:freecodecamp/service/storage/json_file_store.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class PodcastsDatabaseService {
  PodcastsDatabaseService({Directory? storageDirectoryOverride})
      : _storageDirectoryOverride = storageDirectoryOverride;

  final Directory? _storageDirectoryOverride;
  final _legacyMigrator = const PodcastsSqliteMigrator();

  JsonFileStore? _store;
  Future<void>? _initFuture;

  Future<void> initialise() {
    _initFuture ??= _initialiseInternal();
    return _initFuture!;
  }

  Future<void> _initialiseInternal() async {
    final baseDir =
        _storageDirectoryOverride ?? await getApplicationDocumentsDirectory();

    final file = File(
      path.join(baseDir.path, 'storage', 'podcast-downloads.json'),
    );
    final store = JsonFileStore(
      file: file,
      defaultValue: {
        'version': 1,
        'migratedFromSqlite': false,
        'podcasts': [],
      },
    );
    await store.ensureExists();
    _store = store;

    await _migrateFromSqliteIfNeeded();
  }

  Future<void> _migrateFromSqliteIfNeeded() async {
    final store = _store;
    if (store == null) return;

    await store.updateAndWrite((current) async {
      final migrated = current['migratedFromSqlite'] == true;
      if (migrated) return current;

      final existingPodcasts = current['podcasts'] ?? [];
      // If JSON already has data, don't overwrite it.
      if (existingPodcasts.isNotEmpty) {
        return {
          ...current,
          'migratedFromSqlite': true,
        };
      }

      final legacy = await _legacyMigrator.readPodcastsAndEpisodes();
      if (legacy.podcasts.isEmpty && legacy.episodes.isEmpty) {
        return {
          ...current,
          'migratedFromSqlite': true,
        };
      }

      // Normalize legacy rows to match Podcasts/Episodes.fromDBJson.
      final podcasts = legacy.podcasts.map((p) {
        return {
          'id': p['id'],
          'url': p['url'],
          'link': p['link'],
          'title': p['title'],
          'description': p['description'],
          'image': p['image'],
          'copyright': p['copyright'],
          'numEps': p['numEps'],
          'episodes': [],
        };
      }).toList();

      final episodes = legacy.episodes.map((e) {
        return {
          'id': e['id'],
          'podcastId': e['podcastId'],
          'title': e['title'],
          'description': e['description'],
          'publicationDate': e['publicationDate'],
          'contentUrl': e['contentUrl'],
          'duration': e['duration'],
        };
      }).toList();

      final episodesByPodcastId = <String, List<Map<String, dynamic>>>{};
      for (final e in episodes) {
        final podcastId = e['podcastId'];
        if (podcastId.isEmpty) continue;
        (episodesByPodcastId[podcastId] ??= []).add(e);
      }

      for (final p in podcasts) {
        final id = p['id'];
        p['episodes'] = episodesByPodcastId[id] ?? [];
      }

      log(
        'Migrated ${podcasts.length} podcasts and ${episodes.length} episodes from SQLite to JSON (embedded)',
      );
      return {
        ...current,
        'version': 1,
        'migratedFromSqlite': true,
        'podcasts': podcasts,
      };
    });
  }

  Map<String, dynamic>? _findPodcastEntry(JsonMap data, String podcastId) {
    final podcasts = data['podcasts'];
    for (final p in podcasts) {
      if (p['id'] == podcastId) return p;
    }
    return null;
  }

  // PODCAST QUERIES
  Future<List<Podcasts>> getPodcasts() async {
    await initialise();
    final data = await _store!.read();
    final podcasts = data['podcasts'];
    return podcasts.map((podcast) {
      final withoutEpisodes = Map<String, dynamic>.from(podcast)
        ..remove('episodes');
      return Podcasts.fromDBJson(withoutEpisodes);
    }).toList();
  }

  Future addPodcast(Podcasts podcast) async {
    await initialise();
    await _store!.updateAndWrite((current) async {
      final list = current['podcasts'];

      final existingIndex = list.indexWhere((e) => e['id'] == podcast.id);
      final existingEpisodes =
          existingIndex == -1 ? [] : list[existingIndex]['episodes'];

      if (existingIndex != -1) {
        list.removeAt(existingIndex);
      }
      list.add({
        ...podcast.toJson(),
        'episodes': existingEpisodes,
      });
      log('Added Podcast: ${podcast.title}');
      return {
        ...current,
        'podcasts': list,
      };
    });
  }

  Future removePodcast(Podcasts podcast) async {
    await initialise();
    await _store!.updateAndWrite((current) async {
      final list = current['podcasts'];
      final index = list.indexWhere((p) => p['id'] == podcast.id);
      if (index == -1) return current;

      final episodes = list[index]['episodes'];
      final episodeCount = episodes.length;

      if (episodeCount > 0) {
        log('Did not remove podcast: ${podcast.title} because it has $episodeCount episodes');
        return current;
      }

      list.removeAt(index);
      log('Removed Podcast: ${podcast.title}');
      return {
        ...current,
        'podcasts': list,
      };
    });
  }

  // EPISODE QUERIES
  Future<List<Episodes>> getEpisodes(Podcasts podcast) async {
    await initialise();
    final data = await _store!.read();
    final entry = _findPodcastEntry(data, podcast.id);
    if (entry == null) return [];
    final rawEpisodes = entry['episodes'];
    return rawEpisodes
        .map((e) => Episodes.fromDBJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future addEpisode(Episodes episode) async {
    await initialise();
    await _store!.updateAndWrite((current) async {
      final list = current['podcasts'];
      var index = list.indexWhere((p) => p['id'] == episode.podcastId);

      final episodes = list[index]['episodes'];
      episodes.removeWhere((e) => e['id'] == episode.id);
      episodes.add(episode.toJson());
      list[index] = {
        ...list[index],
        'episodes': episodes,
      };
      log('Added Episode: ${episode.title}');
      return {
        ...current,
        'podcasts': list,
      };
    });
  }

  Future removeEpisode(Episodes episode) async {
    await initialise();
    await _store!.updateAndWrite((current) async {
      final list = current['podcasts'];
      final index = list.indexWhere((p) => p['id'] == episode.podcastId);
      if (index == -1) return current;

      final episodes = list[index]['episodes'];
      episodes.removeWhere((e) => e['id'] == episode.id);
      list[index] = {
        ...list[index],
        'episodes': episodes,
      };
      log('Removed Episode: ${episode.title}');
      return {
        ...current,
        'podcasts': list,
      };
    });
  }

  Future<bool> episodeExists(Episodes episode) async {
    await initialise();
    final data = await _store!.read();
    final entry = _findPodcastEntry(data, episode.podcastId);
    if (entry == null) return false;
    final List episodes = entry['episodes'];
    return episodes.any((e) => e['id'] == episode.id);
  }
}
