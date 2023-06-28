import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:freecodecamp/service/learn/learn_service.dart';
import 'package:html/parser.dart';
import 'package:stacked/stacked.dart';
import 'package:html/dom.dart';

class PythonViewModel extends BaseViewModel {
  int _currentChoice = -1;
  int get currentChoice => _currentChoice;

  bool? _choiceStatus;
  bool? get choiceStatus => _choiceStatus;

  final LearnService learnService = locator<LearnService>();

  set setCurrentChoice(int choice) {
    _currentChoice = choice;
    notifyListeners();
  }

  set setChoiceStatus(bool? status) {
    _choiceStatus = status;
    notifyListeners();
  }

  String removeHtmlTags(String html) {
    Document document = parse(html);

    return document.body!.text;
  }

  void checkOption(Challenge challenge) async {
    bool isCorrect = challenge.question!.solution - 1 == currentChoice;
    setChoiceStatus = isCorrect;
  }
}
