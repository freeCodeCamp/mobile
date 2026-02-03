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

  JsonFileStore<
      ({
        int version,
        bool migratedFromSqlite,
        List<({Podcasts podcast, List<Episodes> episodes})> podcasts,
      })>? _store;
  Future<void>? _initFuture;

  static const int _storeVersion = 1;

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
    final store = JsonFileStore<
        ({
          int version,
          bool migratedFromSqlite,
          List<({Podcasts podcast, List<Episodes> episodes})> podcasts,
        })>(
      file: file,
      defaultValue: (
        version: _storeVersion,
        migratedFromSqlite: false,
        podcasts: <({Podcasts podcast, List<Episodes> episodes})>[],
      ),
      fromJson: _fromStoreJson,
      toJson: _toStoreJson,
    );
    await store.ensureExists();
    _store = store;

    await _migrateFromSqliteIfNeeded();
  }

  Future<void> _migrateFromSqliteIfNeeded() async {
    final store = _store;
    if (store == null) return;

    await store.updateAndWrite((current) async {
      if (current.migratedFromSqlite) return current;

      // If JSON already has data, don't overwrite it.
      if (current.podcasts.isNotEmpty) {
        return (
          version: current.version,
          migratedFromSqlite: true,
          podcasts: current.podcasts,
        );
      }

      final legacy = await _legacyMigrator.readPodcastsAndEpisodes();
      if (legacy.podcasts.isEmpty && legacy.episodes.isEmpty) {
        return (
          version: current.version,
          migratedFromSqlite: true,
          podcasts: current.podcasts,
        );
      }

      // Normalize legacy rows to match Podcasts/Episodes.fromDBJson.
      final legacyPodcasts = legacy.podcasts.map((p) {
        return Podcasts.fromDBJson({
          'id': p['id'],
          'url': p['url'],
          'link': p['link'],
          'title': p['title'],
          'description': p['description'],
          'image': p['image'],
          'copyright': p['copyright'],
          'numEps': p['numEps'],
        });
      }).toList();

      final legacyEpisodes = legacy.episodes.map((e) {
        return Episodes.fromDBJson({
          'id': e['id'],
          'podcastId': e['podcastId'],
          'title': e['title'],
          'description': e['description'],
          'publicationDate': e['publicationDate'],
          'contentUrl': e['contentUrl'],
          'duration': e['duration'],
        });
      }).toList();

      final episodesByPodcastId = <String, List<Episodes>>{};
      for (final e in legacyEpisodes) {
        if (e.podcastId.isEmpty) continue;
        (episodesByPodcastId[e.podcastId] ??= []).add(e);
      }

      final records = legacyPodcasts.map((p) {
        return (
          podcast: p,
          episodes: episodesByPodcastId[p.id] ?? <Episodes>[],
        );
      }).toList();

      log(
        'Migrated ${legacyPodcasts.length} podcasts and ${legacyEpisodes.length} episodes from SQLite to JSON (embedded)',
      );
      return (
        version: _storeVersion,
        migratedFromSqlite: true,
        podcasts: records,
      );
    });
  }

  static ({
    int version,
    bool migratedFromSqlite,
    List<({Podcasts podcast, List<Episodes> episodes})> podcasts,
  }) _fromStoreJson(JsonMap json) {
    final version = json['version'];
    final migratedFromSqlite = json['migratedFromSqlite'] == true;

    final List<({Podcasts podcast, List<Episodes> episodes})> podcasts = [];

    final rawPodcasts = json['podcasts'];
    if (rawPodcasts is List) {
      for (final entry in rawPodcasts) {
        if (entry is! Map) continue;
        final podcastJson = Map<String, dynamic>.from(entry);
        final rawEpisodes = podcastJson.remove('episodes');

        final podcast = Podcasts.fromDBJson(podcastJson);
        final List<Episodes> episodes = [];
        if (rawEpisodes is List) {
          for (final e in rawEpisodes) {
            if (e is Map) {
              episodes.add(Episodes.fromDBJson(Map.from(e)));
            }
          }
        }

        podcasts.add((podcast: podcast, episodes: episodes));
      }
    }

    return (
      version: version,
      migratedFromSqlite: migratedFromSqlite,
      podcasts: podcasts,
    );
  }

  static JsonMap _toStoreJson(
    ({
      int version,
      bool migratedFromSqlite,
      List<({Podcasts podcast, List<Episodes> episodes})> podcasts,
    }) value,
  ) {
    return {
      'version': value.version,
      'migratedFromSqlite': value.migratedFromSqlite,
      'podcasts': value.podcasts.map((p) {
        return {
          ...p.podcast.toJson(),
          'episodes': p.episodes.map((e) => e.toJson()).toList(),
        };
      }).toList(),
    };
  }

  int _indexOfPodcast(
    List<({Podcasts podcast, List<Episodes> episodes})> list,
    String podcastId,
  ) {
    return list.indexWhere((p) => p.podcast.id == podcastId);
  }

  // PODCAST QUERIES
  Future<List<Podcasts>> getPodcasts() async {
    await initialise();
    final data = await _store!.read();
    return data.podcasts.map((p) => p.podcast).toList();
  }

  Future addPodcast(Podcasts podcast) async {
    await initialise();
    await _store!.updateAndWrite((current) async {
      final list = List<({Podcasts podcast, List<Episodes> episodes})>.from(
        current.podcasts,
      );

      final existingIndex = _indexOfPodcast(list, podcast.id);
      final List<Episodes> existingEpisodes =
          existingIndex == -1 ? [] : list[existingIndex].episodes;

      if (existingIndex != -1) {
        list.removeAt(existingIndex);
      }

      list.add((podcast: podcast, episodes: existingEpisodes));
      log('Added Podcast: ${podcast.title}');
      return (
        version: current.version,
        migratedFromSqlite: current.migratedFromSqlite,
        podcasts: list,
      );
    });
  }

  Future removePodcast(Podcasts podcast) async {
    await initialise();
    await _store!.updateAndWrite((current) async {
      final list = List<({Podcasts podcast, List<Episodes> episodes})>.from(
        current.podcasts,
      );

      final index = _indexOfPodcast(list, podcast.id);
      if (index == -1) return current;

      final episodeCount = list[index].episodes.length;

      if (episodeCount > 0) {
        log('Did not remove podcast: ${podcast.title} because it has $episodeCount episodes');
        return current;
      }

      list.removeAt(index);
      log('Removed Podcast: ${podcast.title}');
      return (
        version: current.version,
        migratedFromSqlite: current.migratedFromSqlite,
        podcasts: list,
      );
    });
  }

  // EPISODE QUERIES
  Future<List<Episodes>> getEpisodes(Podcasts podcast) async {
    await initialise();
    final data = await _store!.read();
    final index = _indexOfPodcast(data.podcasts, podcast.id);
    if (index == -1) return <Episodes>[];
    return List<Episodes>.from(data.podcasts[index].episodes);
  }

  Future addEpisode(Episodes episode) async {
    await initialise();
    await _store!.updateAndWrite((current) async {
      final list = List<({Podcasts podcast, List<Episodes> episodes})>.from(
        current.podcasts,
      );

      final index = _indexOfPodcast(list, episode.podcastId);
      if (index == -1) {
        log('Did not add episode: missing podcast ${episode.podcastId}');
        return current;
      }

      final episodes = List<Episodes>.from(list[index].episodes);
      episodes.removeWhere((e) => e.id == episode.id);
      episodes.add(episode);

      list[index] = (
        podcast: list[index].podcast,
        episodes: episodes,
      );
      log('Added Episode: ${episode.title}');
      return (
        version: current.version,
        migratedFromSqlite: current.migratedFromSqlite,
        podcasts: list,
      );
    });
  }

  Future removeEpisode(Episodes episode) async {
    await initialise();
    await _store!.updateAndWrite((current) async {
      final list = List<({Podcasts podcast, List<Episodes> episodes})>.from(
        current.podcasts,
      );

      final index = _indexOfPodcast(list, episode.podcastId);
      if (index == -1) return current;

      final episodes = List<Episodes>.from(list[index].episodes);
      episodes.removeWhere((e) => e.id == episode.id);
      list[index] = (
        podcast: list[index].podcast,
        episodes: episodes,
      );
      log('Removed Episode: ${episode.title}');
      return (
        version: current.version,
        migratedFromSqlite: current.migratedFromSqlite,
        podcasts: list,
      );
    });
  }

  Future<bool> episodeExists(Episodes episode) async {
    await initialise();
    final data = await _store!.read();
    final index = _indexOfPodcast(data.podcasts, episode.podcastId);
    if (index == -1) return false;
    return data.podcasts[index].episodes.any((e) => e.id == episode.id);
  }
}
