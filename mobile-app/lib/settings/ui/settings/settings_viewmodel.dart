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
import 'package:freecodecamp/settings/services/reset_service.dart';
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

@riverpod
class LocalDataResetNotifier extends _$LocalDataResetNotifier {
  @override
  void build() {
    ref.watch(settingsResetServiceProvider);
  }

  Future<void> reset() async {
    final link = ref.keepAlive();
    try {
      await ref
          .read(settingsResetServiceProvider)
          .reset(
            downloadsInProgress: () => ref
                .read(podcastDownloadsProvider.notifier)
                .hasPendingTransfers(),
            stopPlayback: () async {
              if (ref.exists(podcastPlaybackServiceProvider)) {
                await ref
                    .read(podcastPlaybackServiceProvider)
                    .suspendForReset();
              }
              await ref.read(audioHandlerProvider).stop();
            },
            clearBookmarks: () =>
                ref.read(newsBookmarkServiceProvider).clearForReset(),
            clearDownloads: () async {
              await ref.read(podcastLibraryServiceProvider).clearForReset();
              await ref.read(localDataServiceProvider).clearDownloads();
            },
            cancelReminder: () => ref
                .read(appPreferencesProvider.notifier)
                .setDailyReminder(false),
            signOut: () => ref.read(authProvider.notifier).signOut(),
            clearPreferences: () async {
              await (await ref.read(settingsServiceProvider.future)).clear();
            },
            refreshState: () {
              if (!ref.mounted) return;
              ref.invalidate(podcastLibraryProvider);
              ref.invalidate(newsBookmarksProvider);
              ref.invalidate(downloadedStorageBytesProvider);
              ref.invalidate(appPreferencesProvider);
              ref.invalidate(podcastPlaybackServiceProvider);
            },
          );
    } finally {
      link.close();
    }
  }
}
