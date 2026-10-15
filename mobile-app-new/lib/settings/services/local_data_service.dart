import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app_new/news/controllers/bookmarks_controller.dart';
import 'package:mobile_app_new/news/repositories/bookmark_repository.dart';
import 'package:mobile_app_new/podcasts/controllers/downloads_controller.dart';
import 'package:mobile_app_new/podcasts/controllers/library_controller.dart';
import 'package:mobile_app_new/podcasts/repositories/storage_repository.dart';
import 'package:mobile_app_new/podcasts/services/playback_service.dart';
import 'package:mobile_app_new/services/audio_service.dart';
import 'package:mobile_app_new/services/auth_service.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import 'app_preferences.dart';

final appVersionProvider = FutureProvider<PackageInfo>(
  (ref) => PackageInfo.fromPlatform(),
);

final localDataFilesProvider = Provider<LocalDataFiles>(
  (ref) => LocalDataFiles(),
);

final downloadedStorageBytesProvider = FutureProvider<int>((ref) {
  // Refresh the size after downloads and removals update the library.
  ref.watch(podcastLibraryProvider);
  return ref.watch(localDataFilesProvider).downloadedBytes();
});

/// Only the app-owned podcast folders are removed. Do not recursively delete
/// the documents directory: a future editor may keep user-created work there.
class LocalDataFiles {
  LocalDataFiles({Future<Directory> Function()? documentsDirectory})
    : _documentsDirectory =
          documentsDirectory ?? getApplicationDocumentsDirectory;

  final Future<Directory> Function() _documentsDirectory;

  Future<List<Directory>> _downloadFolders() async {
    final documents = await _documentsDirectory();
    return [
      Directory(path.join(documents.path, 'episodes')),
      Directory(path.join(documents.path, 'images', 'podcast')),
    ];
  }

  Future<int> downloadedBytes() async {
    var bytes = 0;
    for (final directory in await _downloadFolders()) {
      if (!await directory.exists()) continue;
      await for (final entity in directory.list(
        recursive: true,
        followLinks: false,
      )) {
        if (entity is File) bytes += await entity.length();
      }
    }
    return bytes;
  }

  Future<void> clearDownloads() async {
    for (final directory in await _downloadFolders()) {
      if (await directory.exists()) await directory.delete(recursive: true);
    }
  }
}

class DownloadsInProgress implements Exception {}

final localDataResetServiceProvider = Provider<LocalDataResetService>((ref) {
  return LocalDataResetService(
    downloadsInProgress: () =>
        ref.read(podcastDownloadsProvider.notifier).hasPendingTransfers,
    stopPlayback: () async {
      if (ref.exists(podcastPlaybackServiceProvider)) {
        await ref.read(podcastPlaybackServiceProvider).suspendForReset();
      }
      await ref.read(audioHandlerProvider).stop();
    },
    clearBookmarks: () =>
        ref.read(newsBookmarkRepositoryProvider).clearForReset(),
    clearDownloads: () async {
      await ref.read(podcastStorageRepositoryProvider).clearForReset();
      await ref.read(localDataFilesProvider).clearDownloads();
    },
    // Persist the disabled reminder before the remaining reset steps, so a
    // later sign-out/storage failure cannot leave a misleading enabled switch.
    cancelReminder: () =>
        ref.read(appPreferencesProvider.notifier).setDailyReminder(false),
    signOut: () => ref.read(authProvider.notifier).signOut(),
    clearPreferences: () async {
      final prefs = await ref.read(settingsPreferencesStoreProvider.future);
      try {
        if (!await prefs.clear()) {
          throw StateError('Preferences were not cleared');
        }
      } catch (_) {
        await prefs.reload();
        rethrow;
      }
    },
    refreshState: () {
      ref.invalidate(podcastLibraryProvider);
      ref.invalidate(newsBookmarksProvider);
      ref.invalidate(downloadedStorageBytesProvider);
      ref.invalidate(appPreferencesProvider);
      ref.invalidate(podcastPlaybackServiceProvider);
    },
  );
});

/// Reset the data explicitly named in the confirmation. Learning progress in
/// the freeCodeCamp account is remote and is never deleted by a local reset.
/// All operations are injectable so destructive behavior is tested with mocks.
class LocalDataResetService {
  LocalDataResetService({
    required this.downloadsInProgress,
    required this.stopPlayback,
    required this.clearBookmarks,
    required this.clearDownloads,
    required this.cancelReminder,
    required this.signOut,
    required this.clearPreferences,
    required this.refreshState,
  });

  final bool Function() downloadsInProgress;
  final Future<void> Function() stopPlayback;
  final Future<void> Function() clearBookmarks;
  final Future<void> Function() clearDownloads;
  final Future<void> Function() cancelReminder;
  final Future<void> Function() signOut;
  final Future<void> Function() clearPreferences;
  final void Function() refreshState;
  bool _running = false;

  Future<void> reset() async {
    if (_running) throw StateError('A reset is already running');
    if (downloadsInProgress()) throw DownloadsInProgress();
    _running = true;
    try {
      await stopPlayback();
      await clearBookmarks();
      await clearDownloads();
      await cancelReminder();
      await signOut();
      await clearPreferences();
    } finally {
      // A failed reset can have completed some steps; reload those states too.
      refreshState();
      _running = false;
    }
  }
}
