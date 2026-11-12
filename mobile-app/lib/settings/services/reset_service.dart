import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'reset_service.g.dart';

@riverpod
SettingsResetService settingsResetService(Ref ref) => SettingsResetService();

class DownloadsInProgress implements Exception {}

class SettingsResetService {
  bool _running = false;

  Future<void> reset({
    required bool Function() downloadsInProgress,
    required Future<void> Function() stopPlayback,
    required Future<void> Function() clearBookmarks,
    required Future<void> Function() clearDownloads,
    required Future<void> Function() cancelReminder,
    required Future<void> Function() signOut,
    required Future<void> Function() clearPreferences,
    required void Function() refreshState,
  }) async {
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
      // Persist the disabled reminder before sign-out or storage can fail.
      await cancelReminder();
      await signOut();
      await clearPreferences();
    } finally {
      _running = false;
      // A failed reset can have completed some steps; reload those states too.
      refreshState();
    }
  }
}
