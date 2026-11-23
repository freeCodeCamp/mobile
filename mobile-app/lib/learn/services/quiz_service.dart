import 'dart:math';

import 'package:freecodecamp/learn/models/challenge_model.dart';
import 'package:freecodecamp/learn/models/question_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'quiz_service.g.dart';

@riverpod
LearnQuizService learnQuizService(Ref ref) => LearnQuizService();

class LearnQuizService {
  LearnQuizService({Random? random}) : _random = random ?? Random();

  final Random _random;

  List<QuestionItem> pickQuestions(List<Quiz> quizzes) {
    if (quizzes.isEmpty) return const [];
    final quiz = quizzes[_random.nextInt(quizzes.length)];

    return [
      for (final question in quiz.questions)
        () {
          final answers = [
            for (final text in [...question.distractors, question.answer])
              Answer(answer: text),
          ]..shuffle(_random);

          return QuestionItem(
            text: question.text,
            answers: answers,
            solution: answers.indexWhere(
              (answer) => answer.answer == question.answer,
            ),
            audioData: question.audioData,
          );
        }(),
    ];
  }

  int requiredCorrect(int questionCount) => (questionCount * .9).ceil();

  int? firstUnanswered(List<int?> selected) {
    final index = selected.indexOf(null);
    return index == -1 ? null : index;
  }

  List<bool> grade(List<QuestionItem> questions, List<int?> selected) => [
    for (final (index, question) in questions.indexed)
      selected[index] == question.solution,
  ];

  int correctCount(List<bool> results) =>
      results.where((correct) => correct).length;

  bool passes(List<bool> results) =>
      results.isNotEmpty &&
      correctCount(results) >= requiredCorrect(results.length);
}
