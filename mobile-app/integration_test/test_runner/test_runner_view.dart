import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:freecodecamp/ui/views/learn/test_runner.dart';

final InAppLocalhostServer _localhostServer =
    InAppLocalhostServer(documentRoot: 'assets/test_runner');

class CurriculumTestRunner extends StatefulWidget {
  const CurriculumTestRunner({super.key});

  @override
  CurriculumTestRunnerState createState() => CurriculumTestRunnerState();
}

class CurriculumTestRunnerState extends State<CurriculumTestRunner> {
  InAppWebViewController? webViewController;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _localhostServer.start(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          log('Error starting server: ${snapshot.error}');
          throw Exception('Error starting server: ${snapshot.error}');
        }

        return MaterialApp(
          title: 'Curriculum Test Runner',
          builder: (context, child) => Scaffold(
            appBar: AppBar(
              title: Text('Curriculum Test Runner'),
            ),
            body: InAppWebView(
              initialUrlRequest:
                  URLRequest(url: WebUri('http://localhost:8080')),
              onWebViewCreated: (controller) {
                webViewController = controller;
              },
              // onConsoleMessage: (controller, console) {
              //   log('Test Runner Console message: ${console.message}');
              // },
              onLoadStop: (controller, url) async {
                final res = await controller.callAsyncJavaScript(
                  // NOTE: I'm loading frame test runner here as a placeholder
                  functionBody: ScriptBuilder.runnerScript,
                  arguments: {
                    'userCode': '',
                    'workerType': 'frame',
                    'combinedCode': '',
                    'editableRegionContent': '',
                    'hooks': {
                      'beforeAll': '',
                    },
                  },
                );
                log('TestRunner: $res');
              },
              initialSettings: InAppWebViewSettings(
                isInspectable: true,
              ),
            ),
          ),
        );
      },
    );
  }
}
