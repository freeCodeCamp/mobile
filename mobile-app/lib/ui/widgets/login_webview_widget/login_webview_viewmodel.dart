import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/service/authentication/authentication_service.dart';
import 'package:stacked/stacked.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LoginWebViewModel extends BaseViewModel {
  final AuthenticationService auth = locator<AuthenticationService>();

  late WebViewController webController;

  void clearCache() async {
    await webController.clearCache();
  }
}
