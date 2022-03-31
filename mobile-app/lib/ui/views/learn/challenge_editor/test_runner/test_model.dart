import 'dart:convert';
import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:freecodecamp/enums/challenge_test_state_type.dart';
import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:stacked/stacked.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TestModel extends BaseViewModel {
  late WebViewController _controller;
  WebViewController get controller => _controller;

  bool _pressedTestButton = false;
  bool get pressedTestButton => _pressedTestButton;

  String _testDocument = '';
  String get testDocument => _testDocument;

  set setWebviewController(WebViewController controller) {
    _controller = controller;
    notifyListeners();
  }

  set setPressedTestButton(bool pressed) {
    _pressedTestButton = pressed;
    notifyListeners();
  }

  set setTestDocument(String document) {
    _testDocument = document;
    notifyListeners();
  }

  String parseTest(List<ChallengeTest> tests) {
    List<String> stringArr = [];

    for (ChallengeTest test in tests) {
      stringArr.add('''it('${test.instruction}', () => {
        ${test.javaScript}
      });''');
    }

    return stringArr.join();
  }

  // sets the new content written in the editor and intit test framework

  void setWebViewContent(String content, List<ChallengeTest> tests) {
    Document document = parse(content);

    List<String> imports = [
      '<script src="https://unpkg.com/chai/chai.js"></script>',
      '<script src="https://unpkg.com/mocha/mocha.js"></script>',
      '<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>'
    ];

    List<String> bodyScripts = [
      '<div id="mocha"></div>',
      '''
       <script class="mocha-init">
          mocha.setup("bdd");
          mocha.growl();
          mocha.checkLeaks();
       </script>
      ''',
      '''
       <script class="mocha-exec">
          const assert = chai.assert;
          
          ${parseTest(tests)}

          mocha.run();
       </script>
      '''
    ];

    for (String import in imports) {
      Document importToNode = parse(import);

      Node node = importToNode.getElementsByTagName('HEAD')[0].children.first;

      document.body!.append(importToNode);
    }

    for (String bodyScript in bodyScripts) {
      Document scriptToNode = parse(bodyScript);

      Node bodyNode =
          scriptToNode.getElementsByTagName('BODY').first.children.isNotEmpty
              ? scriptToNode.getElementsByTagName('BODY').first.children.first
              : scriptToNode.getElementsByTagName('HEAD').first.children.first;
      document.body!.append(bodyNode);
    }

    _controller.loadUrl(Uri.dataFromString(document.outerHtml,
            mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString());
  }

  IconData getCorrectTestIcon(ChallengeTestState testState) {
    switch (testState) {
      case ChallengeTestState.waiting:
        return Icons.science_outlined;
      case ChallengeTestState.passed:
        return Icons.check;
      case ChallengeTestState.failed:
        return Icons.error;
      default:
        return Icons.science_outlined;
    }
  }

  Future<List<ChallengeTest>> retrieveTestResults() async {
    List<ChallengeTest> tests = [];

    if (_testDocument.isNotEmpty) {
      Document document = parse(_testDocument);
    } else {
      dev.log('test document is empty');
    }
    return tests;
  }
}
