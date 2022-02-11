import 'package:freecodecamp/enums/dialog_type.dart';
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
    isFirstTimeUsingLearn();
  }

  void isFirstTimeUsingLearn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getBool('isFirsTimeLearner') == null) {
      await showNewLearnerDialog();
    }
  }

  Future<void> showNewLearnerDialog() async {
    // ignore: unused_local_variable
    DialogResponse? response = await _dialogService.showCustomDialog(
        variant: DialogType.authform,
        title: 'Two-Factor Authentication',
        description: 'Please enter the authentication code from your app:',
        data: DialogType.authform);
  }

  void setController(WebViewController webViewController) {
    controller = webViewController;
    notifyListeners();
  }

  void goBack() {
    _navigationService.back();
  }
}
