import 'dart:io';
import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class DailyChallengeNotificationService {
  static final DailyChallengeNotificationService _instance =
      DailyChallengeNotificationService._internal();
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  Random random = Random();

  static const String _channelId = 'daily_challenge_channel';

  factory DailyChallengeNotificationService() {
    return _instance;
  }

  Future<void> init() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/launcher_icon');
    const DarwinInitializationSettings iosInitializationSettings =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationResponse,
    );

    bool permissionGranted = false;
    if (Platform.isAndroid) {
      permissionGranted = await _flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                  AndroidFlutterLocalNotificationsPlugin>()
              ?.requestNotificationsPermission() ??
          false;
    } else {
      // For iOS, we assume permission is granted after init
      permissionGranted = true;
    }

    // Auto-enable daily notifications if system permission is granted
    // and user hasn't explicitly disabled them
    if (permissionGranted) {
      final prefs = await SharedPreferences.getInstance();
      final hasSetPreference =
          prefs.containsKey('daily_challenge_notifications_enabled');

      if (!hasSetPreference) {
        // First time - enable notifications by default
        await enableDailyNotifications();
      } else if (await areNotificationsEnabled()) {
        // Re-schedule notifications if they were previously enabled
        await scheduleDailyChallengeNotification();
      }
    }
  }

  void _onNotificationResponse(NotificationResponse response) {
    if (response.payload == 'daily_challenge_notification') {
      // Schedule the next notification
      rescheduleNextNotification();
    }
  }

  Future<void> enableDailyNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('daily_challenge_notifications_enabled', true);

    await scheduleDailyChallengeNotification();
  }

  Future<void> disableDailyNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('daily_challenge_notifications_enabled', false);
  }

  Future<bool> areNotificationsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('daily_challenge_notifications_enabled') ?? false;
  }

  Future<void> cancelAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<bool> areSystemNotificationsEnabled() async {
    if (Platform.isAndroid) {
      final androidImplementation = _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      return await androidImplementation?.areNotificationsEnabled() ?? false;
    }

    // iOS does not let apps check notification status after permission is granted, so we always return true.
    // If campers disable notifications in iOS Settings, scheduled notifications will not be shown.
    return true;
  }

  Future<void> scheduleDailyChallengeNotification() async {
    if (!(await areNotificationsEnabled()) ||
        !(await areSystemNotificationsEnabled())) {
      return;
    }

    // Cancel any previous scheduled notifications
    await _flutterLocalNotificationsPlugin.cancelAll();

    // Get US Central timezone
    final centralLocation = tz.getLocation('America/Chicago');
    final now = DateTime.now();

    // Find the next time when both conditions are met:
    // 1. After US Central midnight (new challenge available)
    // 2. Between 9 AM and 9 PM local time

    DateTime scheduleTime =
        _findNextValidNotificationTime(now, centralLocation);

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'New Daily Challenge Available! 🚀',
      'A fresh coding challenge is waiting for you. Ready to solve it?',
      tz.TZDateTime.from(scheduleTime, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          'Daily Challenge Notifications',
          channelDescription: 'Notifications for new daily coding challenges',
          priority: Priority.high,
          importance: Importance.max,
        ),
        iOS: DarwinNotificationDetails(
          threadIdentifier: 'daily-challenge-notification',
          categoryIdentifier: 'DAILY_CHALLENGE',
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: 'daily_challenge_notification',
    );
  }

  Future<void> rescheduleNextNotification() async {
    // This should be called after a notification is handled
    // to schedule the next one
    await scheduleDailyChallengeNotification();
  }

  DateTime _findNextValidNotificationTime(
      DateTime now, tz.Location centralLocation) {
    DateTime candidate;

    // Start with the next valid notification window (9 AM today or tomorrow)
    if (now.hour < 9) {
      // Before 9 AM today, try 9 AM today
      candidate = DateTime(now.year, now.month, now.day, 9);
    } else if (now.hour >= 21) {
      // After 9 PM today, schedule for 9 AM tomorrow
      candidate = DateTime(now.year, now.month, now.day, 9)
          .add(const Duration(days: 1));
    } else {
      // Between 9 AM and 9 PM, schedule for 9 AM tomorrow
      candidate = DateTime(now.year, now.month, now.day, 9)
          .add(const Duration(days: 1));
    }

    return candidate;
  }

  DailyChallengeNotificationService._internal();
}
