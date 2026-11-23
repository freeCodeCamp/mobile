import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:freecodecamp/learn/models/challenge_model.dart';
import 'package:freecodecamp/learn/models/question_model.dart';
import 'package:freecodecamp/learn/services/quiz_service.dart';
import 'package:freecodecamp/learn/ui/challenge/quiz_viewmodel.dart';

const _challenge = Challenge(
  id: 'quiz',
  block: 'block',
  superBlock: 'course',
  title: 'Quiz',
  dashedName: 'quiz',
  challengeType: 8,
);

class _FixedQuizService extends LearnQuizService {
  var selections = 0;

  @override
  List<QuestionItem> pickQuestions(List<Quiz> quizzes) {
    selections++;
    return [
      for (var index = 0; index < 10; index++)
        QuestionItem(
          text: 'Question $index',
          answers: const [
            Answer(answer: 'Correct'),
            Answer(answer: 'Wrong'),
          ],
          solution: 0,
        ),
    ];
  }
}

class _Harness {
  final service = _FixedQuizService();
  late final container = ProviderContainer(
    overrides: [learnQuizServiceProvider.overrideWithValue(service)],
  )..listen(quizProvider(_challenge), (_, _) {});

  QuizNotifier get notifier =>
      container.read(quizProvider(_challenge).notifier);
  QuizState get state => container.read(quizProvider(_challenge));
  void dispose() => container.dispose();
}

void main() {
  test(
    'incomplete submission navigates to first unanswered and leaves results hidden',
    () {
      final harness = _Harness();
      addTearDown(harness.dispose);
      harness.notifier
        ..select(0, 0)
        ..select(2, 1)
        ..show(9);

      expect(harness.notifier.submit(), isFalse);
      expect(harness.state.current, 1);
      expect(harness.state.answered, 2);
      expect(harness.state.validated, isFalse);
      expect(harness.state.results, isEmpty);
      expect(harness.state.selected[2], 1);
    },
  );

  test('submission exposes grading and passes at the boundary', () {
    final harness = _Harness();
    addTearDown(harness.dispose);
    for (var index = 0; index < 10; index++) {
      harness.notifier.select(index, index == 9 ? 1 : 0);
    }

    expect(harness.notifier.submit(), isTrue);
    expect(harness.state.validated, isTrue);
    expect(harness.state.requiredCorrect, 9);
    expect(harness.state.correct, 9);
    expect(harness.state.results, [...List.filled(9, true), false]);
    expect(harness.state.passed, isTrue);
  });

  test(
    'retry clears answers and results while preserving the chosen set and order',
    () {
      final harness = _Harness();
      addTearDown(harness.dispose);
      final questions = harness.state.questions;
      for (var index = 0; index < 10; index++) {
        harness.notifier.select(index, 1);
      }
      harness.notifier
        ..show(9)
        ..submit();
      expect(harness.state.validated, isTrue);
      expect(harness.state.passed, isFalse);

      harness.notifier.reset();

      expect(harness.state.questions, questions);
      expect(harness.service.selections, 1);
      expect(harness.state.selected, List<int?>.filled(10, null));
      expect(harness.state.current, 0);
      expect(harness.state.validated, isFalse);
      expect(harness.state.results, isEmpty);
      expect(harness.state.correct, 0);
      expect(harness.state.passed, isFalse);
      expect(harness.state.requiredCorrect, 9);
      expect(
        harness.container.read(quizProvider(_challenge.copyWith())),
        harness.state,
      );
      expect(harness.service.selections, 1);
    },
  );
}
