import 'package:flutter/material.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:freecodecamp/service/learn/learn_service.dart';
import 'package:freecodecamp/ui/theme/fcc_theme.dart';
import 'package:freecodecamp/ui/views/news/html_handler/html_handler.dart';
import 'package:stacked/stacked.dart';

class MultipleChoiceViewmodel extends BaseViewModel {
  int _currentChoice = -1;
  int get currentChoice => _currentChoice;

  int _lastAnswer = -1;
  int get lastAnswer => _lastAnswer;

  bool? _choiceStatus;
  bool? get choiceStatus => _choiceStatus;

  String _errMessage = '';
  String get errMessage => _errMessage;

  List<Widget> _feedback = [];
  List<Widget> get feedback => _feedback;

  List<bool> _assignmentStatus = [];
  List<bool> get assignmentStatus => _assignmentStatus;

  final LearnService learnService = locator<LearnService>();

  set setCurrentChoice(int choice) {
    _currentChoice = choice;
    notifyListeners();
  }

  set setLastAnswer(int answer) {
    _lastAnswer = answer;
    notifyListeners();
  }

  set setFeedback(List<Widget> feedback) {
    _feedback = feedback;
    notifyListeners();
  }

  set setChoiceStatus(bool? status) {
    _choiceStatus = status;
    notifyListeners();
  }

  set setErrMessage(String message) {
    _errMessage = message;
    notifyListeners();
  }

  set setAssignmentStatus(List<bool> status) {
    _assignmentStatus = status;
    notifyListeners();
  }

  void initChallenge(Challenge challenge) {
    setAssignmentStatus = List.filled(
      challenge.assignments?.length ?? 0,
      false,
    );
  }

  void setValidationStatus(Challenge challenge) {
    bool isCorrect = challenge.question!.solution - 1 == currentChoice;
    setChoiceStatus = isCorrect;
    setLastAnswer = currentChoice;
  }

  void updateFeedback(Challenge challenge, BuildContext context) {
    HTMLParser parser = HTMLParser(context: context);
    Answer answer = challenge.question!.answers[currentChoice];
    bool isCorrect = challenge.question!.solution - 1 == currentChoice;

    List<Widget> feedbackWidgets = [];

    feedbackWidgets.add(
      Padding(
        padding: const EdgeInsets.only(left: 12),
        child: Text(
          isCorrect ? 'Correct!' : 'Incorrect!',
          style: TextStyle(
            color: isCorrect ? FccColors.green40 : FccColors.red15,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
    );

    if (answer.feedback != null && answer.feedback!.isNotEmpty) {
      feedbackWidgets.addAll(
        parser.parse(
          answer.feedback!,
          fontColor: isCorrect ? FccColors.green40 : FccColors.red15,
        ),
      );
    }

    setFeedback = feedbackWidgets;
  }
}
