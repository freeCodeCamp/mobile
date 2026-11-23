import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:freecodecamp/learn/models/challenge_model.dart';
import 'package:freecodecamp/learn/models/question_model.dart';
import 'package:freecodecamp/learn/services/quiz_service.dart';

const _question = QuestionItem(
  text: 'Question',
  answers: [
    Answer(answer: 'Wrong'),
    Answer(answer: 'Correct'),
  ],
  solution: 1,
);

void main() {
  test('grading passes at ninety percent and rounds the threshold up', () {
    final service = LearnQuizService();
    for (final (count, required) in [(10, 9), (11, 10), (1, 1)]) {
      final questions = List.filled(count, _question);
      final boundary = [
        ...List<int?>.filled(required, 1),
        ...List<int?>.filled(count - required, 0),
      ];
      final passed = service.grade(questions, boundary);
      final failed = service.grade(questions, [...boundary]..[0] = 0);

      expect(service.requiredCorrect(count), required);
      expect(service.correctCount(passed), required);
      expect(service.passes(passed), isTrue);
      expect(service.passes(failed), isFalse);
    }
    expect(service.passes([]), isFalse);
  });

  test(
    'reports the first unanswered question without grading it as answered',
    () {
      final service = LearnQuizService();
      expect(service.firstUnanswered([1, null, 0, null]), 1);
      expect(service.firstUnanswered([1, 0]), isNull);
      expect(service.grade([_question], [null]), [false]);
    },
  );

  test('chooses one whole set and preserves correct answers when shuffled', () {
    final service = LearnQuizService(random: Random(42));
    const quizzes = [
      Quiz(
        questions: [
          QuizQuestion(text: 'A1', answer: 'A right', distractors: ['A wrong']),
          QuizQuestion(
            text: 'A2',
            answer: 'A2 right',
            distractors: ['A2 wrong'],
          ),
        ],
      ),
      Quiz(
        questions: [
          QuizQuestion(text: 'B1', answer: 'B right', distractors: ['B wrong']),
        ],
      ),
    ];
    final picked = service.pickQuestions(quizzes);
    final source = quizzes.singleWhere(
      (quiz) => quiz.questions.first.text == picked.first.text,
    );

    expect(
      picked.map((question) => question.text),
      source.questions.map((question) => question.text),
    );
    for (final (index, question) in picked.indexed) {
      final original = source.questions[index];
      expect(question.answers[question.solution].answer, original.answer);
      expect(
        question.answers.map((answer) => answer.answer),
        unorderedEquals([...original.distractors, original.answer]),
      );
    }
    expect(service.pickQuestions([]), isEmpty);
  });
}
