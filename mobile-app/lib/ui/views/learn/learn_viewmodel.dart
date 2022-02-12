import 'package:freecodecamp/enums/dialog_type.dart';
import 'package:freecodecamp/ui/widgets/setup_dialog_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:freecodecamp/app/app.locator.dart';

class LearnViewModel extends BaseViewModel {
  WebViewController? controller;
  final NavigationService _navigationService = locator<NavigationService>();
  final _dialogService = locator<DialogService>();

  void init() {
    WebView.platform = SurfaceAndroidWebView();
    setupDialogUi();
    isFirstTimeUsingLearn();
  }

  void isFirstTimeUsingLearn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getBool('isFirstTimeLearner') == null) {
      await showNewLearnerDialog();
    }
  }

  Future<void> showNewLearnerDialog() async {
    // ignore: unused_local_variable
    DialogResponse? response = await _dialogService.showCustomDialog(
        variant: DialogType.buttonForm2,
        title: 'This section is in alpha',
        description:
            'This section of the app is not complete, please becareful while we are working on it.',
        mainButtonTitle: 'I understand',
        data: DialogType.buttonForm2);

    if (response!.confirmed) {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      prefs.setBool('isFirstTimeLearner', false);
    }
  }

  void setController(WebViewController webViewController) {
    controller = webViewController;
    notifyListeners();
  }

  void goBack() {
    _navigationService.back();
  }
}
