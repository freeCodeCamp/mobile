import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:mobile_app_new/services/dio_service.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'download_repository.g.dart';

// NOTE: Folder structure
// ApplicationDocumentsDirectory/
//   episodes/
//     <podcastId>/
//       <episodeId>.mp3
//   images/
//     podcast/
//       <podcastId>.jpg

const _episodesDirName = 'episodes';
const _artworkDirName = 'podcast';

@riverpod
PodcastDownloadRepository podcastDownloadRepository(Ref ref) =>
    PodcastDownloadRepository();

class PodcastDownloadRepository {
  final Dio _dio = DioService.dio;

  Directory? _documents;

  Future<Directory> _documentsDir() async {
    final cached = _documents;
    if (cached != null) return cached;

    return _documents = await getApplicationDocumentsDirectory();
  }

  Future<Directory> _episodesRoot() async =>
      Directory(path.join((await _documentsDir()).path, _episodesDirName));

  Future<Directory> _artworkRoot() async => Directory(
    path.join((await _documentsDir()).path, 'images', _artworkDirName),
  );

  Future<File> episodeFile(String podcastId, String episodeId) async => File(
    path.join((await _episodesRoot()).path, podcastId, '$episodeId.mp3'),
  );

  Future<File> artworkFile(String podcastId) async =>
      File(path.join((await _artworkRoot()).path, '$podcastId.jpg'));

  Future<Map<String, File>> existingArtworkFiles(
    Iterable<String> podcastIds,
  ) async {
    final files = <String, File>{};

    for (final podcastId in podcastIds) {
      final file = await artworkFile(podcastId);
      if (await file.exists()) files[podcastId] = file;
    }

    return files;
  }

  Future<void> downloadEpisode({
    required String podcastId,
    required String episodeId,
    required String url,
    CancelToken? cancelToken,
    void Function(double progress)? onProgress,
  }) async {
    final file = await episodeFile(podcastId, episodeId);
    await file.parent.create(recursive: true);

    await _downloadTo(
      file,
      url,
      cancelToken: cancelToken,
      onProgress: onProgress,
    );
  }

  Future<void> saveArtwork(String podcastId, String imageUrl) async {
    if (imageUrl.isEmpty) return;

    final file = await artworkFile(podcastId);
    if (await file.exists()) return;

    await file.parent.create(recursive: true);

    try {
      await _downloadTo(file, imageUrl);
    } catch (e) {
      log('Podcast artwork: cannot fetch for $podcastId ($e)');
    }
  }

  Future<void> _downloadTo(
    File destination,
    String url, {
    CancelToken? cancelToken,
    void Function(double progress)? onProgress,
  }) async {
    await _dio.download(
      url,
      destination.path,
      cancelToken: cancelToken,
      deleteOnError: true,
      onReceiveProgress: (received, total) {
        if (total > 0) onProgress?.call(received / total);
      },
    );
  }

  Future<void> deleteEpisodeFile(String podcastId, String episodeId) async {
    final file = await episodeFile(podcastId, episodeId);
    if (await file.exists()) await file.delete();
  }

  Future<void> deleteArtwork(String podcastId) async {
    final file = await artworkFile(podcastId);
    if (await file.exists()) await file.delete();
  }

  Future<({int count, int bytes})> deleteOrphans(
    Map<String, Set<String>> expectedEpisodeIdsByPodcastId,
  ) async {
    final expected = <String>{};

    for (final MapEntry(key: podcastId, value: episodeIds)
        in expectedEpisodeIdsByPodcastId.entries) {
      expected.add((await artworkFile(podcastId)).path);

      for (final episodeId in episodeIds) {
        expected.add((await episodeFile(podcastId, episodeId)).path);
      }
    }

    final orphans = <File>[
      for (final root in [_episodesRoot(), _artworkRoot()])
        for (final file in await _listFiles(root))
          if (!expected.contains(file.path)) file,
    ];

    if (orphans.isEmpty) return (count: 0, bytes: 0);

    final bytes = await _deleteFiles(orphans);
    await _removeEmptyPodcastDirectories();

    return (count: orphans.length, bytes: bytes);
  }

  Future<List<File>> _listFiles(Future<Directory> root) async {
    final directory = await root;
    if (!await directory.exists()) return [];

    try {
      return await directory
          .list(recursive: true)
          .where((entity) => entity is File)
          .cast<File>()
          .toList();
    } catch (e) {
      log('Podcast cleanup: cannot list ${directory.path} ($e)');
      rethrow;
    }
  }

  Future<int> _deleteFiles(Iterable<File> files) async {
    var bytes = 0;

    for (final file in files) {
      try {
        bytes += await file.length();
        await file.delete();
      } catch (e) {
        log('Podcast cleanup: cannot delete ${file.path} ($e)');
      }
    }

    return bytes;
  }

  Future<void> _removeEmptyPodcastDirectories() async {
    final root = await _episodesRoot();
    if (!await root.exists()) return;

    await for (final entry in root.list()) {
      if (entry is! Directory) continue;

      try {
        if (await entry.list().isEmpty) await entry.delete();
      } catch (e) {
        log('Podcast cleanup: cannot remove ${entry.path} ($e)');
      }
    }
  }
}
