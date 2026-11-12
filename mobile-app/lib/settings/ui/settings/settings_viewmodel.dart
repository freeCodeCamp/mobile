import 'package:flutter/material.dart';
import 'package:freecodecamp/news/controllers/bookmarks_controller.dart';
import 'package:freecodecamp/news/services/bookmark_service.dart';
import 'package:freecodecamp/podcasts/controllers/downloads_controller.dart';
import 'package:freecodecamp/podcasts/controllers/library_controller.dart';
import 'package:freecodecamp/podcasts/services/library_service.dart';
import 'package:freecodecamp/podcasts/services/playback_service.dart';
import 'package:freecodecamp/services/app_preferences_service.dart';
import 'package:freecodecamp/services/audio_service.dart';
import 'package:freecodecamp/services/auth_service.dart';
import 'package:freecodecamp/settings/services/app_info_service.dart';
import 'package:freecodecamp/settings/services/learning_reminder_service.dart';
import 'package:freecodecamp/settings/services/local_data_service.dart';
import 'package:freecodecamp/settings/services/preferences_service.dart';
import 'package:freecodecamp/settings/services/reset_service.dart';
import 'package:freecodecamp/utils/riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'settings_viewmodel.freezed.dart';
part 'settings_viewmodel.g.dart';

@freezed
abstract class SettingsState with _$SettingsState {
  const factory SettingsState({
    @Default(false) bool busy,
    bool? pendingReminder,
  }) = _SettingsState;
}

const _saveFailed = 'Could not save this change. Please try again.';

@riverpod
class SettingsNotifier extends _$SettingsNotifier {
  @override
  SettingsState build() => const SettingsState();

  Future<String?> setTheme(ThemeMode mode) {
    return _runBusy(
      () => ref.read(appPreferencesProvider.notifier).setTheme(mode),
      failure: _saveFailed,
    );
  }

  Future<String?> signOut() {
    return _runBusy(
      () => ref.read(authProvider.notifier).signOut(),
      failure: _saveFailed,
    );
  }

  Future<String?> resetLocalData() async {
    if (state.busy) return null;
    state = state.copyWith(busy: true);
    try {
      await ref.read(settingsLocalDataResetProvider.notifier).reset();
      return 'Local app data cleared. Your online progress is safe.';
    } on DownloadsInProgress {
      return 'Finish or cancel your episode downloads before resetting.';
    } catch (_) {
      return 'Some local data could not be cleared. Please try again.';
    } finally {
      if (ref.mounted) state = state.copyWith(busy: false);
    }
  }

  // Only pendingReminder changes, so the rest of the screen stays untouched.
  Future<String?> setDailyReminder(bool enabled) async {
    if (state.busy || state.pendingReminder != null) return null;
    state = state.copyWith(pendingReminder: enabled);
    try {
      await ref.read(appPreferencesProvider.notifier).setDailyReminder(enabled);
      return null;
    } on ReminderPermissionDenied {
      return 'Allow notifications in your device settings to enable reminders.';
    } catch (_) {
      return _saveFailed;
    } finally {
      if (ref.mounted) state = state.copyWith(pendingReminder: null);
    }
  }

  Future<String?> _runBusy(
    Future<void> Function() action, {
    required String failure,
  }) async {
    if (state.busy) return null;
    state = state.copyWith(busy: true);
    try {
      await action();
      return null;
    } catch (_) {
      return failure;
    } finally {
      if (ref.mounted) state = state.copyWith(busy: false);
    }
  }
}

@Riverpod(retry: noRetry)
Future<PackageInfo> appVersion(Ref ref) {
  return ref.watch(settingsAppInfoServiceProvider).getAppInfo();
}

@riverpod
Future<int> downloadedStorageBytes(Ref ref) {
  // Refresh the size after downloads and removals update the library.
  ref.watch(podcastLibraryProvider);
  return ref.watch(settingsLocalDataServiceProvider).downloadedBytes();
}

@riverpod
class SettingsLocalDataResetNotifier extends _$SettingsLocalDataResetNotifier {
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
              await ref.read(settingsLocalDataServiceProvider).clearDownloads();
            },
            cancelReminder: () => ref
                .read(appPreferencesProvider.notifier)
                .setDailyReminder(false),
            signOut: () => ref.read(authProvider.notifier).signOut(),
            clearPreferences: () =>
                ref.read(settingsPreferencesServiceProvider).clear(),
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
