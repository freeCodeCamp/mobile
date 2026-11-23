import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:freecodecamp/auth/models/user_model.dart';
import 'package:freecodecamp/fcc_theme.dart';
import 'package:freecodecamp/learn/models/challenge_model.dart';
import 'package:freecodecamp/learn/models/curriculum_model.dart';
import 'package:freecodecamp/learn/services/quiz_service.dart';
import 'package:freecodecamp/learn/ui/challenge/english_view.dart';
import 'package:freecodecamp/learn/ui/challenge/lesson_view.dart';
import 'package:freecodecamp/learn/ui/challenge/python_project_view.dart';
import 'package:freecodecamp/learn/ui/challenge/quiz_view.dart';
import 'package:freecodecamp/learn/ui/challenge/widgets/answer_feedback.dart';
import 'package:freecodecamp/learn/ui/challenge/widgets/challenge_button.dart';
import 'package:freecodecamp/learn/ui/challenge/widgets/complete_button.dart';
import 'package:freecodecamp/learn/ui/challenge/widgets/questions.dart';
import 'package:freecodecamp/learn/ui/challenge/widgets/quiz_result_card.dart';
import 'package:freecodecamp/services/auth_service.dart';
import 'package:integration_test/integration_test.dart';

const _base = Challenge(
  id: 'assessment',
  block: 'assessment-block',
  superBlock: 'assessment-course',
  title: 'Assessment',
  dashedName: 'assessment',
  challengeType: 8,
);

Block _block(Challenge challenge) => Block(
  superBlock: challenge.superBlock,
  dashedName: challenge.block,
  name: 'Assessment practice',
  layout: BlockLayout.challengeList,
  label: BlockLabel.practice,
  description: const [],
  challenges: [ChallengeOrder(id: challenge.id, title: challenge.title)],
);

class _GuestAuth extends AuthNotifier {
  @override
  Future<FccUserModel?> build() async => null;
}

Future<void> _settle(WidgetTester tester) async {
  await tester.pumpAndSettle(
    const Duration(milliseconds: 100),
    EnginePhase.sendSemanticsUpdate,
    const Duration(seconds: 10),
  );
}

Future<void> _mount(WidgetTester tester, Widget screen) async {
  await tester.pumpWidget(
    ProviderScope(
      key: UniqueKey(),
      overrides: [
        authProvider.overrideWith(_GuestAuth.new),
        learnQuizServiceProvider.overrideWithValue(
          LearnQuizService(random: Random(7)),
        ),
      ],
      child: MaterialApp(theme: FccTheme.themeLight, home: screen),
    ),
  );
  await _settle(tester);
}

Finder _button(String label) => find.byWidgetPredicate(
  (widget) => widget is ChallengeButton && widget.label == label,
);

Future<void> _tapButton(WidgetTester tester, String label) async {
  final button = _button(label);
  expect(button, findsOneWidget);
  expect(tester.widget<ChallengeButton>(button).onPressed, isNotNull);
  await tester.ensureVisible(button);
  await tester.tap(button);
  await _settle(tester);
}

Future<void> _answer(WidgetTester tester, int index) async {
  final questions = tester.widget<Questions>(find.byType(Questions));
  final current = questions.currentIndex ?? 0;
  final options = find.descendant(
    of: find.byType(Questions),
    matching: find.byType(InkWell),
  );
  expect(options, findsNWidgets(questions.questions[current].answers.length));
  await tester.ensureVisible(options.at(index));
  await tester.tap(options.at(index));
  await _settle(tester);
}

