import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:stacked/stacked.dart';

// Model that extends Question with feedback/status info
class QuizQuestion {
  final String text;
  final List<Answer> answers;
  final int solution;
  int selectedAnswer;
  bool? isCorrect;

  QuizQuestion({
    required this.text,
    required this.answers,
    required this.solution,
    this.selectedAnswer = -1,
    this.isCorrect,
  });
}

class QuizViewModel extends BaseViewModel {
  final List<QuizQuestion> quizQuestions;

  QuizViewModel({required List<Question> questions})
      : quizQuestions = questions
            .map((q) => QuizQuestion(
                text: q.text, answers: q.answers, solution: q.solution))
            .toList();

  void selectAnswer(int questionIndex, int answerIndex) {
    quizQuestions[questionIndex].selectedAnswer = answerIndex;

    // Compute the isCorrect status
    final solution = quizQuestions[questionIndex].solution;
    quizQuestions[questionIndex].isCorrect = (answerIndex == solution - 1);

    notifyListeners();
  }
}
