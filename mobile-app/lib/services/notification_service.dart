import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:math' show Random, pow;

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:freecodecamp/fcc_theme.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:timezone/timezone.dart' as tz;

part 'notification_service.g.dart';

// NOTE: Sent as the notification payload so a tap can be attributed. Payload strings are analytics values; don't rename them.
enum NotificationKind {
  dailyChallenge('daily_challenge'),
  podcastDownload('podcast_download');

  const NotificationKind(this.payload);

  final String payload;

  static NotificationKind? fromPayload(String? payload) =>
      values.where((kind) => kind.payload == payload).firstOrNull;
}

@Riverpod(keepAlive: true)
NotificationService notificationService(Ref ref) {
  final service = NotificationService();
  ref.onDispose(service.dispose);
  return service;
}

class NotificationService {
  static const _channelId = 'fcc-notif-channel';
  static const _channelName = 'podcast-episodes';

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  final Random _random = Random();
  final _opened = StreamController<NotificationKind?>.broadcast();

  Future<void>? _initialisation;

  Future<void> _ensureInitialised() => _initialisation ??= _plugin.initialize(
    settings: const InitializationSettings(
      android: AndroidInitializationSettings('notification_icon'),
      iOS: DarwinInitializationSettings(),
    ),
    onDidReceiveNotificationResponse: (response) =>
        _opened.add(NotificationKind.fromPayload(response.payload)),
  );

  // NOTE: Taps while the app is running. A tap that launches the app arrives through launchedFrom instead.
  Stream<NotificationKind?> get opened => _opened.stream;

  // NOTE: Null when the app wasn't launched from a notification.
  Future<({NotificationKind? kind})?> launchedFrom() async {
    await _ensureInitialised();
    final details = await _plugin.getNotificationAppLaunchDetails();
    if (details == null || !details.didNotificationLaunchApp) return null;
    return (
      kind: NotificationKind.fromPayload(details.notificationResponse?.payload),
    );
  }

  void dispose() => _opened.close();

  Future<bool> requestPermission() async {
    try {
      await _ensureInitialised();

      if (Platform.isAndroid) {
        return await _plugin
                .resolvePlatformSpecificImplementation<
                  AndroidFlutterLocalNotificationsPlugin
                >()
                ?.requestNotificationsPermission() ??
            false;
      }

      if (Platform.isIOS) {
        return await _plugin
                .resolvePlatformSpecificImplementation<
                  IOSFlutterLocalNotificationsPlugin
                >()
                ?.requestPermissions(alert: true, badge: true, sound: true) ??
            false;
      }
    } catch (e) {
      log('Notifications: permission request failed ($e)');
      return false;
    }

    return true;
  }

  Future<bool> enabled() async {
    await _ensureInitialised();
    if (!Platform.isAndroid) return true;

    return await _plugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >()
            ?.areNotificationsEnabled() ??
        false;
  }

  Future<void> schedule({
    required int id,
    required String title,
    required String body,
    required DateTime at,
    required NotificationDetails details,
    required NotificationKind kind,
  }) async {
    await _ensureInitialised();
    await _plugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: tz.TZDateTime.from(at, tz.local),
      notificationDetails: details,
      androidScheduleMode: AndroidScheduleMode.inexact,
      payload: kind.payload,
    );
  }

  Future<void> cancel(int id) async {
    await _ensureInitialised();
    await _plugin.cancel(id: id);
  }

  Future<void> showNotification(String title, String body) async {
    try {
      await _ensureInitialised();
      await _show(title, body);
    } catch (e) {
      log('Notifications: could not post "$title" ($e)');
    }
  }

  Future<void> _show(String title, String body) => _plugin.show(
    id: _random.nextInt(pow(2, 31).toInt() - 1),
    title: title,
    body: body,
    // NOTE: Only podcast downloads post immediate notifications.
    payload: NotificationKind.podcastDownload.payload,
    notificationDetails: const NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: 'Notifications about podcast episode downloads',
        priority: Priority.high,
        importance: Importance.max,
        color: FccColors.gray90,
      ),
      iOS: DarwinNotificationDetails(threadIdentifier: 'fcc-ios-notif-channel'),
    ),
  );
}
