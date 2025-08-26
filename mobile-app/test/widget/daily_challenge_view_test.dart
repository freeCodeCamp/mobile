import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/models/learn/daily_challenge_model.dart';
import 'package:freecodecamp/models/main/user_model.dart';
import 'package:freecodecamp/service/authentication/authentication_service.dart';
import 'package:freecodecamp/service/learn/daily_challenge_service.dart';
import 'package:freecodecamp/ui/views/learn/daily_challenge/daily_challenge_view.dart';
import 'package:mockito/mockito.dart';

import '../helpers/test_helpers.dart';
import '../helpers/test_helpers.mocks.dart';

void main() {
  group('DailyChallengeView Widget Tests', () {
    late MockDailyChallengeService mockDailyChallengeService;
    late MockAuthenticationService mockAuthService;

    setUp(() {
      registerServices();

      mockDailyChallengeService =
          locator<DailyChallengeService>() as MockDailyChallengeService;
      mockAuthService =
          locator<AuthenticationService>() as MockAuthenticationService;

      when(mockDailyChallengeService.fetchAllDailyChallenges())
          .thenAnswer((_) async => <DailyChallengeOverview>[]);

      when(mockAuthService.progress)
          .thenAnswer((_) => StreamController<bool>());

      mockAuthService.userModel = null;
    });

    tearDown(() {
      locator.reset();
    });

    Widget createTestWidget() {
      return const MaterialApp(
        home: DailyChallengeView(),
      );
    }

    testWidgets('should display app bar with correct title', (tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.pump();

      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('Daily Coding Challenges'), findsOneWidget);
    });

    testWidgets('should show empty state when no challenges', (tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.pumpAndSettle();

      expect(
          find.text('No challenges available at the moment.'), findsOneWidget);
    });

    testWidgets('should display challenges when service returns data',
        (tester) async {
      reset(mockDailyChallengeService);
      reset(mockAuthService);

      when(mockAuthService.progress)
          .thenAnswer((_) => StreamController<bool>());

      mockAuthService.userModel = null;

      final testChallenges = [
        // March 2025 challenges
        DailyChallengeOverview(
          id: 'mar-1',
          challengeNumber: 3,
          date: DateTime(2025, 3, 15),
          title: 'March Challenge 3',
        ),
        DailyChallengeOverview(
          id: 'mar-2',
          challengeNumber: 1,
          date: DateTime(2025, 3, 1),
          title: 'March Challenge 1',
        ),
        DailyChallengeOverview(
          id: 'mar-3',
          challengeNumber: 2,
          date: DateTime(2025, 3, 10),
          title: 'March Challenge 2',
        ),

        // February 2025 challenges
        DailyChallengeOverview(
          id: 'feb-1',
          challengeNumber: 1,
          date: DateTime(2025, 2, 1),
          title: 'February Challenge 1',
        ),
        DailyChallengeOverview(
          id: 'feb-2',
          challengeNumber: 2,
          date: DateTime(2025, 2, 15),
          title: 'February Challenge 2',
        ),
      ];

      when(mockDailyChallengeService.fetchAllDailyChallenges())
          .thenAnswer((_) async => testChallenges);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('March 2025'), findsOneWidget);
      expect(find.text('February 2025'), findsOneWidget);

      // Test month ordering: March should appear first (newest)
      final marchPosition = tester.getTopLeft(find.text('March 2025'));
      final februaryPosition = tester.getTopLeft(find.text('February 2025'));

      expect(marchPosition.dy < februaryPosition.dy, isTrue,
          reason: 'March should appear before February');

      // March block is open by default and its challenges are visible
      expect(find.text('Challenge 3: March Challenge 3'), findsOneWidget);
      expect(find.text('Challenge 2: March Challenge 2'), findsOneWidget);
      expect(find.text('Challenge 1: March Challenge 1'), findsOneWidget);

      // Scroll down to make the February block fully visible
      // Target the main ListView by finding the one that contains the month headers
      final mainListView = find.ancestor(
        of: find.text('March 2025'),
        matching: find.byType(ListView),
      );
      await tester.drag(mainListView, const Offset(0, -300));
      await tester.pumpAndSettle();

      // Find the "Show Challenges" button for February
      final showFebButton = find.text('Show Challenges');
      expect(showFebButton, findsOneWidget);

      // Tap the button to reveal February's challenges
      await tester.tap(showFebButton);
      await tester.pumpAndSettle();

      // Assert that February's challenges are now visible
      expect(find.text('Challenge 2: February Challenge 2'), findsOneWidget);
      expect(find.text('Challenge 1: February Challenge 1'), findsOneWidget);
    });

    testWidgets(
        'should order challenges within month by challengeNumber descending',
        (tester) async {
      reset(mockDailyChallengeService);
      reset(mockAuthService);

      when(mockAuthService.progress)
          .thenAnswer((_) => StreamController<bool>());

      mockAuthService.userModel = null;

      final testChallenges = [
        DailyChallengeOverview(
          id: 'challenge-1',
          challengeNumber: 1,
          date: DateTime(2025, 2, 1),
          title: 'Challenge 1',
        ),
        DailyChallengeOverview(
          id: 'challenge-3',
          challengeNumber: 3,
          date: DateTime(2025, 2, 15),
          title: 'Challenge 3',
        ),
        DailyChallengeOverview(
          id: 'challenge-2',
          challengeNumber: 2,
          date: DateTime(2025, 2, 10),
          title: 'Challenge 2',
        ),
      ];

      when(mockDailyChallengeService.fetchAllDailyChallenges())
          .thenAnswer((_) async => testChallenges);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Verify the ordering by checking vertical positions
      final challenge3Position =
          tester.getTopLeft(find.text('Challenge 3: Challenge 3'));
      final challenge2Position =
          tester.getTopLeft(find.text('Challenge 2: Challenge 2'));
      final challenge1Position =
          tester.getTopLeft(find.text('Challenge 1: Challenge 1'));

      expect(challenge3Position.dy < challenge2Position.dy, isTrue,
          reason: 'Challenge 3 should appear before Challenge 2');
      expect(challenge2Position.dy < challenge1Position.dy, isTrue,
          reason: 'Challenge 2 should appear before Challenge 1');
    });

    testWidgets('should show completion state when user is logged in',
        (tester) async {
      reset(mockDailyChallengeService);
      reset(mockAuthService);

      when(mockAuthService.progress)
          .thenAnswer((_) => StreamController<bool>());

      final testChallenges = [
        DailyChallengeOverview(
          id: 'challenge-1',
          challengeNumber: 1,
          date: DateTime(2025, 2, 1),
          title: 'Foo',
        ),
        DailyChallengeOverview(
          id: 'challenge-2',
          challengeNumber: 2,
          date: DateTime(2025, 2, 2),
          title: 'Bar',
        ),
      ];

      final testUserJson = {
        'id': 'test-user-id',
        'email': 'test@example.com',
        'username': 'testuser',
        'name': 'Test User',
        'picture': '',
        'currentChallengeId': '',
        'githubProfile': '',
        'linkedin': '',
        'twitter': '',
        'website': '',
        'location': '',
        'about': '',
        'emailVerified': true,
        'isEmailVerified': true,
        'acceptedPrivacyTerms': true,
        'sendQuincyEmail': false,
        'isCheater': false,
        'isDonating': false,
        'isHonest': true,
        'isFrontEndCert': false,
        'isDataVisCert': false,
        'isBackEndCert': false,
        'isFullStackCert': false,
        'isRespWebDesignCert': false,
        'is2018DataVisCert': false,
        'isFrontEndLibsCert': false,
        'isJsAlgoDataStructCert': false,
        'isApisMicroservicesCert': false,
        'isInfosecQaCert': false,
        'isQaCertV7': false,
        'isInfosecCertV7': false,
        'is2018FullStackCert': false,
        'isSciCompPyCertV7': false,
        'isDataAnalysisPyCertV7': false,
        'isMachineLearningPyCertV7': false,
        'isRelationalDatabaseCertV8': false,
        'isCollegeAlgebraPyCertV8': false,
        'isFoundationalCSharpCertV8': false,
        'isBanned': false,
        'joinDate': '2025-01-01T00:00:00.000Z',
        'points': 0,
        'calendar': {},
        'completedChallenges': [],
        'completedDailyCodingChallenges': [
          {
            'id': 'challenge-1',
            'completedDate': DateTime(2025, 2, 1).millisecondsSinceEpoch,
            'languages': ['javascript'],
          }
        ],
        'savedChallenges': [],
        'portfolio': [],
        'yearsTopContributor': [],
        'theme': 'default',
        'profileUI': {
          'isLocked': false,
          'showAbout': true,
          'showCerts': true,
          'showDonation': true,
          'showHeatMap': true,
          'showLocation': true,
          'showName': true,
          'showPoints': true,
          'showPortfolio': true,
          'showTimeLine': true,
        },
      };

      final testUser = FccUserModel.fromJson(testUserJson);

      when(mockDailyChallengeService.fetchAllDailyChallenges())
          .thenAnswer((_) async => testChallenges);

      when(mockAuthService.userModel).thenAnswer((_) async => testUser);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(
        find.bySemanticsLabel('Challenge 1: Foo, completed'),
        findsOneWidget,
      );
      expect(
        find.bySemanticsLabel('Challenge 2: Bar, not completed'),
        findsOneWidget,
      );
    });

    testWidgets('should show no completion state when user is not logged in',
        (tester) async {
      reset(mockDailyChallengeService);
      reset(mockAuthService);

      when(mockAuthService.progress)
          .thenAnswer((_) => StreamController<bool>());

      final testChallenges = [
        DailyChallengeOverview(
          id: 'challenge-1',
          challengeNumber: 1,
          date: DateTime(2025, 2, 1),
          title: 'Challenge 1',
        ),
      ];

      when(mockDailyChallengeService.fetchAllDailyChallenges())
          .thenAnswer((_) async => testChallenges);

      mockAuthService.userModel = null;

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(
        find.bySemanticsLabel('Challenge 1: Challenge 1, not completed'),
        findsOneWidget,
      );
    });

    testWidgets('should handle service errors gracefully', (tester) async {
      reset(mockDailyChallengeService);
      reset(mockAuthService);

      when(mockAuthService.progress)
          .thenAnswer((_) => StreamController<bool>());

      when(mockDailyChallengeService.fetchAllDailyChallenges())
          .thenThrow(Exception('Network error'));

      mockAuthService.userModel = null;

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(
          find.text('No challenges available at the moment.'), findsOneWidget);
    });
  });
}
