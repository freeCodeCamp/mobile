import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'storage_repository.g.dart';

typedef PodcastStoreEntry = Map<String, dynamic>;

typedef StoredPodcast = ({
  PodcastStoreEntry podcast,
  List<PodcastStoreEntry> episodes,
});

// `readable` is false when the file is absent or could not be parsed. The
// orphan sweep must not treat either as "no downloads"
typedef PodcastStoreSnapshot = ({List<StoredPodcast> podcasts, bool readable});

typedef PodcastStoreIds = ({
  Map<String, Set<String>> episodeIdsByPodcastId,
  bool readable,
});

const _fileName = 'podcast-downloads.json';

// Past versions
// 1 - <v8 - v7's own key names, which were not the same as the API
// 2 - v8+ - the API's key names
const _storeVersion = 2;

// Applied only to v1 file. Anything absent here already matches.
const _legacyPodcastKeys = <String, String>{
  'id': '_id',
  'url': 'feedUrl',
  'link': 'podcastLink',
  'image': 'imageLink',
  'numEps': 'numOfEps',
};

const _legacyEpisodeKeys = <String, String>{
  'id': '_id',
  'contentUrl': 'audioUrl',
};

const _episodesKey = 'episodes';
const _idKey = '_id';

@riverpod
PodcastStorageRepository podcastStorageRepository(Ref ref) =>
    PodcastStorageRepository();

class PodcastStorageRepository {
  File? _file;

  Future<File> _resolveFile() async {
    final baseDir = await getApplicationDocumentsDirectory();
    return _file ??= File(path.join(baseDir.path, 'storage', _fileName));
  }

  Future<PodcastStoreSnapshot> readPodcasts() => _serialized(_read);

  Future<PodcastStoreIds> readIds() => _serialized(_readIds);

  Future<bool> containsEpisode({
    required String podcastId,
    required String episodeId,
  }) {
    return _serialized(() async {
      for (final row in (await _read()).podcasts) {
        if (row.podcast[_idKey] != podcastId) continue;

        return row.episodes.any((raw) => raw[_idKey] == episodeId);
      }

      return false;
    });
  }

  Future<void> upsertEpisode({
    required PodcastStoreEntry podcast,
    required PodcastStoreEntry episode,
  }) {
    final podcastId = podcast[_idKey];
    final episodeId = episode[_idKey];

    return _mutate((podcasts) {
      final index = podcasts.indexWhere(
        (row) => row.podcast[_idKey] == podcastId,
      );

      final episodes = index == -1
          ? <PodcastStoreEntry>[]
          : List<PodcastStoreEntry>.from(podcasts[index].episodes);

      episodes
        ..removeWhere((raw) => raw[_idKey] == episodeId)
        ..add(episode);

      final row = (podcast: podcast, episodes: episodes);

      if (index == -1) {
        podcasts.add(row);
      } else {
        podcasts[index] = row;
      }
    });
  }

  // NOTE: Returns whether that was the podcast's last episode
  Future<bool> removeEpisode({
    required String podcastId,
    required String episodeId,
  }) {
    return _mutate((podcasts) {
      final index = podcasts.indexWhere(
        (row) => row.podcast[_idKey] == podcastId,
      );
      if (index == -1) return false;

      final episodes = List<PodcastStoreEntry>.from(podcasts[index].episodes)
        ..removeWhere((raw) => raw[_idKey] == episodeId);

      if (episodes.isEmpty) {
        podcasts.removeAt(index);
        return true;
      }

      podcasts[index] = (podcast: podcasts[index].podcast, episodes: episodes);
      return false;
    });
  }

  Future<PodcastStoreSnapshot> _read() async {
    final entries = await _decode();
    if (entries == null) {
      return (podcasts: const <StoredPodcast>[], readable: false);
    }

    return (
      podcasts: [for (final entry in entries) _split(entry)],
      readable: true,
    );
  }

  Future<List<PodcastStoreEntry>?> _decode() async {
    final file = await _resolveFile();
    if (!await file.exists()) return null;

    try {
      final decoded = jsonDecode(await file.readAsString());
      if (decoded is Map && decoded['podcasts'] is List) {
        final isLegacy = decoded['version'] != _storeVersion;

        return [
          for (final entry in decoded['podcasts'] as List)
            if (entry is Map)
              isLegacy
                  ? _upgradeToV2(PodcastStoreEntry.from(entry))
                  : PodcastStoreEntry.from(entry),
        ];
      }
      log('Podcast downloads: unexpected shape in ${file.path}');
    } catch (e) {
      log('Podcast downloads: cannot read ${file.path} ($e)');
    }

    return null;
  }

  Future<PodcastStoreIds> _readIds() async {
    const empty = <String, Set<String>>{};

    final snapshot = await _read();
    if (!snapshot.readable) {
      return (episodeIdsByPodcastId: empty, readable: false);
    }

    final ids = <String, Set<String>>{};

    for (final row in snapshot.podcasts) {
      final podcastId = row.podcast[_idKey];
      if (podcastId is! String || podcastId.isEmpty) {
        log('Podcast downloads: row without an id');
        return (episodeIdsByPodcastId: empty, readable: false);
      }

      final episodeIds = <String>{};

      for (final raw in row.episodes) {
        final episodeId = raw[_idKey];
        if (episodeId is! String || episodeId.isEmpty) {
          log('Podcast downloads: episode without an id');
          return (episodeIdsByPodcastId: empty, readable: false);
        }

        episodeIds.add(episodeId);
      }

      ids[podcastId] = episodeIds;
    }

    return (episodeIdsByPodcastId: ids, readable: true);
  }

  StoredPodcast _split(PodcastStoreEntry entry) {
    final episodes = entry[_episodesKey];

    return (
      podcast: {...entry}..remove(_episodesKey),
      episodes: [
        for (final raw in episodes is List ? episodes : const [])
          if (raw is Map) PodcastStoreEntry.from(raw),
      ],
    );
  }

  PodcastStoreEntry _join(StoredPodcast row) => {
    ...row.podcast,
    _episodesKey: row.episodes,
  };

  PodcastStoreEntry _upgradeToV2(PodcastStoreEntry entry) {
    final episodes = entry[_episodesKey];

    return {
      ..._renameKeys(entry, _legacyPodcastKeys),
      if (episodes is List)
        _episodesKey: [
          for (final raw in episodes)
            if (raw is Map)
              _renameKeys(PodcastStoreEntry.from(raw), _legacyEpisodeKeys),
        ],
    };
  }

  PodcastStoreEntry _renameKeys(
    PodcastStoreEntry entry,
    Map<String, String> renames,
  ) {
    return {
      for (final MapEntry(:key, :value) in entry.entries)
        (renames[key] ?? key): value,
    };
  }

  Future<R> _mutate<R>(R Function(List<StoredPodcast> podcasts) updater) {
    return _serialized(() async {
      final podcasts = List<StoredPodcast>.from((await _read()).podcasts);
      final result = updater(podcasts);

      await _write(podcasts);

      return result;
    });
  }

  Future<void> _write(List<StoredPodcast> podcasts) async {
    final file = await _resolveFile();
    await file.parent.create(recursive: true);

    final temp = File('${file.path}.tmp');
    await temp.writeAsString(
      jsonEncode({
        'version': _storeVersion,
        'podcasts': [for (final row in podcasts) _join(row)],
      }),
      flush: true,
    );
    await temp.rename(file.path);
  }

  Future<void> _tail = Future<void>.value();

  Future<R> _serialized<R>(Future<R> Function() action) {
    final next = _tail.then((_) => action());
    _tail = next.then((_) {}, onError: (_) {});
    return next;
  }
}
