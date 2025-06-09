import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:freecodecamp/service/learn/learn_service.dart';
import 'package:freecodecamp/ui/views/learn/widgets/quiz_widget.dart';
import 'package:stacked/stacked.dart';

class MultipleChoiceViewmodel extends BaseViewModel {
  bool _isValidated = false;
  bool get isValidated => _isValidated;

  bool _hasPassedAllQuestions = false;
  bool get hasPassedAllQuestions => _hasPassedAllQuestions;

  String _errMessage = '';
  String get errMessage => _errMessage;

  List<bool> _assignmentsStatus = [];
  List<bool> get assignmentsStatus => _assignmentsStatus;

  List<QuizQuestion> _quizQuestions = [];
  List<QuizQuestion> get quizQuestions => _quizQuestions;

  final LearnService learnService = locator<LearnService>();

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

  set setQuizQuestions(List<QuizQuestion> questions) {
    _quizQuestions = questions;
    notifyListeners();
  }

  set setAssignmentsStatus(List<bool> status) {
    _assignmentsStatus = status;
    notifyListeners();
  }

  void setAssignmentStatus(int index) {
    setAssignmentsStatus = List<bool>.from(_assignmentsStatus)
      ..[index] = !_assignmentsStatus[index];
    notifyListeners();
  }

  void initChallenge(Challenge challenge) {
    setAssignmentsStatus = List.filled(
      challenge.assignments?.length ?? 0,
      false,
    );

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
