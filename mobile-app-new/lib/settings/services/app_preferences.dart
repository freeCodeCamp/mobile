import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'learning_reminder_service.dart';

final settingsPreferencesStoreProvider = FutureProvider<SharedPreferences>(
  (ref) => SharedPreferences.getInstance(),
);

class AppPreferences {
  const AppPreferences({
    this.themeMode = ThemeMode.system,
    this.dailyReminder = false,
  });

  final ThemeMode themeMode;
  final bool dailyReminder;
}

final appPreferencesProvider =
    AsyncNotifierProvider<AppPreferencesNotifier, AppPreferences>(
      AppPreferencesNotifier.new,
    );

class AppPreferencesNotifier extends AsyncNotifier<AppPreferences> {
  static const themeKey = 'app_theme_mode';
  static const reminderKey = 'daily_learning_reminder_enabled';

  @override
  Future<AppPreferences> build() async {
    final prefs = await ref.watch(settingsPreferencesStoreProvider.future);
    return AppPreferences(
      themeMode: ThemeMode.values.firstWhere(
        (mode) => mode.name == prefs.getString(themeKey),
        orElse: () => ThemeMode.system,
      ),
      dailyReminder: prefs.getBool(reminderKey) ?? false,
    );
  }

  Future<void> setTheme(ThemeMode mode) async {
    final current = await future;
    final prefs = await ref.read(settingsPreferencesStoreProvider.future);
    try {
      if (!await prefs.setString(themeKey, mode.name)) {
        throw StateError('Could not save the theme');
      }
    } catch (_) {
      // SharedPreferences updates its memory cache before the platform write.
      await prefs.reload();
      rethrow;
    }
    state = AsyncData(
      AppPreferences(themeMode: mode, dailyReminder: current.dailyReminder),
    );
  }

  Future<void> setDailyReminder(bool enabled) async {
    final current = await future;
    final prefs = await ref.read(settingsPreferencesStoreProvider.future);
    final reminders = ref.read(learningReminderServiceProvider);
    if (enabled) {
      await reminders.enable();
    } else {
      await reminders.cancel();
    }
    try {
      if (!await prefs.setBool(reminderKey, enabled)) {
        throw StateError('Could not save the reminder');
      }
    } catch (_) {
      // The platform can throw as well as return false. In either case, restore
      // the OS schedule to match the last successfully saved preference.
      try {
        await prefs.reload();
      } finally {
        if (current.dailyReminder) {
          await reminders.enable();
        } else {
          await reminders.cancel();
        }
      }
      rethrow;
    }
    state = AsyncData(
      AppPreferences(themeMode: current.themeMode, dailyReminder: enabled),
    );
  }
}
