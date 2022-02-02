import 'package:freecodecamp/app/app.locator.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:freecodecamp/app/app.router.dart';

class BrowserViewModel extends BaseViewModel {
  WebViewController? controller;
  final SnackbarService _snackbarService = locator<SnackbarService>();
  final NavigationService _navigationService = locator<NavigationService>();

  void init() {
    WebView.platform = SurfaceAndroidWebView();
  }

  void goBack() {
    _navigationService.back();
  }

  void setController(WebViewController webViewController) {
    controller = webViewController;
    notifyListeners();
  }

  void showSnackbar() {
    _snackbarService.showSnackbar(message: 'No back history item');
  }

  void goToHome() {
    _navigationService.navigateTo(Routes.homeView);
  }

  void goToPodcastList() {
    _navigationService.navigateTo(Routes.podcastListView);
  }
}
