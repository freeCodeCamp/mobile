import 'package:flutter/material.dart';
import 'package:freecodecamp/services/auth_service.dart';
import 'package:freecodecamp/settings/services/app_preferences.dart';
import 'package:freecodecamp/settings/services/learning_reminder_service.dart';
import 'package:freecodecamp/settings/services/local_data_service.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
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
      await ref.read(localDataResetServiceProvider).reset();
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
