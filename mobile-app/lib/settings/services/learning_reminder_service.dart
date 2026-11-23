import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:freecodecamp/services/notification_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

part 'learning_reminder_service.g.dart';

@Riverpod(keepAlive: true)
LearningReminderService learningReminderService(Ref ref) {
  return LearningReminderService(ref.watch(notificationServiceProvider));
}

class ReminderPermissionDenied implements Exception {}

// One-time reminders from tomorrow, rebuilt on every open, so a day spent in the app is skipped.
class LearningReminderService {
  LearningReminderService(this._notifications);

  static const firstId = 1843001;
  static const windowDays = 7;
  final NotificationService _notifications;
  final _plugin = FlutterLocalNotificationsPlugin();
  Future<void> _pending = Future.value();
  // A late startup or resume restore must not reverse a choice not yet saved.
  bool? _chosenInSettings;
  bool _fullTimezonesLoaded = false;

  Future<bool> osAllowsNotifications() => _notifications.enabled();

  Future<void> enable() {
    return _enqueue(() async {
      await _schedule(askPermission: true);
      _chosenInSettings = true;
    });
  }

  Future<void> cancel() {
    return _enqueue(() async {
      await _cancel();
      _chosenInSettings = false;
    });
  }

  Future<void> restore({required Future<bool> Function() readEnabled}) {
    return _enqueue(() async {
      final enabled = _chosenInSettings ?? await readEnabled();
      if (!enabled) {
        await _cancel();
      } else if (await _notifications.enabled()) {
        await _schedule(askPermission: false);
      }
    });
  }

  Future<void> _enqueue(Future<void> Function() operation) {
    final result = _pending.then((_) => operation());
    _pending = result.then<void>((_) {}, onError: (Object _, StackTrace _) {});
    return result;
  }

  Future<void> _cancel() async {
    for (var id = firstId; id < firstId + windowDays; id++) {
      await _notifications.cancel(id);
    }
    // v8 reminder ids.
    for (var id = 9000; id < 9007; id++) {
      await _notifications.cancel(id);
    }
  }

  Future<void> _schedule({required bool askPermission}) async {
    await _cancel();
    if (askPermission && !await _notifications.requestPermission()) {
      throw ReminderPermissionDenied();
    }
    final zone = await FlutterTimezone.getLocalTimezone();
    // Devices can return IANA aliases (for example Europe/Amsterdam), which
    // the trimmed timezone database omits.
    if (!_fullTimezonesLoaded) {
      tz_data.initializeTimeZones();
      _fullTimezonesLoaded = true;
    }
    final location = tz.getLocation(zone.identifier);
    final times = reminderTimes(tz.TZDateTime.now(location));
    for (var i = 0; i < times.length; i++) {
      await _plugin.zonedSchedule(
        id: firstId + i,
        title: 'Make time to learn',
        body: 'Keep building your skills with freeCodeCamp today.',
        scheduledDate: times[i],
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            'daily-learning-reminder',
            'Daily learning reminder',
            channelDescription: 'A nudge to keep learning every day',
            importance: Importance.defaultImportance,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.inexact,
        payload: 'learning_reminder',
      );
    }
  }
}

// Construct calendar dates instead of adding 24 hours across DST changes.
List<tz.TZDateTime> reminderTimes(tz.TZDateTime now) {
  return [
    for (var i = 1; i <= LearningReminderService.windowDays; i++)
      tz.TZDateTime(now.location, now.year, now.month, now.day + i, 9),
  ];
}
