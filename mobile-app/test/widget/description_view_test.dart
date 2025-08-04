import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/ui/views/learn/challenge/challenge_viewmodel.dart';
import 'package:freecodecamp/ui/views/learn/widgets/description/description_widget_view.dart';
import 'package:mockito/mockito.dart';

import '../helpers/test_helpers.dart';
import '../helpers/test_helpers.mocks.dart';

void main() {
  group('DescriptionView Widget Tests', () {
    late MockNavigationService mockNavigationService;
    late MockDialogService mockDialogService;

    setUp(() {
      registerServices();
      mockNavigationService = getAndRegisterNavigationService();
      mockDialogService = getAndRegisterDialogService();
    });

    tearDown(() {
      locator.reset();
    });

    Widget createTestWidget({
      required String title,
      String description = '<p>Test description</p>',
      String instructions = '<p>Test instructions</p>',
      int maxChallenges = 10,
    }) {
      // Create a simple mock ChallengeViewModel for testing
      final mockChallengeModel = MockChallengeViewModel();
      
      return MaterialApp(
        home: Scaffold(
          body: DescriptionView(
            title: title,
            description: description,
            instructions: instructions,
            challengeModel: mockChallengeModel,
            maxChallenges: maxChallenges,
          ),
        ),
      );
    }

    testWidgets('should display challenge title instead of "Instructions"', (tester) async {
      const testTitle = 'Test Challenge Title';
      
      await tester.pumpWidget(createTestWidget(title: testTitle));
      await tester.pumpAndSettle();

      // Verify that the challenge title is displayed
      expect(find.text(testTitle), findsOneWidget);
      
      // Verify that "Instructions" is NOT displayed
      expect(find.text('Instructions'), findsNothing);
    });

    testWidgets('should handle long challenge titles with ellipsis', (tester) async {
      const longTitle = 'This is a very long challenge title that should trigger text overflow handling with ellipsis';
      
      await tester.pumpWidget(createTestWidget(title: longTitle));
      await tester.pumpAndSettle();

      // Find the Text widget containing our title
      final titleWidget = tester.widget<Text>(find.text(longTitle));
      
      // Verify that overflow handling is set
      expect(titleWidget.overflow, TextOverflow.ellipsis);
      expect(titleWidget.maxLines, 2);
    });

    testWidgets('should display step count for multi-step challenges', (tester) async {
      const stepTitle = 'Step 5';
      const maxChallenges = 10;
      
      await tester.pumpWidget(createTestWidget(
        title: stepTitle,
        maxChallenges: maxChallenges,
      ));
      await tester.pumpAndSettle();

      // Verify that the step title is displayed
      expect(find.text(stepTitle), findsOneWidget);
      
      // Verify that step count is displayed (this uses localization, so we check for number patterns)
      expect(find.textContaining('5'), findsAtLeastNWidget(1));
      expect(find.textContaining('10'), findsAtLeastNWidget(1));
    });

    testWidgets('should not display step count for non-step challenges', (tester) async {
      const regularTitle = 'Regular Challenge Title';
      
      await tester.pumpWidget(createTestWidget(title: regularTitle));
      await tester.pumpAndSettle();

      // Verify that the title is displayed
      expect(find.text(regularTitle), findsOneWidget);
      
      // Verify that no step count information is shown
      expect(find.textContaining('Step'), findsNothing);
    });
  });
}

// Mock class for ChallengeViewModel - minimal implementation for testing
class MockChallengeViewModel extends Mock implements ChallengeViewModel {}