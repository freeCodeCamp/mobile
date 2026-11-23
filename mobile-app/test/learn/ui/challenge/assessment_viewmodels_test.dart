import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:freecodecamp/learn/models/challenge_model.dart';
import 'package:freecodecamp/learn/services/assessment_service.dart';
import 'package:freecodecamp/learn/ui/challenge/english_viewmodel.dart';
import 'package:freecodecamp/learn/ui/challenge/lesson_viewmodel.dart';
import 'package:freecodecamp/learn/ui/challenge/python_project_viewmodel.dart';

const _challenge = Challenge(
  id: 'assessment',
  block: 'lesson',
  superBlock: 'course',
  title: 'Assessment',
  dashedName: 'assessment',
  challengeType: 22,
  assignments: ['Read the lesson'],
  fillInTheBlank: FillInTheBlank(
    sentence: 'BLANK',
    blanks: [Blank(answer: 'Hello')],
  ),
  questions: [
    Question(
      text: 'Choose',
      answers: [
        Answer(answer: 'yes'),
        Answer(answer: 'no'),
      ],
      solution: 1,
    ),
  ],
);

class _FakeAssessmentService extends LearnAssessmentService {
  int blankChecks = 0;
  int linkChecks = 0;

  @override
  ({List<bool> results, bool passed, String feedback}) checkBlanks(
    List<Blank> blanks,
    List<String> answers,
  ) {
    blankChecks++;
    return (results: [true], passed: true, feedback: 'service feedback');
  }

  @override
  String? projectLinkError(String link) {
    linkChecks++;
    return link == 'https://accepted.example' ? null : 'service rejection';
  }
}

void main() {
  test(
    'English delegates grading, gates assignments and clears stale results on edit',
    () {
      final service = _FakeAssessmentService();
      final container = ProviderContainer.test(
        overrides: [learnAssessmentServiceProvider.overrideWithValue(service)],
      );
      final provider = englishChallengeProvider(_challenge);
      container.listen(provider, (_, _) {});
      final notifier = container.read(provider.notifier);
      notifier.checkAnswers();
      expect(service.blankChecks, 0);
      expect(container.read(provider).assignmentsDone, isFalse);
      notifier.toggleAssignment(0);
      expect(container.read(provider).assignmentsDone, isTrue);
      notifier.updateAnswer(0, 'any input');
      notifier.checkAnswers();
      expect(service.blankChecks, 1);
      expect(container.read(provider).allCorrect, isTrue);
      expect(container.read(provider).feedback, 'service feedback');
      notifier.updateAnswer(0, '   ');
      expect(container.read(provider).results, isNull);
      expect(container.read(provider).allCorrect, isFalse);
      expect(container.read(provider).canCheck, isFalse);
    },
  );

  test(
    'lesson needs checked correct answers and rechecks after changing a selection',
    () {
      final container = ProviderContainer.test(
        overrides: [
          learnAssessmentServiceProvider.overrideWithValue(
            _FakeAssessmentService(),
          ),
        ],
      );
      final provider = lessonChallengeProvider(_challenge);
      container.listen(provider, (_, _) {});
      final notifier = container.read(provider.notifier);
      notifier.selectAnswer(0, 0);
      expect(container.read(provider).passed, isFalse);
      notifier.checkAnswer(0);
      expect(container.read(provider).passed, isTrue);
      expect(container.read(provider).assignmentsDone, isFalse);
      notifier.toggleAssignment(0);
      expect(container.read(provider).assignmentsDone, isTrue);
      notifier.selectAnswer(0, 1);
      expect(container.read(provider).checked, [false]);
      expect(container.read(provider).passed, isFalse);
      notifier.checkAnswer(0);
      expect(container.read(provider).results, [false]);
    },
  );

  test(
    'project validation uses service and editing invalidates accepted URLs',
    () {
      final service = _FakeAssessmentService();
      final container = ProviderContainer.test(
        overrides: [learnAssessmentServiceProvider.overrideWithValue(service)],
      );
      final provider = pythonProjectProvider(_challenge);
      container.listen(provider, (_, _) {});
      final notifier = container.read(provider.notifier);
      notifier.checkLink();
      expect(service.linkChecks, 0);
      notifier.updateLink('  https://accepted.example  ');
      notifier.checkLink();
      expect(container.read(provider).link, 'https://accepted.example');
      expect(container.read(provider).valid, isTrue);
      notifier.updateLink('https://rejected.example');
      expect(container.read(provider).valid, isFalse);
      expect(container.read(provider).error, isNull);
      notifier.checkLink();
      expect(container.read(provider).error, 'service rejection');
      expect(service.linkChecks, 2);
    },
  );
}
