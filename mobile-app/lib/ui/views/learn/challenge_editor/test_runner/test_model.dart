import 'dart:convert';
import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:freecodecamp/enums/challenge_test_state_type.dart';
import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:html/dom.dart' as dom;
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

  // sets the new content written in the editor and intit test framework

  void setWebViewContent(String content, List<ChallengeTest> tests) {
    dom.Document document = parse(content);

    List<String> imports = [
      '<script src="https://unpkg.com/chai/chai.js"></script>',
      '<script src="https://unpkg.com/mocha/mocha.js"></script>',
      '<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>',
      '<link rel="stylesheet" href="https://unpkg.com/mocha/mocha.css" />'
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
      dom.Document importToNode = parse(import);

      dom.Node node =
          importToNode.getElementsByTagName('HEAD')[0].children.first;

      document.body!.append(importToNode);
    }

    for (String bodyScript in bodyScripts) {
      dom.Document scriptToNode = parse(bodyScript);

      dom.Node bodyNode =
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

  Future<List<ChallengeTest>> getFailedTest(List<ChallengeTest> incTest) async {
    List<ChallengeTest> testedTest = [];
    dom.Document document = parse(_testDocument);
    List<dom.Element> nodes =
        document.getElementsByClassName('test fail')[0].children;

    if (nodes.isEmpty) return testedTest;

    out:
    for (int i = 0; i < incTest.length; i++) {
      for (dom.Element node in nodes) {
        String nodeTrimmed = node.text.replaceAll(' ', '').replaceAll('‣', '');
        String instTrimmed = incTest[i].instruction.replaceAll(' ', '');

        if (incTest.length == testedTest.length) break out;

        if (nodeTrimmed == instTrimmed) {
          incTest[i].testState = ChallengeTestState.failed;
          testedTest.add(incTest[i]);
        }
      }
    }
    return testedTest;
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

  Future<List<ChallengeTest>> getPassedTest(List<ChallengeTest> incTest) async {
    List<ChallengeTest> testedTest = [];
    dom.Document document = parse(_testDocument);
    List<dom.Element> nodes =
        document.getElementsByClassName('test pass fast')[0].children;

    if (nodes.isEmpty) return testedTest;

    out:
    for (int i = 0; i < incTest.length; i++) {
      for (dom.Element node in nodes) {
        List nodeSplit = node.text.split('>');
        nodeSplit.removeLast();

        String nodeTrimmed = nodeSplit.join('>').replaceAll(' ', '') + '>';

        String instTrimmed = incTest[i].instruction.replaceAll(' ', '');

        if (incTest.length == testedTest.length) break out;

        if (nodeTrimmed == instTrimmed) {
          incTest[i].testState = ChallengeTestState.passed;
          testedTest.add(incTest[i]);
        }
      }
    }
    return testedTest;
  }

  Future<List<ChallengeTest>> testRunner(List<ChallengeTest> incTest) async {
    if (_testDocument.isNotEmpty) {
      List<ChallengeTest> passedTest = await getPassedTest(incTest);
      List<ChallengeTest> failedTest = await getFailedTest(incTest);

      List<ChallengeTest> allTest = List.from(passedTest)..addAll(failedTest);

      return allTest;
    } else {
      dev.log('test document is empty');
    }
    return incTest;
  }
}
