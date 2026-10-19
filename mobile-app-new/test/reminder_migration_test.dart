import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app_new/auth/models/user_model.dart';
import 'package:mobile_app_new/learn/services/daily_challenge_reminder_service.dart';
import 'package:mobile_app_new/services/notification_service.dart';
import 'package:mobile_app_new/settings/services/app_preferences.dart';
import 'package:mobile_app_new/settings/services/learning_reminder_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _Notifications extends NotificationService {
  final pending = <int, Map<Object?, Object?>>{};
  final canceled = <int>[];
  int permissionRequests = 0;
  bool permitted = true;

  @override
  Future<bool> requestPermission() async {
    permissionRequests++;
    return permitted;
  }

  @override
  Future<void> cancel(int id) async {
    canceled.add(id);
    pending.remove(id);
  }
}

void main() {
  final binding = TestWidgetsFlutterBinding.ensureInitialized();
  const notificationChannel = MethodChannel(
    'dexterous.com/flutter/local_notifications',
  );
  const timezoneChannel = MethodChannel('flutter_timezone');
  late _Notifications notifications;
  late LearningReminderService reminders;
  Completer<void>? pendingSchedule;
  Completer<void>? scheduleStarted;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    AndroidFlutterLocalNotificationsPlugin.registerWith();
    notifications = _Notifications();
    reminders = LearningReminderService(notifications);
    pendingSchedule = null;
    scheduleStarted = null;
    binding.defaultBinaryMessenger.setMockMethodCallHandler(
      notificationChannel,
      (call) async {
        if (call.method == 'zonedSchedule') {
          final args = Map<Object?, Object?>.from(call.arguments as Map);
          scheduleStarted?.complete();
          await pendingSchedule?.future;
          notifications.pending[args['id']! as int] = args;
        }
        return null;
      },
    );
    binding.defaultBinaryMessenger.setMockMethodCallHandler(
      timezoneChannel,
      (_) async => 'Europe/Amsterdam',
    );
  });
  tearDown(() {
    debugDefaultTargetPlatformOverride = null;
    binding.defaultBinaryMessenger.setMockMethodCallHandler(
      notificationChannel,
      null,
    );
    binding.defaultBinaryMessenger.setMockMethodCallHandler(
      timezoneChannel,
      null,
    );
  });

  ProviderContainer container() {
    final container = ProviderContainer(
      overrides: [learningReminderServiceProvider.overrideWithValue(reminders)],
    );
    addTearDown(container.dispose);
    return container;
  }

  void seedMigratedNotifications() {
    for (var id = 9000; id < 9007; id++) {
      notifications.pending[id] = {};
    }
  }

  for (final enabled in [null, false, true]) {
    test('startup and completion respect stored reminder $enabled', () async {
      if (enabled != null) {
        SharedPreferences.setMockInitialValues({
          AppPreferencesNotifier.reminderKey: enabled,
        });
      }
      seedMigratedNotifications();
      final scope = container();
      final adapter = scope.read(learnDailyChallengeReminderServiceProvider);
      await adapter.reschedule(null);
      await adapter.reschedule(
        FccUserModel(
          id: 'camper',
          username: 'camper',
          email: 'camper@example.com',
          joinDate: DateTime(2020),
          completedDailyCodingChallenges: [
            CompletedDailyChallenge(id: 'today', completedDate: DateTime.now()),
          ],
        ),
      );
      expect(
        notifications.pending.keys,
        enabled == true ? [LearningReminderService.notificationId] : isEmpty,
      );
      expect(notifications.permissionRequests, enabled == true ? 2 : 0);
      if (enabled == true) {
        final schedule =
            notifications.pending[LearningReminderService.notificationId]!;
        expect(
          schedule['matchDateTimeComponents'],
          DateTimeComponents.time.index,
        );
        expect(schedule['timeZoneName'], 'Europe/Amsterdam');
        expect(
          DateTime.parse(schedule['scheduledDateTime']! as String).hour,
          9,
        );
      }
      expect(
        (await scope.read(appPreferencesProvider.future)).dailyReminder,
        enabled ?? false,
      );
    });
  }

  test('turning reminders off clears recurring and migrated IDs', () async {
    SharedPreferences.setMockInitialValues({
      AppPreferencesNotifier.reminderKey: true,
    });
    seedMigratedNotifications();
    notifications.pending[LearningReminderService.notificationId] = {};
    final scope = container();
    await scope.read(appPreferencesProvider.notifier).setDailyReminder(false);
    expect(notifications.pending, isEmpty);
    expect(
      notifications.canceled,
      containsAll([
        LearningReminderService.notificationId,
        for (var id = 9000; id < 9007; id++) id,
      ]),
    );
    await scope
        .read(learnDailyChallengeReminderServiceProvider)
        .reschedule(null);
    expect(notifications.pending, isEmpty);
    expect(notifications.permissionRequests, 0);
    expect(
      (await scope.read(appPreferencesProvider.future)).dailyReminder,
      isFalse,
    );
  });

  test('delayed stored opt-in cannot override an explicit disable', () async {
    final stored = Completer<bool>();
    final reading = Completer<void>();
    final adapter = LearnDailyChallengeReminderService(reminders, () {
      reading.complete();
      return stored.future;
    });
    final restore = adapter.reschedule(null);
    await reading.future;
    final cancel = reminders.cancel();
    stored.complete(true);
    await Future.wait([restore, cancel]);
    expect(notifications.pending, isEmpty);
    expect(notifications.permissionRequests, 0);
  });

  test(
    'a restore using old preferences cannot undo an explicit enable',
    () async {
      final enabled = reminders.enable();
      final adapter = LearnDailyChallengeReminderService(
        reminders,
        () async => false,
      );
      await adapter.reschedule(null);
      await enabled;
      expect(notifications.pending.keys, [
        LearningReminderService.notificationId,
      ]);
    },
  );

  test(
    'disable waits for an in-flight native schedule then removes it',
    () async {
      pendingSchedule = Completer<void>();
      scheduleStarted = Completer<void>();
      final adapter = LearnDailyChallengeReminderService(
        reminders,
        () async => true,
      );
      final restore = adapter.reschedule(null);
      await scheduleStarted!.future;
      final cancel = reminders.cancel();
      pendingSchedule!.complete();
      await Future.wait([restore, cancel]);
      expect(notifications.pending, isEmpty);
    },
  );

  test('a failed restore does not block a later settings change', () async {
    notifications.permitted = false;
    final adapter = LearnDailyChallengeReminderService(
      reminders,
      () async => true,
    );
    await adapter.reschedule(null);
    expect(notifications.pending, isEmpty);
    notifications.permitted = true;
    await reminders.enable();
    expect(notifications.pending.keys, [
      LearningReminderService.notificationId,
    ]);
    await reminders.cancel();
    expect(notifications.pending, isEmpty);
  });
}
