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

  List<int> get unansweredQuestions => _quizQuestions
      .asMap()
      .entries
      .where((entry) => entry.value.selectedAnswer == -1)
      .map((entry) => entry.key + 1) // Convert to 1-based indexing for display
      .toList();

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
    // Randomly select a question set from challenge.quizzes
    final questionSet =
        (challenge.quizzes != null && challenge.quizzes!.isNotEmpty)
            ? (challenge.quizzes!..shuffle()).first
            : null;
    final questions = questionSet?.questions ?? [];

    setQuizQuestions = questions
        .map<QuizWidgetQuestion>((q) => QuizWidgetQuestion(
              text: q.text,
              answers: q.answers,
              solution: q.solution,
              audioData: q.audioData,
            ))
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
    if (unansweredQuestions.length > 1) {
      setErrMessage =
          "The following questions are unanswered: ${unansweredQuestions.join(', ')}. You must answer all questions.";
      return;
    }

    // Loop through each question and set isCorrect status
    setQuizQuestions = List.from(quizQuestions)
      ..asMap().forEach((i, question) {
        question.isCorrect = question.selectedAnswer == question.solution - 1;
      });

    final correctQuestionsCount =
        quizQuestions.where((q) => q.isCorrect == true).length;
    final totalQuestions = quizQuestions.length;
    final minCorrectToPass = (totalQuestions * 0.9).ceil();

    setHasPassedAllQuestions = unansweredQuestions.isEmpty &&
        correctQuestionsCount >= minCorrectToPass;

    setIsValidated = true;

    setErrMessage = hasPassedAllQuestions
        ? '✅ You have $correctQuestionsCount out of $totalQuestions questions correct. You have passed.'
        : "❌ You have $correctQuestionsCount out of $totalQuestions questions correct. You didn't pass.";
  }

  void resetQuiz() {
    setQuizQuestions = quizQuestions
        .map((q) => QuizWidgetQuestion(
              text: q.text,
              answers: q.answers,
              solution: q.solution,
              audioData: q.audioData,
            ))
        .toList();

    setIsValidated = false;
    setErrMessage = '';
  }
}
