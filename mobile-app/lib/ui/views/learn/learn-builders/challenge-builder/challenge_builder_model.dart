import 'package:stacked/stacked.dart';

class ChallengeBuilderModel extends BaseViewModel {
  int _currentStep = 0;
  int get currentStep => _currentStep;

  set setCurrentStep(int step) {
    _currentStep = step;
    notifyListeners();
  }
}
