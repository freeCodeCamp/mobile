import 'dart:developer';

import 'package:freecodecamp/auth/models/user_model.dart';
import 'package:freecodecamp/settings/services/app_preferences.dart';
import 'package:freecodecamp/settings/services/learning_reminder_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'daily_challenge_reminder_service.g.dart';

@riverpod
LearnDailyChallengeReminderService learnDailyChallengeReminderService(Ref ref) {
  final preferences = ref.watch(settingsPreferencesStoreProvider.future);
  return LearnDailyChallengeReminderService(
    ref.watch(learningReminderServiceProvider),
    () async =>
        (await preferences).getBool(AppPreferencesNotifier.reminderKey) ??
        false,
  );
}

class LearnDailyChallengeReminderService {
  LearnDailyChallengeReminderService(this._reminders, this._readEnabled);

  final LearningReminderService _reminders;
  final Future<bool> Function() _readEnabled;

  // Startup and daily challenge completion share the Settings opt-in and the
  // same recurring reminder; completing a challenge never enables reminders.
  Future<void> reschedule(FccUserModel? user) async {
    try {
      await _reminders.restore(readEnabled: _readEnabled);
    } catch (error) {
      log('Daily learning reminder: could not restore ($error)');
    }
  }
}
