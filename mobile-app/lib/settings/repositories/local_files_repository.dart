import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'local_files_repository.g.dart';

@riverpod
SettingsLocalFilesRepository settingsLocalFilesRepository(Ref ref) =>
    SettingsLocalFilesRepository();

// Only the app-owned podcast folders are touched. Do not recursively delete
// the documents directory: a future editor may keep user-created work there.
class SettingsLocalFilesRepository {
  Future<List<Directory>> _downloadFolders() async {
    final documents = await getApplicationDocumentsDirectory();
    return [
      Directory(path.join(documents.path, 'episodes')),
      Directory(path.join(documents.path, 'images', 'podcast')),
    ];
  }

  Future<int> downloadedBytes() async {
    var bytes = 0;
    for (final directory in await _downloadFolders()) {
      if (!await directory.exists()) {
        continue;
      }
      await for (final entity in directory.list(
        recursive: true,
        followLinks: false,
      )) {
        if (entity is File) {
          bytes += await entity.length();
        }
      }
    }
    return bytes;
  }

  Future<void> clearDownloads() async {
    for (final directory in await _downloadFolders()) {
      if (await directory.exists()) {
        await directory.delete(recursive: true);
      }
    }
  }
}
