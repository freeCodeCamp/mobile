import 'dart:io';
import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/models/learn/completed_challenge_model.dart';
import 'package:freecodecamp/models/main/user_model.dart';
import 'package:freecodecamp/service/authentication/authentication_service.dart';
import 'package:freecodecamp/service/learn/daily_challenge_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class DailyChallengeNotificationService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;
  final DailyChallengeService _dailyChallengeService;
  final AuthenticationService _authenticationService;
  Random random = Random();

  static const String _channelId = 'daily_challenge_channel';

  DailyChallengeNotificationService({
    FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin,
    DailyChallengeService? dailyChallengeService,
    AuthenticationService? authenticationService,
  })  : _flutterLocalNotificationsPlugin = flutterLocalNotificationsPlugin ??
            FlutterLocalNotificationsPlugin(),
        _dailyChallengeService =
            dailyChallengeService ?? locator<DailyChallengeService>(),
        _authenticationService =
            authenticationService ?? locator<AuthenticationService>();

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

    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();

    // Check if notification window has expired
    if (await hasNotificationWindowExpired(prefs, now)) {
      return;
    }

    // Determine when to start scheduling notifications
    final startSchedulingFrom = await determineSchedulingStartDate(prefs, now);
    await prefs.setString('notification_schedule_start_date',
        startSchedulingFrom.toIso8601String());

    // Schedule notifications for the next 7 days
    await scheduleNotificationsForPeriod(startSchedulingFrom, now);
  }

  Future<bool> hasNotificationWindowExpired(
      SharedPreferences prefs, DateTime now) async {
    const maxDays = 7;
    final scheduleStartDateStr =
        prefs.getString('notification_schedule_start_date');

    if (scheduleStartDateStr != null) {
      final scheduleStartDate = DateTime.parse(scheduleStartDateStr);
      final daysSinceStart = now.difference(scheduleStartDate).inDays;

      // If more than 7 days have passed and user hasn't opened the app,
      // we assume the user has stopped engaging and stop sending them notifications.
      return daysSinceStart >= maxDays;
    }

    return false;
  }

  Future<DateTime> determineSchedulingStartDate(
      SharedPreferences prefs, DateTime now) async {
    final scheduleStartDateStr =
        prefs.getString('notification_schedule_start_date');

    final todayChallengeCompleted = await checkIfTodayChallengeCompleted();
    DateTime startSchedulingFrom;

    if (todayChallengeCompleted) {
      // If today's challenge is completed, start from tomorrow
      final tomorrow = now.add(const Duration(days: 1));

      startSchedulingFrom =
          DateTime(tomorrow.year, tomorrow.month, tomorrow.day);
    } else {
      // If not completed, use cache if available, else today
      if (scheduleStartDateStr != null) {
        startSchedulingFrom = DateTime.parse(scheduleStartDateStr);
      } else {
        startSchedulingFrom = DateTime(now.year, now.month, now.day);
      }
    }

    return startSchedulingFrom;
  }

  Future<bool> checkIfTodayChallengeCompleted() async {
    try {
      final todayChallenge = await _dailyChallengeService.fetchTodayChallenge();
      final userModelFuture = _authenticationService.userModel;

      if (userModelFuture != null) {
        try {
          FccUserModel user = await userModelFuture;
          for (CompletedDailyChallenge challenge
              in user.completedDailyCodingChallenges) {
            if (challenge.id == todayChallenge.id) {
              return true;
            }
          }
        } catch (e) {
          return false;
        }
      }
      return false;
    } catch (e) {
      // If we can't fetch today's challenge, assume it's not completed
      return false;
    }
  }

  Future<void> scheduleNotificationsForPeriod(
      DateTime startSchedulingFrom, DateTime now) async {
    final centralLocation = tz.getLocation('America/Chicago');
    final endDate = startSchedulingFrom.add(const Duration(days: 7));
    int notificationId = 0;

    for (DateTime date = startSchedulingFrom;
        date.isBefore(endDate);
        date = date.add(const Duration(days: 1))) {
      final scheduleTime = findNextValidNotificationTime(date, centralLocation);

      // Only schedule if the notification time is in the future
      if (scheduleTime.isAfter(now)) {
        await _flutterLocalNotificationsPlugin.zonedSchedule(
          notificationId++,
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

  DateTime findNextValidNotificationTime(
      DateTime scheduleDate, tz.Location centralLocation,
      {DateTime? now}) {
    // For a given date, find the best notification time:
    // Between 9 AM and 9 PM local time, but after US Central midnight (when new challenge is available)

    final current = now ?? DateTime.now();
    // Default to 9 AM on the scheduleDate. This is used if scheduleDate is not today
    DateTime candidate =
        DateTime(scheduleDate.year, scheduleDate.month, scheduleDate.day, 9);

    // If scheduleDate is today, adjust based on current time
    if (scheduleDate.day == current.day &&
        scheduleDate.month == current.month &&
        scheduleDate.year == current.year) {
      if (current.hour < 9) {
        // Before 9 AM today, schedule for 9 AM today
        candidate = DateTime(current.year, current.month, current.day, 9);
      } else if (current.hour >= 21) {
        // After 9 PM today, schedule for 9 AM tomorrow
        candidate = DateTime(current.year, current.month, current.day + 1, 9);
      } else {
        // Between 9 AM and 9 PM, schedule for 9 AM tomorrow
        candidate = DateTime(current.year, current.month, current.day + 1, 9);
      }
    }

    return candidate;
  }
}
