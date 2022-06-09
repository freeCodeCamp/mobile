import 'dart:developer';

import 'package:fk_user_agent/fk_user_agent.dart';
import 'package:flutter/material.dart';
import 'package:freecodecamp/ui/widgets/login_webview_widget/login_webview_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LoginWebView extends StatelessWidget {
  const LoginWebView({Key? key}) : super(key: key);

  final String path = '/learn?messages=success%5B0%5D%3Dflash.signin-success';

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoginWebViewModel>.reactive(
      viewModelBuilder: () => LoginWebViewModel(),
      onModelReady: (model) async => model.init(),
      builder: (context, model, child) => Scaffold(
          appBar: AppBar(),
          body: WebView(
            initialUrl: 'https://www.freecodecamp.dev/signin',
            debuggingEnabled: true,
            userAgent: '${FkUserAgent.webViewUserAgent}',
            javascriptMode: JavascriptMode.unrestricted,
            initialCookies: const [],
            onWebViewCreated: (controller) async {
              model.webController = controller;
              await controller.clearCache();
              await CookieManager().clearCookies();
            },
            navigationDelegate: (action) {
              if (action.url == 'https://www.freecodecamp.dev$path') {
                log('LOGGED IN');
                model.clearCache();
                Navigator.pop(context, 'SUCCESS');
                return NavigationDecision.prevent;
              }
              return NavigationDecision.navigate;
            },
          )),
    );
  }
}
