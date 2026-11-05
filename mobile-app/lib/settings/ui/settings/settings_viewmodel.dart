import 'package:freecodecamp/news/controllers/bookmarks_controller.dart';
import 'package:freecodecamp/news/services/bookmark_service.dart';
import 'package:freecodecamp/podcasts/controllers/downloads_controller.dart';
import 'package:freecodecamp/podcasts/controllers/library_controller.dart';
import 'package:freecodecamp/podcasts/services/library_service.dart';
import 'package:freecodecamp/podcasts/services/playback_service.dart';
import 'package:freecodecamp/services/app_preferences_service.dart';
import 'package:freecodecamp/services/audio_service.dart';
import 'package:freecodecamp/services/auth_service.dart';
import 'package:freecodecamp/settings/services/local_data_service.dart';
import 'package:freecodecamp/settings/services/settings_service.dart';
import 'package:freecodecamp/utils/riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'settings_viewmodel.g.dart';

@Riverpod(retry: noRetry)
Future<PackageInfo> appVersion(Ref ref) => PackageInfo.fromPlatform();

@riverpod
Future<int> downloadedStorageBytes(Ref ref) {
  // Refresh the size after downloads and removals update the library.
  ref.watch(podcastLibraryProvider);
  return ref.watch(localDataServiceProvider).downloadedBytes();
}

class DownloadsInProgress implements Exception {}

// Held open for the duration of a reset, which invalidates its own listeners.
@riverpod
LocalDataReset localDataReset(Ref ref) {
  final link = ref.keepAlive();
  return LocalDataReset(
    release: link.close,
    downloadsInProgress: () =>
        ref.read(podcastDownloadsProvider.notifier).hasPendingTransfers(),
    stopPlayback: () async {
      if (ref.exists(podcastPlaybackServiceProvider)) {
        await ref.read(podcastPlaybackServiceProvider).suspendForReset();
      }
      await ref.read(audioHandlerProvider).stop();
    },
    clearBookmarks: () => ref.read(newsBookmarkServiceProvider).clearForReset(),
    clearDownloads: () async {
      await ref.read(podcastLibraryServiceProvider).clearForReset();
      await ref.read(localDataServiceProvider).clearDownloads();
    },
    // Persist the disabled reminder before the remaining reset steps, so a
    // later sign-out/storage failure cannot leave a misleading enabled switch.
    cancelReminder: () =>
        ref.read(appPreferencesProvider.notifier).setDailyReminder(false),
    signOut: () => ref.read(authProvider.notifier).signOut(),
    clearPreferences: () async {
      await (await ref.read(settingsServiceProvider.future)).clear();
    },
    refreshState: () {
      ref.invalidate(podcastLibraryProvider);
      ref.invalidate(newsBookmarksProvider);
      ref.invalidate(downloadedStorageBytesProvider);
      ref.invalidate(appPreferencesProvider);
      ref.invalidate(podcastPlaybackServiceProvider);
    },
  );
}

// Reset the data explicitly named in the confirmation. Learning progress in
// the freeCodeCamp account is remote and is never deleted by a local reset.
class LocalDataReset {
  LocalDataReset({
    required this.release,
    required this.downloadsInProgress,
    required this.stopPlayback,
    required this.clearBookmarks,
    required this.clearDownloads,
    required this.cancelReminder,
    required this.signOut,
    required this.clearPreferences,
    required this.refreshState,
  });

  final void Function() release;
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
    if (_running) {
      throw StateError('A reset is already running');
    }
    if (downloadsInProgress()) {
      throw DownloadsInProgress();
    }
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
      release();
    }
  }
}
