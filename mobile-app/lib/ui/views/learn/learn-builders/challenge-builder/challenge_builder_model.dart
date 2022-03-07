import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/app/app.router.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ChallengeBuilderModel extends BaseViewModel {
  int _currentStep = 0;
  int get currentStep => _currentStep;

  final NavigationService _navigationService = locator<NavigationService>();

  set setCurrentStep(int step) {
    _currentStep = step;
    notifyListeners();
  }

  void routeToBrowserView(String url) {
    _navigationService.navigateTo(Routes.browserView,
        arguments: BrowserViewArguments(url: url));
  }
}