Future<void> _enter(WidgetTester tester, String value) async {
  final field = find.byType(TextField);
  expect(field, findsOneWidget);
  await tester.ensureVisible(field);
  // enterText caches the last editable; a tap reopens its native input connection after unfocus.
  await tester.tap(field);
  await _settle(tester);
  await tester.enterText(field, value);
  await tester.pump();
  expect(tester.widget<TextField>(field).controller?.text, value);
  FocusManager.instance.primaryFocus?.unfocus();
  await _settle(tester);
  expect(tester.widget<TextField>(field).controller?.text, value);
}

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  final results = <Map<String, Object?>>[];

  Future<void> record(String name, Future<void> Function() run) async {
    try {
      await run();
      results.add({'case': name, 'passed': true});
    } catch (error) {
      results.add({'case': name, 'passed': false, 'error': error.toString()});
      rethrow;
    } finally {
      binding.reportData = {'challengeAssessments': results};
    }
  }

  testWidgets('quiz requires answers and preserves its set when retrying', (
    tester,
  ) async {
    await record('quiz', () async {
      final challenge = _base.copyWith(
        id: 'quiz',
        quizzes: const [
          Quiz(
            questions: [
              QuizQuestion(
                text: 'Which value is two?',
                answer: '2',
                distractors: ['3'],
              ),
            ],
          ),
        ],
      );
      await _mount(
        tester,
        QuizView(challenge: challenge, block: _block(challenge)),
      );
      final original = tester
          .widget<Questions>(find.byType(Questions))
          .questions;
      final correct = original.single.solution;

      await _tapButton(tester, 'Submit quiz');
      expect(find.byType(QuizResultCard), findsNothing);
      expect(find.byType(SnackBar), findsOneWidget);
      expect(tester.widget<Questions>(find.byType(Questions)).selected, [null]);

      await _answer(tester, 1 - correct);
      await _tapButton(tester, 'Submit quiz');
      final failed = tester.widget<QuizResultCard>(find.byType(QuizResultCard));
      expect(failed.passed, isFalse);
      expect(failed.correct, 0);
      expect(failed.requiredCorrect, 1);

      await _tapButton(tester, 'Try again');
      final reset = tester.widget<Questions>(find.byType(Questions));
      expect(reset.questions, original);
      expect(reset.selected, [null]);
      expect(find.byType(QuizResultCard), findsNothing);

      await _answer(tester, correct);
      await _tapButton(tester, 'Submit quiz');
      final passed = tester.widget<QuizResultCard>(find.byType(QuizResultCard));
      expect(passed.passed, isTrue);
      expect(passed.correct, 1);
      expect(
        tester.widget<CompleteButton>(find.byType(CompleteButton)).enabled,
        isTrue,
      );
      expect(tester.takeException(), isNull);
    });
  });

  testWidgets(
    'English accepts normalized answers and clears grading on edits',
    (tester) async {
      await record('english', () async {
        final dialogue = _base.copyWith(id: 'dialogue', challengeType: 21);
        await _mount(
          tester,
          EnglishView(challenge: dialogue, block: _block(dialogue)),
        );
        expect(find.byType(TextField), findsNothing);
        await tester.pumpWidget(const SizedBox.shrink());
        await _settle(tester);
        expect(tester.takeException(), isNull);

        final challenge = _base.copyWith(
          id: 'english',
          challengeType: 22,
          fillInTheBlank: const FillInTheBlank(
            sentence: 'Say BLANK.',
            blanks: [Blank(answer: 'Hello', feedback: 'Use the greeting.')],
          ),
        );
        await _mount(
          tester,
          EnglishView(challenge: challenge, block: _block(challenge)),
        );
        expect(
          tester.widget<ChallengeButton>(_button('Check answer')).onPressed,
          isNull,
        );

        await _enter(tester, '  hELLo  ');
        await _tapButton(tester, 'Check answer');
        expect(
          tester.widget<AnswerFeedback>(find.byType(AnswerFeedback)).correct,
          isTrue,
        );
        expect(find.byType(CompleteButton), findsOneWidget);

        await _enter(tester, 'Goodbye');
        expect(find.byType(AnswerFeedback), findsNothing);
        expect(find.byType(CompleteButton), findsNothing);
        await _tapButton(tester, 'Check answer');
        expect(
          tester.widget<AnswerFeedback>(find.byType(AnswerFeedback)).correct,
          isFalse,
        );
        expect(tester.takeException(), isNull);
      });
    },
  );

  testWidgets('lesson selection must be checked before completion', (
    tester,
  ) async {
    await record('lesson', () async {
      final challenge = _base.copyWith(
        id: 'lesson',
        challengeType: 19,
        description: '<p>Read the question and check your answer.</p>',
        questions: const [
          Question(
            text: 'Which word is a greeting?',
            answers: [
              Answer(answer: 'Hello'),
              Answer(answer: 'Goodbye'),
            ],
            solution: 1,
          ),
        ],
      );
      await _mount(
        tester,
        LessonView(challenge: challenge, block: _block(challenge)),
      );
      await _tapButton(tester, 'Continue to questions');
      expect(
        tester.widget<ChallengeButton>(_button('Check answer')).onPressed,
        isNull,
      );

      await _answer(tester, 0);
      expect(find.byType(CompleteButton), findsNothing);
      expect(
        tester.widget<Questions>(find.byType(Questions)).validated,
        isFalse,
      );
      await _tapButton(tester, 'Check answer');
      expect(
        tester.widget<AnswerFeedback>(find.byType(AnswerFeedback)).correct,
        isTrue,
      );
      expect(find.byType(CompleteButton), findsOneWidget);

      await _answer(tester, 1);
      expect(find.byType(CompleteButton), findsNothing);
      expect(
        tester.widget<Questions>(find.byType(Questions)).validated,
        isFalse,
      );
      await _tapButton(tester, 'Check answer');
      expect(
        tester.widget<AnswerFeedback>(find.byType(AnswerFeedback)).correct,
        isFalse,
      );
      expect(tester.takeException(), isNull);
    });
  });

  testWidgets(
    'project validates public secure links and clears approval on edits',
    (tester) async {
      await record('project', () async {
        final challenge = _base.copyWith(id: 'project', challengeType: 10);
        await _mount(
          tester,
          PythonProjectView(challenge: challenge, block: _block(challenge)),
        );
        expect(
          tester.widget<ChallengeButton>(_button('Check link')).onPressed,
          isNull,
        );

        for (final (url, message) in [
          (
            'https://localhost/project',
            'Remember to submit a publicly visible app URL.',
          ),
          ('http://example.org/project', 'Please use a secure (https) URL.'),
          (
            'https://freecodecamp.org/project',
            'Remember to submit your own work.',
          ),
        ]) {
          await _enter(tester, url);
          await _tapButton(tester, 'Check link');
          expect(
            tester
                .widget<TextField>(find.byType(TextField))
                .decoration
                ?.errorText,
            message,
          );
          expect(find.byType(CompleteButton), findsNothing);
        }

        await _enter(tester, '  https://example.org/my-project  ');
        await _tapButton(tester, 'Check link');
        final complete = tester.widget<CompleteButton>(
          find.byType(CompleteButton),
        );
        expect(complete.solution, 'https://example.org/my-project');
        expect(complete.enabled, isTrue);

        await _enter(tester, 'https://localhost/changed');
        expect(find.byType(CompleteButton), findsNothing);
        expect(
          tester
              .widget<TextField>(find.byType(TextField))
              .decoration
              ?.errorText,
          isNull,
        );
        expect(tester.takeException(), isNull);
      });
    },
  );
}
