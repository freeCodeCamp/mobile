import 'dart:developer';
import 'dart:io';
import 'dart:math' show Random, pow;

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mobile_app_new/fcc_theme.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notification_service.g.dart';

@Riverpod(keepAlive: true)
NotificationService notificationService(Ref ref) => NotificationService();

class NotificationService {
  static const _channelId = 'fcc-notif-channel';
  static const _channelName = 'podcast-episodes';

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  final Random _random = Random();

  Future<void>? _initialisation;

  Future<void> _ensureInitialised() => _initialisation ??= _plugin.initialize(
    settings: const InitializationSettings(
      android: AndroidInitializationSettings('notification_icon'),
      iOS: DarwinInitializationSettings(),
    ),
  );

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
