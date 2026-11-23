import 'package:flutter_test/flutter_test.dart';
import 'package:freecodecamp/learn/models/challenge_model.dart';
import 'package:freecodecamp/learn/services/assessment_service.dart';

const _challenge = Challenge(
  id: 'assessment',
  block: 'lesson',
  superBlock: 'course',
  title: 'Assessment',
  dashedName: 'assessment',
  challengeType: 19,
);

void main() {
  const service = LearnAssessmentService();

  test(
    'blank answers ignore case and input whitespace and report first error',
    () {
      const blanks = [
        Blank(answer: 'Hello', feedback: 'Use a greeting.'),
        Blank(answer: 'world', feedback: 'Name the planet.'),
      ];
      final passed = service.checkBlanks(blanks, ['  hELLo  ', 'WORLD']);
      expect(passed.results, [true, true]);
      expect(passed.passed, isTrue);
      expect(passed.feedback, isEmpty);

      final failed = service.checkBlanks(blanks, ['goodbye', 'moon']);
      expect(failed.results, [false, false]);
      expect(failed.passed, isFalse);
      expect(failed.feedback, 'Use a greeting.');
      expect(service.hasAnswers(['Hello', '   ']), isFalse);
    },
  );

  test(
    'lesson answers retain one-based solutions and require explicit checks',
    () {
      final questions = service.lessonQuestions(
        _challenge.copyWith(
          questions: const [
            Question(
              text: 'Choose two',
              answers: [
                Answer(answer: 'one'),
                Answer(answer: 'two'),
              ],
              solution: 2,
            ),
            Question(
              text: 'Choose one',
              answers: [
                Answer(answer: 'one'),
                Answer(answer: 'two'),
              ],
              solution: 1,
            ),
          ],
        ),
      );
      expect(questions.map((question) => question.solution), [1, 0]);
      final unchecked = service.checkLessonAnswers(
        questions,
        [1, 0],
        [true, false],
      );
      expect(unchecked, [true, false]);
      expect(service.lessonPassed(unchecked), isFalse);
      expect(service.firstPendingQuestion(unchecked), 1);
      expect(
        service.lessonPassed(
          service.checkLessonAnswers(questions, [1, 0], [true, true]),
        ),
        isTrue,
      );
      expect(
        service.lessonPassed(
          service.checkLessonAnswers(questions, [0, 0], [true, true]),
        ),
        isFalse,
      );
    },
  );

  test(
    'reading completion preserves assignments and review acknowledgement',
    () {
      expect(service.canCompleteReading(_challenge, [], false), isTrue);
      expect(service.canCompleteReading(_challenge, [false], true), isFalse);
      final review = _challenge.copyWith(challengeType: 31);
      expect(service.canCompleteReading(review, [], false), isFalse);
      expect(service.canCompleteReading(review, [], true), isTrue);
      expect(service.canCompleteReading(review, [true], false), isTrue);
    },
  );

  test('project links preserve public HTTPS and own-work validation', () {
    for (final link in [
      'https://example.com/app',
      'https://github.com/learner/app',
      'https://freecodecamp.org.example.com',
    ]) {
      expect(service.projectLinkError(link), isNull, reason: link);
    }
    for (final link in [
      'invalid',
      'file:///tmp/app',
      'http://example.com',
      'https://localhost/app',
      'https://app.localhost',
      'https://127.0.0.1',
      'https://freecodecamp.org',
      'https://www.freecodecamp.rocks',
      'https://github.com/freeCodeCamp/project',
      'https://codepen.io/freecodecamp/pen/demo',
    ]) {
      expect(service.projectLinkError(link), isNotNull, reason: link);
    }
  });
}
