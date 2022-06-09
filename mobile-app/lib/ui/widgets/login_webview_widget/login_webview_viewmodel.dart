import 'dart:developer';

import 'package:fk_user_agent/fk_user_agent.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/service/authentication_service.dart';
import 'package:stacked/stacked.dart';
import 'package:webview_cookie_manager/webview_cookie_manager.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LoginWebViewModel extends BaseViewModel {
  final AuthenticationService auth = locator<AuthenticationService>();

  late WebViewController webController;

  void init() async {
    auth.init();
    await FkUserAgent.init();
  }

  void clearCache() async {
    await webController.clearCache();
    await WebviewCookieManager().getCookies('https://www.freecodecamp.dev').then((cookies) {
      log('COOKIES: $cookies');
    });
    await CookieManager().clearCookies();
  }
}
