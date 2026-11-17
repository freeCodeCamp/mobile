import 'package:flutter/material.dart';
import 'package:freecodecamp/settings/models/app_preferences_model.dart';
import 'package:freecodecamp/settings/repositories/preferences_repository.dart';
import 'package:freecodecamp/settings/services/learning_reminder_service.dart';
import 'package:freecodecamp/utils/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'preferences_service.g.dart';

@Riverpod(keepAlive: true, retry: noRetry)
SettingsPreferencesService settingsPreferencesService(Ref ref) {
  return SettingsPreferencesService(
    ref.watch(settingsPreferencesRepositoryProvider.future),
    ref.watch(learningReminderServiceProvider),
    reload: () => ref.invalidate(settingsPreferencesRepositoryProvider),
  );
}

class SettingsPreferencesService {
  SettingsPreferencesService(
    this._repo,
    this._reminders, {
    required this.reload,
  });

  final Future<SettingsPreferencesRepository> _repo;
  final LearningReminderService _reminders;
  final void Function() reload;

  Future<AppPreferences> load() async {
    final repo = await _repo;
    return AppPreferences(
      themeMode: ThemeMode.values.firstWhere(
        (mode) => mode.name == repo.readTheme(),
        orElse: () => ThemeMode.dark,
      ),
      dailyReminder: repo.readReminder() ?? false,
    );
  }

  Future<bool> readDailyReminder() async =>
      (await _repo).readReminder() ?? false;

  Future<void> saveTheme(ThemeMode mode) async =>
      (await _repo).writeTheme(mode.name);

  Future<void> saveDailyReminder(bool enabled, {required bool previous}) async {
    final repo = await _repo;
    await _applySchedule(enabled);
    try {
      await repo.writeReminder(enabled);
    } catch (_) {
      // Restore the OS schedule to match the last successfully saved value.
      await _applySchedule(previous);
      rethrow;
    }
  }

  Future<void> clear() async => (await _repo).clear();

  Future<void> _applySchedule(bool enabled) {
    return enabled ? _reminders.enable() : _reminders.cancel();
  }
}
