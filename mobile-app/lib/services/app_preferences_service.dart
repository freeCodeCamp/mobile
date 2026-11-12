import 'package:flutter/material.dart';
import 'package:freecodecamp/settings/models/app_preferences_model.dart';
import 'package:freecodecamp/settings/services/preferences_service.dart';
import 'package:freecodecamp/utils/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_preferences_service.g.dart';

@Riverpod(keepAlive: true, retry: noRetry)
class AppPreferencesNotifier extends _$AppPreferencesNotifier {
  @override
  Future<AppPreferences> build() async {
    return ref.watch(settingsPreferencesServiceProvider).load();
  }

  void retry() {
    ref.read(settingsPreferencesServiceProvider).reload();
  }

  Future<void> setTheme(ThemeMode mode) async {
    final current = await future;
    final service = ref.read(settingsPreferencesServiceProvider);
    await service.saveTheme(mode);
    if (ref.mounted) {
      state = AsyncData(current.copyWith(themeMode: mode));
    }
  }

  Future<void> setDailyReminder(bool enabled) async {
    final current = await future;
    final service = ref.read(settingsPreferencesServiceProvider);
    await service.saveDailyReminder(enabled, previous: current.dailyReminder);
    if (ref.mounted) {
      state = AsyncData(current.copyWith(dailyReminder: enabled));
    }
  }
}
