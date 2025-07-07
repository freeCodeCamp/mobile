import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:freecodecamp/service/learn/learn_service.dart';
import 'package:freecodecamp/ui/views/learn/widgets/quiz_widget.dart';
import 'package:stacked/stacked.dart';

class PythonViewModel extends BaseViewModel {
  bool _isValidated = false;
  bool get isValidated => _isValidated;

  bool _hasPassedAllQuestions = false;
  bool get hasPassedAllQuestions => _hasPassedAllQuestions;

  String _errMessage = '';
  String get errMessage => _errMessage;

  List<QuizWidgetQuestion> _quizQuestions = [];
  List<QuizWidgetQuestion> get quizQuestions => _quizQuestions;

  final LearnService learnService = locator<LearnService>();

  set setQuizQuestions(List<QuizWidgetQuestion> questions) {
    _quizQuestions = questions;
    notifyListeners();
  }

  set setIsValidated(bool status) {
    _isValidated = status;
    notifyListeners();
  }

  set setHasPassedAllQuestions(bool status) {
    _hasPassedAllQuestions = status;
    notifyListeners();
  }

  set setErrMessage(String message) {
    _errMessage = message;
    notifyListeners();
  }

  void initChallenge(Challenge challenge) {
    setQuizQuestions = (challenge.questions ?? [])
        .map<QuizWidgetQuestion>((q) => QuizWidgetQuestion(
            text: q.text, answers: q.answers, solution: q.solution))
        .toList();
  }

  void setSelectedAnswer(int questionIndex, int answerIndex) {
    final question = quizQuestions[questionIndex];
    question.selectedAnswer = answerIndex;

    if (isValidated) {
      // Reset the validation status when user changes the selection
      setIsValidated = false;
    }

    if (errMessage.isNotEmpty) {
      // Clear the error message when user changes the selection
      setErrMessage = '';
    }

    notifyListeners();
  }

  void validateChallenge() {
    // Loop through each question and set isCorrect status
    setQuizQuestions = List.from(quizQuestions)
      ..asMap().forEach((i, question) {
        question.isCorrect = question.selectedAnswer == question.solution - 1;
      });

    setHasPassedAllQuestions =
        quizQuestions.every((question) => question.isCorrect == true);

    setIsValidated = true;

    // Show the error message if there are multiple questions.
    // Otherwise, the validation message is sufficient.
    if (quizQuestions.length > 1) {
      setErrMessage =
          hasPassedAllQuestions ? '' : 'Some answers are incorrect.';
    }
  }
}
