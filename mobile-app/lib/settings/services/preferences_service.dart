import 'package:flutter/material.dart';
import 'package:freecodecamp/settings/models/app_preferences_model.dart';
import 'package:freecodecamp/settings/repositories/preferences_repository.dart';
import 'package:freecodecamp/settings/services/learning_reminder_service.dart';
import 'package:freecodecamp/utils/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'preferences_service.g.dart';

@Riverpod(keepAlive: true, retry: noRetry)
Future<SettingsPreferencesService> settingsPreferencesService(Ref ref) async {
  return SettingsPreferencesService(
    await ref.watch(settingsPreferencesRepositoryProvider.future),
    ref.watch(learningReminderServiceProvider),
  );
}

class SettingsPreferencesService {
  SettingsPreferencesService(this._repo, this._reminders);

  final SettingsPreferencesRepository _repo;
  final LearningReminderService _reminders;

  AppPreferences load() {
    return AppPreferences(
      themeMode: ThemeMode.values.firstWhere(
        (mode) => mode.name == _repo.readTheme(),
        orElse: () => ThemeMode.dark,
      ),
      dailyReminder: _repo.readReminder() ?? false,
    );
  }

  bool readDailyReminder() => _repo.readReminder() ?? false;

  Future<void> saveTheme(ThemeMode mode) => _repo.writeTheme(mode.name);

  Future<void> saveDailyReminder(bool enabled, {required bool previous}) async {
    await _applySchedule(enabled);
    try {
      await _repo.writeReminder(enabled);
    } catch (_) {
      // Restore the OS schedule to match the last successfully saved value.
      await _applySchedule(previous);
      rethrow;
    }
  }

  Future<void> clear() => _repo.clear();

  Future<void> _applySchedule(bool enabled) {
    return enabled ? _reminders.enable() : _reminders.cancel();
  }
}
