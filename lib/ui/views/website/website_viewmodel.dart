import 'package:freecodecamp/app/app.router.dart';

import '../../../app/app.locator.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebsiteViewModel extends BaseViewModel {
  WebViewController? controller;
  final SnackbarService _snackbarService = locator<SnackbarService>();
  final NavigationService _navigationService = locator<NavigationService>();

  void init() {
    WebView.platform = SurfaceAndroidWebView();
  }

  void setController(WebViewController webViewController) {
    controller = webViewController;
    notifyListeners();
  }

  void showSnackbar() {
    _snackbarService.showSnackbar(message: "No back history item");
  }

  void goToHome() {
    _navigationService.navigateTo(Routes.homeView);
  }

  void goToPodcasts() {
    _navigationService.navigateTo(Routes.podcastView);
  }

  void goToDownloadPodcasts() {
    _navigationService.navigateTo(Routes.podcastDownloadView);
  }

  void goBack() {
    _navigationService.back();
  }
}
