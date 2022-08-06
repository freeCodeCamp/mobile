import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:freecodecamp/service/authentication_service.dart';
import 'package:freecodecamp/ui/widgets/login_webview_widget/login_webview_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LoginWebView extends StatelessWidget {
  const LoginWebView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoginWebViewModel>.reactive(
      viewModelBuilder: () => LoginWebViewModel(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(),
        body: WebView(
          initialUrl: '${AuthenticationService.baseApiURL}/signin',
          debuggingEnabled: true,
          userAgent: 'random',
          javascriptMode: JavascriptMode.unrestricted,
          initialCookies: const [],
          onWebViewCreated: (controller) async {
            model.webController = controller;
            await controller.clearCache();
            await CookieManager().clearCookies();
          },
          navigationDelegate: (action) async {
            log('NAVIGATION DELEGATE: ${action.url}');
            if (action.url.contains(AuthenticationService.baseURL)) {
              var authRes = await model.auth.extractCookies();
              if (authRes) {
                log('LOGGED IN');
                model.clearCache();

                Navigator.pop(context, 'SUCCESS');
                return NavigationDecision.prevent;
              } else {
                return NavigationDecision.navigate;
              }
            }
            return NavigationDecision.navigate;
          },
        ),
      ),
    );
  }
}
