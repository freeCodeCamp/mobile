import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/app/app.router.dart';
import 'package:freecodecamp/models/learn/daily_challenge_model.dart';
import 'package:freecodecamp/ui/views/learn/widgets/daily_challenge_card.dart';
import 'package:mockito/mockito.dart';
import 'package:timezone/data/latest.dart' as tzdata;

import '../helpers/test_helpers.dart';
import '../helpers/test_helpers.mocks.dart';

void main() {
  // Mock service variables
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

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    tzdata.initializeTimeZones();

    // Register services
    registerServices();
    mockNavigationService = getAndRegisterNavigationService();
  });

  tearDown(() {
    locator.reset();
  });

  Widget createTestWidget({
    DailyChallenge? challenge,
    bool isCompleted = false,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: DailyChallengeCard(
          dailyChallenge: challenge,
          isCompleted: isCompleted,
        ),
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

  testWidgets('should return empty widget when no challenge is provided',
      (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());

    expect(find.byType(DailyChallengeCard), findsOneWidget);
    expect(find.text('Today\'s challenge'), findsNothing);
    expect(find.text('Start the challenge'), findsNothing);
  });

  testWidgets(
      'should show challenge details when challenge is provided and not completed',
      (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget(
      challenge: testChallenge,
      isCompleted: false,
    ));

    expect(find.text('Today\'s challenge'), findsOneWidget);
    expect(find.text('Test Daily Challenge'), findsOneWidget);
    expect(find.text('Do you have the skills to complete this challenge?'),
        findsOneWidget);
    expect(find.text('Start the challenge'), findsOneWidget);
    expect(find.byIcon(Icons.arrow_forward_ios), findsOneWidget);

    // Test navigation to the challenge
    await tester.tap(find.text('Start the challenge'));
    await tester.pumpAndSettle();
    expect(find.text('Challenge Template View'), findsOneWidget);
  });

  testWidgets(
      'should show completed state with timer and allow navigation to past challenges',
      (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget(
      challenge: testChallenge,
      isCompleted: true,
    ));

    expect(find.text('Today\'s challenge completed!'), findsOneWidget);
    expect(find.textContaining('Next challenge in:'), findsOneWidget);
    expect(find.text('View past challenges'), findsOneWidget);
    expect(find.byIcon(Icons.history), findsOneWidget);

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
    verify(mockNavigationService.navigateTo(Routes.dailyChallengeView))
        .called(1);
  });

  testWidgets(
      'should have proper accessibility semantics for not completed state',
      (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget(
      challenge: testChallenge,
      isCompleted: false,
    ));

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

  testWidgets('should have proper accessibility semantics for completed state',
      (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget(
      challenge: testChallenge,
      isCompleted: true,
    ));

    final cardSemanticsFinder = find.byElementPredicate((element) {
      return element.widget is Semantics &&
          (element.widget as Semantics).properties.label ==
              'Daily challenge completed. View past challenges.';
    });

    expect(cardSemanticsFinder, findsOneWidget);
  });

  testWidgets('should have live region semantics for timer in completed state',
      (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget(
      challenge: testChallenge,
      isCompleted: true,
    ));

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

  testWidgets('should display countdown timer in completed state',
      (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget(
      challenge: testChallenge,
      isCompleted: true,
    ));

    final timerRegex = RegExp(r'^Next challenge in: \d{2}:\d{2}:\d{2}$');
    final timerFinder = find.byWidgetPredicate((widget) {
      if (widget is Text) {
        return timerRegex.hasMatch(widget.data ?? '');
      }
      return false;
    });

    expect(timerFinder, findsOneWidget);

    // Check that timer text contains expected format
    final timerWidget = tester.widget<Text>(timerFinder);
    expect(timerWidget.data, matches(timerRegex));
  });
}
