import 'dart:developer' as developer;
import 'dart:io';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// This is a singleton class and initialized only once
class NotificationService {
  static final NotificationService _notificationService =
      NotificationService._internal();
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  Random random = Random();

  factory NotificationService() {
    return _notificationService;
  }

  Future<void> init() async {
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/launcher_icon');
    const DarwinInitializationSettings iosInitializationSettings =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<bool> requestPermission() async {
    if (Platform.isAndroid) {
      final androidImplementation = _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      if (androidImplementation == null) {
        return false;
      }

      try {
        return await androidImplementation.requestNotificationsPermission() ??
            false;
      } on PlatformException catch (e, stackTrace) {
        developer.log(
          'Failed to request Android notification permission.',
          error: e,
          stackTrace: stackTrace,
        );
        return false;
      } catch (e, stackTrace) {
        developer.log(
          'Unexpected failure while requesting Android notification permission.',
          error: e,
          stackTrace: stackTrace,
        );
        return false;
      }
    }

    if (Platform.isIOS) {
      final iosImplementation = _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>();

      try {
        return await iosImplementation?.requestPermissions(
              alert: true,
              badge: true,
              sound: true,
            ) ??
            false;
      } on PlatformException catch (e, stackTrace) {
        developer.log(
          'Failed to request iOS notification permission.',
          error: e,
          stackTrace: stackTrace,
        );
        return false;
      } catch (e, stackTrace) {
        developer.log(
          'Unexpected failure while requesting iOS notification permission.',
          error: e,
          stackTrace: stackTrace,
        );
        return false;
      }
    }
    return true;
  }

  Future<bool> requestPermissionIfNeeded() => requestPermission();

  Future<void> showNotification(String title, String body) async {
    // Check up more on the below values here
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'fcc-notif-channel',
      'podcast-episodes',
      channelDescription: 'Channel description',
      priority: Priority.high,
      importance: Importance.max,
    );

    const DarwinNotificationDetails iosNotificationDetails =
        DarwinNotificationDetails(threadIdentifier: 'fcc-ios-notif-channel');

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      random.nextInt(pow(2, 31).toInt() - 1),
      title,
      body,
      platformChannelSpecifics,
    );
  }

  NotificationService._internal();
}
