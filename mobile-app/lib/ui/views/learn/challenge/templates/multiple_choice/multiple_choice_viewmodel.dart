import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:freecodecamp/service/learn/learn_service.dart';
import 'package:stacked/stacked.dart';

class MultipleChoiceViewmodel extends BaseViewModel {
  int _currentChoice = -1;
  int get currentChoice => _currentChoice;

  bool? _choiceStatus;
  bool? get choiceStatus => _choiceStatus;

  String _errMessage = '';
  String get errMessage => _errMessage;

  List<bool> _assignmentStatus = [];
  List<bool> get assignmentStatus => _assignmentStatus;

  final LearnService learnService = locator<LearnService>();

  set setCurrentChoice(int choice) {
    _currentChoice = choice;
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
    setAssignmentStatus =
        List.filled(challenge.assignments?.length ?? 0, false);
  }

  void checkOption(Challenge challenge) async {
    bool isCorrect = challenge.question!.solution - 1 == currentChoice;
    setChoiceStatus = isCorrect;
  }
}
