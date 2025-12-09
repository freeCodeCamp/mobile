import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:freecodecamp/enums/theme_type.dart';
import 'package:freecodecamp/models/learn/completed_challenge_model.dart';
import 'package:freecodecamp/models/learn/daily_challenge_model.dart';
import 'package:freecodecamp/models/main/profile_ui_model.dart';
import 'package:freecodecamp/models/main/user_model.dart';
import 'package:freecodecamp/service/authentication/authentication_service.dart';
import 'package:freecodecamp/service/learn/daily_challenge_notification_service.dart';
import 'package:freecodecamp/service/learn/daily_challenge_service.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../../helpers/test_helpers.mocks.dart';

class TestDailyChallengeNotificationService
    extends DailyChallengeNotificationService {
  bool notificationsEnabled = true;
  bool systemNotificationsEnabled = true;

  TestDailyChallengeNotificationService({
    required FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
    required DailyChallengeService dailyChallengeService,
    required AuthenticationService authenticationService,
  }) : super(
          flutterLocalNotificationsPlugin: flutterLocalNotificationsPlugin,
          dailyChallengeService: dailyChallengeService,
          authenticationService: authenticationService,
        );

  @override
  Future<bool> areNotificationsEnabled() async => notificationsEnabled;

  @override
  Future<bool> areSystemNotificationsEnabled() async =>
      systemNotificationsEnabled;
}

