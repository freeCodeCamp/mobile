import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:stacked/stacked.dart';

// Model that extends Question with feedback/status info
class QuizQuestion {
  final Question question;
  int selectedAnswer;
  bool? isCorrect;

  QuizQuestion({
    required this.question,
    this.selectedAnswer = -1,
    this.isCorrect,
  });
}

class QuizViewModel extends BaseViewModel {
  final List<QuizQuestion> quizQuestions;

  QuizViewModel({required List<Question> questions})
      : quizQuestions =
            questions.map((q) => QuizQuestion(question: q)).toList();

  void selectAnswer(int questionIndex, int answerIndex) {
    quizQuestions[questionIndex].selectedAnswer = answerIndex;

    final solution = quizQuestions[questionIndex].question.solution;
    quizQuestions[questionIndex].isCorrect = (answerIndex == solution - 1);

    notifyListeners();
  }
}
