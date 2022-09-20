import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:freecodecamp/ui/views/learn/console/console_model.dart';
import 'package:stacked/stacked.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ConsoleView extends StatelessWidget {
  const ConsoleView({Key? key, required this.code}) : super(key: key);
  final String code;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ConsoleModel>.reactive(
        viewModelBuilder: () => ConsoleModel(),
        builder: (context, model, child) => Scaffold(
              body: Column(
                children: [
                  SizedBox(
                    width: 1,
                    height: 1,
                    child: WebView(
                      userAgent: 'random',
                      javascriptMode: JavascriptMode.unrestricted,
                      onWebViewCreated: (WebViewController viewController) {
                        model.setWebViewController = viewController;
                        viewController.loadUrl(
                          Uri.dataFromString(
                            model.updateConsole(
                              code,
                            ),
                            mimeType: 'text/html',
                            encoding: utf8,
                          ).toString(),
                        );
                      },
                      javascriptChannels: {
                        JavascriptChannel(
                          name: 'Print',
                          onMessageReceived: (message) {
                            List newList = [message.message];
                            newList.addAll(model.logList);
                            log(message.message);
                            model.setLogList = newList;
                          },
                        )
                      },
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: model.logList.length,
                              itemBuilder: (context, index) {
                                return Text(model.logList[index]);
                              }),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ));
  }
}