class MockAndroidFlutterLocalNotificationsPlugin extends Mock
    implements AndroidFlutterLocalNotificationsPlugin {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockFlutterLocalNotificationsPlugin mockNotifications;
  late MockDailyChallengeService mockDailyChallengeService;
  late MockAuthenticationService mockAuthenticationService;
  late tz.Location tzLocation;
  late DailyChallengeNotificationService service;
  late SharedPreferences prefs;
  late MockAndroidFlutterLocalNotificationsPlugin mockAndroidNotifications;
  late TestDailyChallengeNotificationService notificationService;

  setUp(() async {
    tz.initializeTimeZones();
    tzLocation = tz.getLocation('America/Chicago');
    mockNotifications = MockFlutterLocalNotificationsPlugin();
    mockDailyChallengeService = MockDailyChallengeService();
    mockAuthenticationService = MockAuthenticationService();
    service = DailyChallengeNotificationService(
      flutterLocalNotificationsPlugin: mockNotifications,
      dailyChallengeService: mockDailyChallengeService,
      authenticationService: mockAuthenticationService,
    );
    mockAndroidNotifications = MockAndroidFlutterLocalNotificationsPlugin();

    when(mockNotifications.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>())
        .thenReturn(mockAndroidNotifications);

    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();

    notificationService = TestDailyChallengeNotificationService(
      flutterLocalNotificationsPlugin: mockNotifications,
      dailyChallengeService: mockDailyChallengeService,
      authenticationService: mockAuthenticationService,
    );
  });

  group('findNextValidNotificationTime', () {
    test('should return 9 AM today if the current time is before 9 AM', () {
      final scheduleDate = DateTime(2025, 8, 9); // 2025-08-09
      final now = DateTime(2025, 8, 9, 8, 0, 0); // 2025-08-09 08:00:00
      final result = service
          .findNextValidNotificationTime(scheduleDate, tzLocation, now: now);

      expect(result.year, 2025);
      expect(result.month, 8);
      expect(result.day, 9);
      expect(result.hour, 9);
    });

    test('should return 9 AM tomorrow if the current time is after 9 PM', () {
      final scheduleDate = DateTime(2025, 8, 9); // 2025-08-09
      final now = DateTime(2025, 8, 9, 22, 0, 0); // 2025-08-09 22:00:00
      final result = service
          .findNextValidNotificationTime(scheduleDate, tzLocation, now: now);

      expect(result.year, 2025);
      expect(result.month, 8);
      expect(result.day, 10);
      expect(result.hour, 9);
    });

    test(
        'should return 9 AM tomorrow if the current time is between 9 AM and 9 PM',
        () {
      final scheduleDate = DateTime(2025, 8, 9); // 2025-08-09
      final now = DateTime(2025, 8, 9, 15, 0, 0); // 2025-08-09 15:00:00
      final result = service
          .findNextValidNotificationTime(scheduleDate, tzLocation, now: now);

      expect(result.year, 2025);
      expect(result.month, 8);
      expect(result.day, 10);
      expect(result.hour, 9);
    });

    test(
        'should default to 9 AM on the scheduleDate if scheduleDate is not today',
        () {
      final scheduleDate = DateTime(2025, 8, 11); // 2025-08-11
      final now = DateTime(2025, 8, 8, 12, 0, 0); // 2025-08-08 12:00:00
      final result = service
          .findNextValidNotificationTime(scheduleDate, tzLocation, now: now);

      expect(result.year, 2025);
      expect(result.month, 8);
      expect(result.day, 11);
      expect(result.hour, 9);
    });
  });

  group('hasNotificationWindowExpired', () {
    test('should return true if more than 7 days have passed since start date',
        () async {
      final now = DateTime(2025, 8, 10);
      final startDate = now.subtract(const Duration(days: 8));

      await prefs.setString(
          'notification_schedule_start_date', startDate.toIso8601String());

      final result = await service.hasNotificationWindowExpired(prefs, now);

      expect(result, isTrue);
    });

    test('should return false if less than 7 days have passed since start date',
        () async {
      final now = DateTime(2025, 8, 10);
      final startDate = now.subtract(const Duration(days: 3));

      await prefs.setString(
          'notification_schedule_start_date', startDate.toIso8601String());

      final result = await service.hasNotificationWindowExpired(prefs, now);

      expect(result, isFalse);
    });

    test('should return false if no start date is set', () async {
      await prefs.remove('notification_schedule_start_date');

      final now = DateTime(2025, 8, 10);
      final result = await service.hasNotificationWindowExpired(prefs, now);

      expect(result, isFalse);
    });
  });

  group('determineSchedulingStartDate', () {
    test('should return tomorrow if today challenge is completed', () async {
      final now = DateTime(2025, 8, 10);

      when(mockDailyChallengeService.fetchTodayChallenge())
          .thenAnswer((_) async => DailyChallenge(
                id: 'challenge1',
                challengeNumber: 1,
                date: now,
                title: 'Challenge',
                description: 'desc',
                javascript: DailyChallengeLanguageData(
                  tests: [],
                  challengeFiles: [],
                ),
                python: DailyChallengeLanguageData(
                  tests: [],
                  challengeFiles: [],
                ),
              ));

      when(mockAuthenticationService.userModel)
          .thenAnswer((_) async => createMockUser(
                completedDailyCodingChallenges: [
                  CompletedDailyChallenge(
                      id: 'challenge1',
                      completedDate: now,
                      languages: const ['javascript'])
                ],
              ));

      final result = await service.determineSchedulingStartDate(prefs, now);
      final tomorrow = now.add(const Duration(days: 1));

      expect(result.year, tomorrow.year);
      expect(result.month, tomorrow.month);
      expect(result.day, tomorrow.day);
    });

    test(
        'should return cached date if today challenge is not completed and cache exists',
        () async {
      final now = DateTime(2025, 8, 10);
      final cachedDate = now.subtract(const Duration(days: 2));

      await prefs.setString(
          'notification_schedule_start_date', cachedDate.toIso8601String());

      when(mockDailyChallengeService.fetchTodayChallenge())
          .thenAnswer((_) async => DailyChallenge(
                id: 'challenge1',
                challengeNumber: 1,
                date: now,
                title: 'Challenge',
                description: 'desc',
                javascript: DailyChallengeLanguageData(
                  tests: [],
                  challengeFiles: [],
                ),
                python: DailyChallengeLanguageData(
                  tests: [],
                  challengeFiles: [],
                ),
              ));

      when(mockAuthenticationService.userModel)
          .thenAnswer((_) async => createMockUser());

      final result = await service.determineSchedulingStartDate(prefs, now);

      expect(result.year, cachedDate.year);
      expect(result.month, cachedDate.month);
      expect(result.day, cachedDate.day);
    });

    test('should return today if today not completed and no cache', () async {
      final now = DateTime(2025, 8, 10);

      await prefs.remove('notification_schedule_start_date');

      when(mockDailyChallengeService.fetchTodayChallenge())
          .thenAnswer((_) async => DailyChallenge(
                id: 'challenge1',
                challengeNumber: 1,
                date: now,
                title: 'Challenge',
                description: 'desc',
                javascript: DailyChallengeLanguageData(
                  tests: [],
                  challengeFiles: [],
                ),
                python: DailyChallengeLanguageData(
                  tests: [],
                  challengeFiles: [],
                ),
              ));

      when(mockAuthenticationService.userModel)
          .thenAnswer((_) async => createMockUser());

      final result = await service.determineSchedulingStartDate(prefs, now);

      expect(result.year, now.year);
      expect(result.month, now.month);
      expect(result.day, now.day);
    });
  });

  group('checkIfTodayChallengeCompleted', () {
    test('should return true if today challenge is completed', () async {
      final now = DateTime(2025, 8, 10);

      when(mockDailyChallengeService.fetchTodayChallenge())
          .thenAnswer((_) async => DailyChallenge(
                id: 'challenge1',
                challengeNumber: 1,
                date: now,
                title: 'Challenge',
                description: 'desc',
                javascript: DailyChallengeLanguageData(
                  tests: [],
                  challengeFiles: [],
                ),
                python: DailyChallengeLanguageData(
                  tests: [],
                  challengeFiles: [],
                ),
              ));

      when(mockAuthenticationService.userModel)
          .thenAnswer((_) async => createMockUser(
                completedDailyCodingChallenges: [
                  CompletedDailyChallenge(
                      id: 'challenge1',
                      completedDate: now,
                      languages: const ['javascript'])
                ],
              ));

      final result = await service.checkIfTodayChallengeCompleted();
      expect(result, isTrue);
    });

    test('should return false if today challenge is not completed', () async {
      final now = DateTime(2025, 8, 10);
      final yesterday = now.subtract(const Duration(days: 1));

      when(mockDailyChallengeService.fetchTodayChallenge())
          .thenAnswer((_) async => DailyChallenge(
                id: 'challenge2',
                challengeNumber: 2,
                date: now,
                title: 'Challenge',
                description: 'desc',
                javascript: DailyChallengeLanguageData(
                  tests: [],
                  challengeFiles: [],
                ),
                python: DailyChallengeLanguageData(
                  tests: [],
                  challengeFiles: [],
                ),
              ));

      when(mockAuthenticationService.userModel)
          .thenAnswer((_) async => createMockUser(
                completedDailyCodingChallenges: [
                  CompletedDailyChallenge(
                    id: 'challenge1',
                    completedDate: yesterday,
                    languages: const ['javascript'],
                  )
                ],
              ));

      final result = await service.checkIfTodayChallengeCompleted();
      expect(result, isFalse);
    });

    test('should return false if userModel is null', () async {
      final now = DateTime(2025, 8, 10);

      when(mockDailyChallengeService.fetchTodayChallenge())
          .thenAnswer((_) async => DailyChallenge(
                id: 'challenge1',
                challengeNumber: 1,
                date: now,
                title: 'Challenge',
                description: 'desc',
                javascript: DailyChallengeLanguageData(
                  tests: [],
                  challengeFiles: [],
                ),
                python: DailyChallengeLanguageData(
                  tests: [],
                  challengeFiles: [],
                ),
              ));

      when(mockAuthenticationService.userModel).thenReturn(null);

      final result = await service.checkIfTodayChallengeCompleted();
      expect(result, isFalse);
    });

    test('should return false if fetchTodayChallenge throws', () async {
      when(mockDailyChallengeService.fetchTodayChallenge())
          .thenThrow(Exception('error'));

      final result = await service.checkIfTodayChallengeCompleted();
      expect(result, isFalse);
    });
  });

  group('scheduleNotificationsForPeriod', () {
    test('should schedule 7 notifications if the start date is in the future',
        () async {
      final now = DateTime(2025, 8, 1);
      final startSchedulingFrom = DateTime(2025, 8, 2);

      await service.scheduleNotificationsForPeriod(startSchedulingFrom, now);

      verify(mockNotifications.zonedSchedule(
        any,
        any,
        any,
        any,
        any,
        androidScheduleMode: anyNamed('androidScheduleMode'),
        payload: anyNamed('payload'),
      )).called(7);
    });

    test(
        'should schedule fewer notifications if start date is not in the future',
        () async {
      // `startSchedulingFrom` is reset every time the user opens the app
      // and it can be in the past if the user hasn't opened the app for several days.
      // In this case, the function schedules notifications for the upcoming days.
      final now = DateTime(2025, 8, 2);
      final startSchedulingFrom = DateTime(2025, 7, 31);

      await service.scheduleNotificationsForPeriod(startSchedulingFrom, now);

      verify(mockNotifications.zonedSchedule(
        any,
        any,
        any,
        any,
        any,
        androidScheduleMode: anyNamed('androidScheduleMode'),
        payload: anyNamed('payload'),
      )).called(5);
    });

    test(
        'should schedule no notifications if start date + 7 are all in the past',
        () async {
      final now = DateTime(2025, 8, 10);
      final startSchedulingFrom = DateTime(2025, 8, 1);

      await service.scheduleNotificationsForPeriod(startSchedulingFrom, now);

      verifyNever(mockNotifications.zonedSchedule(
        any,
        any,
        any,
        any,
        any,
        androidScheduleMode: anyNamed('androidScheduleMode'),
        payload: anyNamed('payload'),
      ));
    });
  });

  group('scheduleDailyChallengeNotification', () {
    test('should not schedule if notifications are disabled in prefs',
        () async {
      notificationService.notificationsEnabled = false;
      notificationService.systemNotificationsEnabled = true;

      await prefs.setBool('daily_challenge_notifications_enabled', false);
      await notificationService.scheduleDailyChallengeNotification();

      verifyNever(mockNotifications.zonedSchedule(
        any,
        any,
        any,
        any,
        any,
        androidScheduleMode: anyNamed('androidScheduleMode'),
        payload: anyNamed('payload'),
      ));

      expect(prefs.getString('notification_schedule_start_date'), isNull);
    });

    test('should not schedule if system notifications are disabled', () async {
      notificationService.notificationsEnabled = true;
      notificationService.systemNotificationsEnabled = false;

      await prefs.setBool('daily_challenge_notifications_enabled', true);
      await notificationService.scheduleDailyChallengeNotification();

      verifyNever(mockNotifications.zonedSchedule(
        any,
        any,
        any,
        any,
        any,
        androidScheduleMode: anyNamed('androidScheduleMode'),
        payload: anyNamed('payload'),
      ));

      expect(prefs.getString('notification_schedule_start_date'), isNull);
    });

    test('should not schedule if notification window expired', () async {
      await prefs.setBool('daily_challenge_notifications_enabled', true);

      final now = DateTime.now();
      final expiredDate = now.subtract(const Duration(days: 8));

      await prefs.setString(
          'notification_schedule_start_date', expiredDate.toIso8601String());

      when(mockDailyChallengeService.fetchTodayChallenge())
          .thenAnswer((_) async => DailyChallenge(
                id: 'challenge1',
                challengeNumber: 1,
                date: now,
                title: 'Challenge',
                description: 'desc',
                javascript: DailyChallengeLanguageData(
                  tests: [],
                  challengeFiles: [],
                ),
                python: DailyChallengeLanguageData(
                  tests: [],
                  challengeFiles: [],
                ),
              ));

      when(mockAuthenticationService.userModel)
          .thenAnswer((_) async => createMockUser());

      await notificationService.scheduleDailyChallengeNotification();

      verifyNever(mockNotifications.zonedSchedule(
        any,
        any,
        any,
        any,
        any,
        androidScheduleMode: anyNamed('androidScheduleMode'),
        payload: anyNamed('payload'),
      ));

      final startDateStr = prefs.getString('notification_schedule_start_date');
      final startDate = DateTime.parse(startDateStr!);

      // notification_schedule_start_date isn't updated in this case
      expect(startDate.year, equals(expiredDate.year));
      expect(startDate.month, equals(expiredDate.month));
      expect(startDate.day, equals(expiredDate.day));
    });

    test(
        'should schedule notifications and update cache if enabled, notification window not expired, and today\'s challenge not completed',
        () async {
      await prefs.setBool('daily_challenge_notifications_enabled', true);

      final now = DateTime.now();

      when(mockDailyChallengeService.fetchTodayChallenge())
          .thenAnswer((_) async => DailyChallenge(
                id: 'challenge1',
                challengeNumber: 1,
                date: now,
                title: 'Challenge',
                description: 'desc',
                javascript: DailyChallengeLanguageData(
                  tests: [],
                  challengeFiles: [],
                ),
                python: DailyChallengeLanguageData(
                  tests: [],
                  challengeFiles: [],
                ),
              ));

      when(mockAuthenticationService.userModel)
          .thenAnswer((_) async => createMockUser());

      await notificationService.scheduleDailyChallengeNotification();

      verify(mockNotifications.zonedSchedule(
        any,
        any,
        any,
        any,
        any,
        androidScheduleMode: anyNamed('androidScheduleMode'),
        payload: anyNamed('payload'),
      )).called(equals(7));

      final startDateStr = prefs.getString('notification_schedule_start_date');
      final startDate = DateTime.parse(startDateStr!);

      expect(startDate.year, equals(now.year));
      expect(startDate.month, equals(now.month));
      expect(startDate.day, equals(now.day));
    });

    test(
        'should schedule notifications and update cache if enabled, notification window not expired, and today\'s challenge completed',
        () async {
      await prefs.setBool('daily_challenge_notifications_enabled', true);

      final now = DateTime.now();

      when(mockDailyChallengeService.fetchTodayChallenge())
          .thenAnswer((_) async => DailyChallenge(
                id: 'challenge1',
                challengeNumber: 1,
                date: now,
                title: 'Challenge',
                description: 'desc',
                javascript: DailyChallengeLanguageData(
                  tests: [],
                  challengeFiles: [],
                ),
                python: DailyChallengeLanguageData(
                  tests: [],
                  challengeFiles: [],
                ),
              ));

      when(mockAuthenticationService.userModel)
          .thenAnswer((_) async => createMockUser(
                completedDailyCodingChallenges: [
                  CompletedDailyChallenge(
                    id: 'challenge1',
                    completedDate: now,
                    languages: const ['javascript'],
                  )
                ],
              ));

      await notificationService.scheduleDailyChallengeNotification();

      verify(mockNotifications.zonedSchedule(
        any,
        any,
        any,
        any,
        any,
        androidScheduleMode: anyNamed('androidScheduleMode'),
        payload: anyNamed('payload'),
      )).called(equals(7));

      final tomorrow = DateTime(now.year, now.month, now.day + 1);

      final startDateStr = prefs.getString('notification_schedule_start_date');
      final startDate = DateTime.parse(startDateStr!);

      expect(startDate.year, equals(tomorrow.year));
      expect(startDate.month, equals(tomorrow.month));
      expect(startDate.day, equals(tomorrow.day));
    });
  });
}

