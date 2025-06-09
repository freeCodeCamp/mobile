import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:freecodecamp/service/learn/learn_service.dart';
import 'package:freecodecamp/ui/views/learn/widgets/quiz_widget.dart';
import 'package:stacked/stacked.dart';

class QuizViewModel extends BaseViewModel {
  bool _isValidated = false;
  bool get isValidated => _isValidated;

  bool _hasPassedAllQuestions = false;
  bool get hasPassedAllQuestions => _hasPassedAllQuestions;

  String _errMessage = '';
  String get errMessage => _errMessage;

  List<QuizQuestion> _quizQuestions = [];
  List<QuizQuestion> get quizQuestions => _quizQuestions;

  final LearnService learnService = locator<LearnService>();

  set setQuizQuestions(List<QuizQuestion> questions) {
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
    print(challenge.questions);
    setQuizQuestions = (challenge.questions ?? [])
        .map<QuizQuestion>((q) => QuizQuestion(
            text: q.text, answers: q.answers, solution: q.solution))
        .toList();
  }

  void setSelectedAnswer(int questionIndex, int answerIndex) {
    final question = quizQuestions[questionIndex];
    question.selectedAnswer = answerIndex;

    setQuizQuestions = List.from(quizQuestions)..[questionIndex] = question;

    // Reset the validation status when user changes the selection
    setIsValidated = false;
    setErrMessage = '';

    notifyListeners();
  }

  void validateChallenge() {
    // Loop through each question and set isCorrect status
    setQuizQuestions = List.from(quizQuestions)
      ..asMap().forEach((i, question) {
        question.isCorrect = question.selectedAnswer == question.solution - 1;
      });

    final unansweredQuestions =
        quizQuestions.where((q) => q.selectedAnswer == -1).toList();

    setHasPassedAllQuestions = unansweredQuestions.isEmpty;

    setIsValidated = true;

    if (unansweredQuestions.length > 1) {
      setErrMessage =
          "The following questions are unanswered: ${unansweredQuestions.join(',')}. You must answer all questions.";
    } else {
      setErrMessage = 'Some answers are incorrect.';
    }
  }
}
