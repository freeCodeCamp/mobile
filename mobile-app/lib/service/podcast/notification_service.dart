import 'dart:io';
import 'dart:math' show Random;

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  NotificationService({
    FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin,
    Random? random,
  })  : _flutterLocalNotificationsPlugin =
            flutterLocalNotificationsPlugin ?? FlutterLocalNotificationsPlugin(),
        _random = random ?? Random();

  static const int _maxNotificationId = 0x7fffffff;

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;
  final Random _random;

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

    if (Platform.isAndroid) {
      await requestPermission();
    }
  }

  Future<bool> requestPermission() async {
    if (!Platform.isAndroid) {
      return true;
    }

    return await _flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.requestNotificationsPermission() ??
        false;
  }

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
      _random.nextInt(_maxNotificationId),
      title,
      body,
      platformChannelSpecifics,
    );
  }
}
