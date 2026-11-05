import 'package:freecodecamp/utils/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'settings_repository.g.dart';

@Riverpod(keepAlive: true, retry: noRetry)
Future<SettingsRepository> settingsRepository(Ref ref) async {
  return SettingsRepository(await SharedPreferences.getInstance());
}

class SettingsRepository {
  SettingsRepository(this._prefs);

  static const _themeKey = 'app_theme_mode';
  static const _reminderKey = 'daily_learning_reminder_enabled';

  final SharedPreferences _prefs;

  String? readTheme() => _prefs.getString(_themeKey);

  bool? readReminder() => _prefs.getBool(_reminderKey);

  Future<void> writeTheme(String value) {
    return _write(() => _prefs.setString(_themeKey, value), 'the theme');
  }

  Future<void> writeReminder(bool value) {
    return _write(() => _prefs.setBool(_reminderKey, value), 'the reminder');
  }

  Future<void> clear() {
    return _write(_prefs.clear, 'the preferences');
  }

  Future<void> _write(Future<bool> Function() write, String subject) async {
    try {
      if (!await write()) {
        throw StateError('Could not save $subject');
      }
    } catch (_) {
      // SharedPreferences updates its memory cache before the platform write.
      await _prefs.reload();
      rethrow;
    }
  }
}