FccUserModel createMockUser({
  List<CompletedDailyChallenge>? completedDailyCodingChallenges,
}) {
  return FccUserModel(
    id: 'user1',
    email: 'test@example.com',
    username: 'testuser',
    name: 'Test User',
    picture: '',
    currentChallengeId: '',
    emailVerified: true,
    isEmailVerified: true,
    sendQuincyEmail: null,
    isCheater: false,
    isDonating: false,
    isHonest: true,
    isFrontEndCert: false,
    isDataVisCert: false,
    isBackEndCert: false,
    isFullStackCert: false,
    isRespWebDesignCert: false,
    is2018DataVisCert: false,
    isFrontEndLibsCert: false,
    isJsAlgoDataStructCert: false,
    isApisMicroservicesCert: false,
    isInfosecQaCert: false,
    isQaCertV7: false,
    isInfosecCertV7: false,
    isSciCompPyCertV7: false,
    isDataAnalysisPyCertV7: false,
    isMachineLearningPyCertV7: false,
    isRelationalDatabaseCertV8: false,
    isCollegeAlgebraPyCertV8: false,
    isFoundationalCSharpCertV8: false,
    joinDate: DateTime(2025, 7, 1),
    points: 0,
    calendar: <DateTime, int>{},
    heatMapCal: <DateTime, int>{},
    completedChallenges: <CompletedChallenge>[],
    completedDailyCodingChallenges:
        completedDailyCodingChallenges ?? <CompletedDailyChallenge>[],
    savedChallenges: const [],
    portfolio: const [],
    yearsTopContributor: <String>[],
    theme: Themes.defaultTheme,
    profileUI: ProfileUI(
      isLocked: false,
      showAbout: false,
      showCerts: false,
      showDonation: false,
      showHeatMap: false,
      showLocation: false,
      showName: false,
      showPoints: false,
      showPortfolio: false,
      showTimeLine: false,
    ),
  );
}
