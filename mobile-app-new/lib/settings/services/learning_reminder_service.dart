import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:mobile_app_new/services/notification_service.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

final learningReminderServiceProvider = Provider<LearningReminderService>(
  (ref) => LearningReminderService(ref.watch(notificationServiceProvider)),
);

class ReminderPermissionDenied implements Exception {}

/// A daily learning reminder, separate from podcast download notifications.
/// The OS owns recurrence, so reminders continue while the app is closed.
class LearningReminderService {
  LearningReminderService(this._notifications);

  static const notificationId = 1843001;
  final NotificationService _notifications;
  final _plugin = FlutterLocalNotificationsPlugin();
  Future<void> _pending = Future.value();
  bool _changedInSettings = false;

  Future<void> enable() {
    _changedInSettings = true;
    return _enqueue(_enable);
  }

  Future<void> cancel() {
    _changedInSettings = true;
    return _enqueue(_cancel);
  }

  Future<void> restore({required Future<bool> Function() readEnabled}) {
    return _enqueue(() async {
      // Settings already applied the recurring schedule for this session.
      // A delayed startup/completion callback must not reverse that choice.
      if (_changedInSettings) return;
      final enabled = await readEnabled();
      if (_changedInSettings) return;
      if (enabled) {
        await _enable();
      } else {
        await _cancel();
      }
    });
  }

  Future<void> _enqueue(Future<void> Function() operation) {
    final result = _pending.then((_) => operation());
    _pending = result.then<void>((_) {}, onError: (Object _, StackTrace _) {});
    return result;
  }

  Future<void> _cancelMigratedReminders() async {
    for (var id = 9000; id < 9007; id++) {
      await _notifications.cancel(id);
    }
  }

  Future<void> _enable() async {
    await _cancelMigratedReminders();
    if (!await _notifications.requestPermission()) {
      throw ReminderPermissionDenied();
    }
    final zone = await FlutterTimezone.getLocalTimezone();
    // Devices can return IANA aliases (for example Europe/Amsterdam), which
    // the trimmed timezone database omits.
    tz_data.initializeTimeZones();
    final location = tz.getLocation(zone.identifier);
    final now = tz.TZDateTime.now(location);
    await _plugin.zonedSchedule(
      id: notificationId,
      title: 'Make time to learn',
      body: 'Keep building your skills with freeCodeCamp today.',
      scheduledDate: nextReminderTime(now),
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily-learning-reminder',
          'Daily learning reminder',
          channelDescription: 'Your daily reminder to keep learning',
          importance: Importance.defaultImportance,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: 'learning_reminder',
    );
  }

  Future<void> _cancel() async {
    await _notifications.cancel(notificationId);
    await _cancelMigratedReminders();
  }
}

/// Construct calendar dates instead of adding 24 hours across DST changes.
tz.TZDateTime nextReminderTime(tz.TZDateTime now) {
  final today = tz.TZDateTime(now.location, now.year, now.month, now.day, 9);
  return today.isAfter(now)
      ? today
      : tz.TZDateTime(now.location, now.year, now.month, now.day + 1, 9);
}
