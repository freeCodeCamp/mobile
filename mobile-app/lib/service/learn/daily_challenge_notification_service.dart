import 'dart:io';
import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/models/learn/completed_challenge_model.dart';
import 'package:freecodecamp/models/main/user_model.dart';
import 'package:freecodecamp/service/authentication/authentication_service.dart';
import 'package:freecodecamp/service/learn/daily_challenge_service.dart';
import 'package:freecodecamp/ui/views/learn/utils/challenge_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class DailyChallengeNotificationService {
  static final DailyChallengeNotificationService _instance =
      DailyChallengeNotificationService._internal();
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  Random random = Random();

  // Service dependencies
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final DailyChallengeService _dailyChallengeService =
      locator<DailyChallengeService>();

  static const String _channelId = 'daily_challenge_channel';

  static const int _maxDaysToSchedule = 7;

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
      scheduleDailyChallengeNotification();
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

    // Schedule notifications for the next 7 days.
    // If the app isn't opened for over 7 days, notifications will stop until the app is opened again
    // and the service reschedules future notifications.
    for (int i = 0; i < _maxDaysToSchedule; i++) {
      final targetDate = now.add(Duration(days: i));

      // Skip if challenge for this date is already completed
      if (await isDailyChallengeCompletedForDate(targetDate)) {
        continue;
      }

      // Find the next valid notification time for this date
      DateTime scheduleTime =
          _findNextValidNotificationTime(targetDate, centralLocation);

      // Only schedule if the time is in the future
      if (scheduleTime.isAfter(now)) {
        await _flutterLocalNotificationsPlugin.zonedSchedule(
          i, // Use day offset as unique notification ID
          'New Daily Challenge Available! 🧩',
          'A fresh coding challenge is waiting for you. Ready to solve it?',
          tz.TZDateTime.from(scheduleTime, tz.local),
          const NotificationDetails(
            android: AndroidNotificationDetails(
              _channelId,
              'Daily Challenge Notifications',
              channelDescription:
                  'Notifications for new daily coding challenges',
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
    }
  }

  Future<bool> isDailyChallengeCompletedForDate(DateTime date) async {
    try {
      final challenge = await _dailyChallengeService
          .fetchChallengeByDate(formatChallengeDate(date));

      final FccUserModel? user = await _authenticationService.userModel;
      if (user != null) {
        for (CompletedDailyChallenge completedChallenge
            in user.completedDailyCodingChallenges) {
          if (completedChallenge.id == challenge.id) {
            return true;
          }
        }
      }
      return false;
    } catch (e) {
      // If we can't fetch the challenge or user data, assume it's not completed
      // to err on the side of sending notifications
      return false;
    }
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

  /// Call this method when a daily challenge is completed to refresh notifications
  Future<void> onTodayChallengeCompleted() async {
    if (await areNotificationsEnabled()) {
      // Re-schedule notifications to skip the newly completed challenge
      await scheduleDailyChallengeNotification();
    }
  }

  DailyChallengeNotificationService._internal();
}
