import 'dart:developer';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:freecodecamp/auth/models/user_model.dart';
import 'package:freecodecamp/fcc_theme.dart';
import 'package:freecodecamp/learn/services/daily_challenge_service.dart';
import 'package:freecodecamp/services/notification_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'daily_challenge_reminder_service.g.dart';

@riverpod
LearnDailyChallengeReminderService learnDailyChallengeReminderService(
  Ref ref,
) => LearnDailyChallengeReminderService(
  ref.watch(notificationServiceProvider),
  ref.watch(learnDailyChallengeServiceProvider),
);

// NOTE: Fixed ids, so a reschedule replaces the previous week instead of stacking on it.
const _firstId = 9000;
const _days = 7;

const _details = NotificationDetails(
  android: AndroidNotificationDetails(
    'daily_challenge_channel',
    'Daily Challenge Notifications',
    channelDescription: 'Notifications for new daily coding challenges',
    priority: Priority.high,
    importance: Importance.max,
    color: FccColors.gray90,
  ),
  iOS: DarwinNotificationDetails(
    threadIdentifier: 'daily-challenge-notification',
    categoryIdentifier: 'DAILY_CHALLENGE',
  ),
);

class LearnDailyChallengeReminderService {
  LearnDailyChallengeReminderService(this._notifications, this._daily);

  final NotificationService _notifications;
  final LearnDailyChallengeService _daily;

  Future<void> reschedule(FccUserModel? user) async {
    try {
      if (!await _notifications.enabled()) return;

      for (var i = 0; i < _days; i++) {
        await _notifications.cancel(_firstId + i);
      }

      final now = DateTime.now();
      final skipToday = await _completedToday(user);
      for (var i = 0; i < _days; i++) {
        final at = DateTime(
          now.year,
          now.month,
          now.day + i + (skipToday ? 1 : 0),
          9,
        );
        if (!at.isAfter(now)) continue;

        await _notifications.schedule(
          id: _firstId + i,
          title: 'Daily Coding Challenge',
          body: "Today's coding challenge is ready. Can you solve it?",
          at: at,
          details: _details,
        );
      }
    } catch (e) {
      log('Daily challenge reminders: could not schedule ($e)');
    }
  }

  Future<bool> _completedToday(FccUserModel? user) async {
    if (user == null) return false;
    try {
      final today = await _daily.getToday();
      return user.completedDailyCodingChallenges.any((c) => c.id == today.id);
    } catch (_) {
      return false;
    }
  }
}
