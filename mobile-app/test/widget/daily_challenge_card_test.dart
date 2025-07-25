import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/app/app.router.dart';
import 'package:freecodecamp/enums/theme_type.dart';
import 'package:freecodecamp/models/learn/completed_challenge_model.dart';
import 'package:freecodecamp/models/learn/daily_challenge_model.dart';
import 'package:freecodecamp/models/main/profile_ui_model.dart';
import 'package:freecodecamp/models/main/user_model.dart';
import 'package:freecodecamp/service/authentication/authentication_service.dart';
import 'package:freecodecamp/service/learn/daily_challenge_service.dart';
import 'package:freecodecamp/ui/views/learn/widgets/daily_challenge_card.dart';
import 'package:mockito/mockito.dart';
import 'package:timezone/data/latest.dart' as tzdata;

import '../helpers/test_helpers.dart';
import '../helpers/test_helpers.mocks.dart';

void main() {
  // Mock service variables
  late MockDailyChallengeService mockDailyChallengeService;
  late MockAuthenticationService mockAuthenticationService;
  late MockNavigationService mockNavigationService;

  // Test data
  final testChallenge = DailyChallenge(
    id: 'test-challenge-id',
    challengeNumber: 1,
    date: DateTime(2025, 7, 26),
    title: 'Test Daily Challenge',
    description: 'A test challenge description',
    javascript: DailyChallengeLanguageData(
      tests: [],
      challengeFiles: [],
    ),
    python: DailyChallengeLanguageData(
      tests: [],
      challengeFiles: [],
    ),
  );

  final testUser = FccUserModel(
    id: 'test-user-id',
    email: 'test@example.com',
    username: 'testuser',
    name: 'Test User',
    picture: 'https://example.com/picture.jpg',
    currentChallengeId: '',
    githubProfile: null,
    linkedin: null,
    twitter: null,
    website: null,
    location: null,
    about: null,
    emailVerified: true,
    isEmailVerified: true,
    acceptedPrivacyTerms: true,
    sendQuincyEmail: false,
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
    is2018FullStackCert: false,
    isSciCompPyCertV7: false,
    isDataAnalysisPyCertV7: false,
    isMachineLearningPyCertV7: false,
    isRelationalDatabaseCertV8: false,
    isCollegeAlgebraPyCertV8: false,
    isFoundationalCSharpCertV8: false,
    isBanned: false,
    completedChallenges: [],
    completedDailyCodingChallenges: [],
    savedChallenges: [],
    portfolio: [],
    calendar: {},
    heatMapCal: {},
    profileUI: ProfileUI(
      isLocked: false,
      showAbout: true,
      showCerts: true,
      showDonation: false,
      showHeatMap: true,
      showLocation: true,
      showName: true,
      showPoints: false,
      showPortfolio: true,
      showTimeLine: false,
    ),
    joinDate: DateTime.now(),
    points: 0,
    yearsTopContributor: [],
    theme: Themes.defaultTheme,
  );

  final testUserWithCompletedChallenge = FccUserModel(
    id: 'test-user-id',
    email: 'test@example.com',
    username: 'testuser',
    name: 'Test User',
    picture: 'https://example.com/picture.jpg',
    currentChallengeId: '',
    githubProfile: null,
    linkedin: null,
    twitter: null,
    website: null,
    location: null,
    about: null,
    emailVerified: true,
    isEmailVerified: true,
    acceptedPrivacyTerms: true,
    sendQuincyEmail: false,
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
    is2018FullStackCert: false,
    isSciCompPyCertV7: false,
    isDataAnalysisPyCertV7: false,
    isMachineLearningPyCertV7: false,
    isRelationalDatabaseCertV8: false,
    isCollegeAlgebraPyCertV8: false,
    isFoundationalCSharpCertV8: false,
    isBanned: false,
    completedChallenges: [],
    completedDailyCodingChallenges: [
      CompletedDailyChallenge(
        id: 'test-challenge-id',
        completedDate: DateTime.now(),
        languages: ['javascript'],
      ),
    ],
    savedChallenges: [],
    portfolio: [],
    calendar: {},
    heatMapCal: {},
    profileUI: ProfileUI(
      isLocked: false,
      showAbout: true,
      showCerts: true,
      showDonation: false,
      showHeatMap: true,
      showLocation: true,
      showName: true,
      showPoints: false,
      showPortfolio: true,
      showTimeLine: false,
    ),
    joinDate: DateTime.now(),
    points: 0,
    yearsTopContributor: [],
    theme: Themes.defaultTheme,
  );

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    tzdata.initializeTimeZones();

    // Register services
    registerServices();
    mockDailyChallengeService = MockDailyChallengeService();
    mockAuthenticationService = MockAuthenticationService();
    mockNavigationService = getAndRegisterNavigationService();

    // Register the mocked services
    locator.unregister<DailyChallengeService>();
    locator.registerSingleton<DailyChallengeService>(mockDailyChallengeService);
    locator.unregister<AuthenticationService>();
    locator.registerSingleton<AuthenticationService>(mockAuthenticationService);
  });

  tearDown(() {
    locator.reset();
  });

  Widget createTestWidget() {
    return MaterialApp(
      home: Scaffold(
        body: DailyChallengeCard(),
      ),
      onGenerateRoute: (settings) {
        // Handle navigation routes used by the widget
        if (settings.name == '/challenge-template-view') {
          return MaterialPageRoute(
            builder: (context) => Scaffold(
              body: Center(child: Text('Challenge Template View')),
            ),
          );
        }
        return null;
      },
    );
  }

  testWidgets('should show loading indicator while fetching challenge',
      (WidgetTester tester) async {
    when(mockDailyChallengeService.fetchTodayChallenge()).thenAnswer((_) async {
      // Simulate a delay
      await Future.delayed(Duration(milliseconds: 100));
      return testChallenge;
    });
    when(mockAuthenticationService.userModel).thenAnswer((_) async => testUser);

    await tester.pumpWidget(createTestWidget());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Waiting to ensure the widget finishes its async work,
    // so that the test accurately reflects the UI's behavior and prevents false positives.
    await tester.pumpAndSettle();
  });

  testWidgets('should show error message when challenge fetch fails',
      (WidgetTester tester) async {
    when(mockDailyChallengeService.fetchTodayChallenge())
        .thenThrow(Exception('Network error'));

    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    expect(find.text('Failed to load today\'s challenge'), findsOneWidget);
  });

  testWidgets(
      'should show challenge details and allow navigation when not completed',
      (WidgetTester tester) async {
    when(mockDailyChallengeService.fetchTodayChallenge())
        .thenAnswer((_) async => testChallenge);
    when(mockAuthenticationService.userModel).thenAnswer((_) async => testUser);

    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    // Check UI elements
    expect(find.text('Today\'s challenge'), findsOneWidget);
    expect(find.text('Test Daily Challenge'), findsOneWidget);
    expect(find.text('Do you have the skills to complete this challenge?'),
        findsOneWidget);
    expect(find.text('Start the challenge'), findsOneWidget);
    expect(find.byIcon(Icons.arrow_forward_ios), findsOneWidget);

    // Test navigation
    await tester.tap(find.text('Start the challenge'));
    await tester.pumpAndSettle();
    expect(find.text('Challenge Template View'), findsOneWidget);
  });

  testWidgets(
      'should show completed state with timer and allow navigation to past challenges',
      (WidgetTester tester) async {
    when(mockDailyChallengeService.fetchTodayChallenge())
        .thenAnswer((_) async => testChallenge);
    when(mockAuthenticationService.userModel)
        .thenAnswer((_) async => testUserWithCompletedChallenge);

    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    // Check completed state UI
    expect(find.text('Today\'s challenge completed!'), findsOneWidget);
    expect(find.textContaining('Next challenge in:'), findsOneWidget);
    expect(find.text('View past challenges'), findsOneWidget);
    expect(find.byIcon(Icons.history), findsOneWidget);

    // Test timer format with regex
    final timerRegex = RegExp(r'^Next challenge in: \d{2}:\d{2}:\d{2}$');
    final timerFinder = find.byWidgetPredicate((widget) {
      if (widget is Text) {
        return timerRegex.hasMatch(widget.data ?? '');
      }
      return false;
    });
    expect(timerFinder, findsOneWidget);

    // Test navigation to past challenges
    await tester.tap(find.text('View past challenges'));
    await tester.pumpAndSettle();
    verify(mockNavigationService.navigateTo(Routes.dailyChallengesView))
        .called(1);
  });

  testWidgets('should handle user authentication states correctly',
      (WidgetTester tester) async {
    when(mockDailyChallengeService.fetchTodayChallenge())
        .thenAnswer((_) async => testChallenge);
    when(mockAuthenticationService.userModel).thenReturn(null);

    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    // Should show not completed state when user is not logged in
    expect(find.text('Today\'s challenge'), findsOneWidget);
    expect(find.text('Start the challenge'), findsOneWidget);
  });

  testWidgets('should have proper accessibility semantics',
      (WidgetTester tester) async {
    when(mockDailyChallengeService.fetchTodayChallenge())
        .thenAnswer((_) async => testChallenge);
    when(mockAuthenticationService.userModel).thenAnswer((_) async => testUser);

    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    final cardSemanticsFinder = find.byElementPredicate((element) {
      return element.widget is Semantics &&
          (element.widget as Semantics).properties.label ==
              'Daily challenge card';
    });

    final buttonSemanticsFinder = find.byElementPredicate((element) {
      return element.widget is Semantics &&
          (element.widget as Semantics).properties.label == 'Go to challenge';
    });

    expect(cardSemanticsFinder, findsOneWidget);
    expect(buttonSemanticsFinder, findsOneWidget);
  });

  testWidgets('should have live region semantics for timer in completed state',
      (WidgetTester tester) async {
    when(mockDailyChallengeService.fetchTodayChallenge())
        .thenAnswer((_) async => testChallenge);
    when(mockAuthenticationService.userModel)
        .thenAnswer((_) async => testUserWithCompletedChallenge);

    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    final semanticsWidgets =
        tester.widgetList<Semantics>(find.byType(Semantics));
    bool hasLiveRegion = false;

    for (final semantics in semanticsWidgets) {
      if (semantics.properties.liveRegion == true) {
        hasLiveRegion = true;
        break;
      }
    }

    expect(hasLiveRegion, isTrue,
        reason: 'Expected to find a Semantics widget with liveRegion: true');
  });

  testWidgets('should handle service exceptions gracefully',
      (WidgetTester tester) async {
    when(mockDailyChallengeService.fetchTodayChallenge())
        .thenThrow(Exception('Service unavailable'));

    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    expect(find.text('Failed to load today\'s challenge'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });
}
