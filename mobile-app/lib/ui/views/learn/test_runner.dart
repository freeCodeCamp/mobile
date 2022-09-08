import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:freecodecamp/enums/challenge_test_state_type.dart';
import 'package:freecodecamp/enums/ext_type.dart';
import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:html/parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:html/dom.dart' as dom;

// TODO: do not rely on the DOM and use the console instead to see if test are completed

class TestRunner extends BaseViewModel {
  String _testDocument = '';
  String get testDocument => _testDocument;

  set setTestDocument(String document) {
    _testDocument = document;
    notifyListeners();
  }

  Future<String?> getExactFileFromCache(
    Challenge challenge,
    ChallengeFile file,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cache = prefs.getString('${challenge.title}.${file.name}');

    return cache;
  }

  Future<String> getFirstHTMLfileFromCache(
    Challenge challenge,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<ChallengeFile> firstHtmlChallenge =
        challenge.files.where((file) => file.ext == Ext.html).toList();

    String fileContent =
        prefs.getString('${challenge.title}.${firstHtmlChallenge[0].name}') ??
            firstHtmlChallenge[0].contents;

    return fileContent;
  }

  Future<String> parseCssDocmentsAsStyleTags(
    Challenge challenge,
    String content,
  ) async {
    List<ChallengeFile> cssFiles =
        challenge.files.where((element) => element.ext == Ext.css).toList();
    List<String> cssFilesWithCache = [];
    List<String> tags = [];

    if (cssFiles.isNotEmpty) {
      for (ChallengeFile file in cssFiles) {
        String? cache = await getExactFileFromCache(challenge, file);
        String handledFile = cache ?? file.contents;

        cssFilesWithCache.add(handledFile);
      }

      for (String contents in cssFilesWithCache) {
        String tag = '<style> $contents </style>';
        tags.add(tag);
      }

      for (String tag in tags) {
        content += tag;
      }

      return content;
    }

    return content;
  }

  void setWebViewContent(
    Challenge challenge,
    WebViewController webviewController,
  ) async {
    dom.Document document = dom.Document();
    document = parse('');

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
          mocha.checkLeaks();
       </script>
      ''',
      '''
       <script class="mocha-exec" type="module">
          import * as __helpers from "https://unpkg.com/@freecodecamp/curriculum-helpers@1.1.0/dist/index.js";
          const assert = chai.assert;
          let code = `${await parseCssDocmentsAsStyleTags(challenge, await getFirstHTMLfileFromCache(challenge))}`;

          ${parseTest(challenge.tests)}

          mocha.run();
       </script>
      '''
    ];

    for (String import in imports) {
      dom.Document importToNode = parse(import);

      dom.Node node =
          importToNode.getElementsByTagName('HEAD')[0].children.first;

      document.getElementsByTagName('HEAD')[0].append(node);
    }

    for (String bodyScript in bodyScripts) {
      dom.Document scriptToNode = parse(bodyScript);

      dom.Node bodyNode =
          scriptToNode.getElementsByTagName('BODY').first.children.isNotEmpty
              ? scriptToNode.getElementsByTagName('BODY').first.children.first
              : scriptToNode.getElementsByTagName('HEAD').first.children.first;
      document.body!.append(bodyNode);
    }

    log(document.outerHtml);

    webviewController.loadUrl(Uri.dataFromString(document.outerHtml,
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

  List<ChallengeTest> getFailedTest(List<ChallengeTest> incTest) {
    List<ChallengeTest> testedTest = [];
    dom.Document document = parse(_testDocument);

    if (document.getElementsByClassName('test fail').isEmpty) {
      return testedTest;
    }

    List testFailInView = document.getElementsByClassName('test fail');

    out:
    for (int i = 0; i < testFailInView.length; i++) {
      List<dom.Element> nodes =
          document.getElementsByClassName('test fail')[i].children;
      for (int j = 0; j < incTest.length; j++) {
        for (dom.Element node in nodes) {
          String nodeTrimmed =
              node.text.replaceAll(' ', '').replaceAll('‣', '');
          String instTrimmed = incTest[j].instruction.replaceAll(' ', '');

          if (nodeTrimmed == instTrimmed) {
            incTest[j].testState = ChallengeTestState.failed;
            testedTest.add(incTest[j]);
          }

          if (incTest.length == testedTest.length) break out;
        }
      }
    }

    return testedTest;
  }

  String parseTest(List<ChallengeTest> tests) {
    List<String> stringArr = [];

    for (ChallengeTest test in tests) {
      stringArr.add('''\nit(`${test.instruction}`, () => {
        ${test.javaScript}
      });''');
    }

    return stringArr.join();
  }

  List<ChallengeTest> getPassedTest(List<ChallengeTest> incTest) {
    List<ChallengeTest> testedTest = [];
    dom.Document document = parse(_testDocument);

    if (document.getElementsByClassName('test pass fast').isEmpty) {
      return testedTest;
    }

    List<dom.Element> testPassInView =
        document.getElementsByClassName('test pass fast');

    out:
    for (int i = 0; i < testPassInView.length; i++) {
      List<dom.Element> nodes =
          document.getElementsByClassName('test pass fast')[i].children;

      for (int j = 0; j < incTest.length; j++) {
        for (dom.Element node in nodes) {
          List nodeSplit = node.text.split('>');

          if (nodeSplit.length > 1) nodeSplit.removeLast();

          String nodeTrimmed = '${nodeSplit.join('>').replaceAll(' ', '')}>';

          String instTrimmed = incTest[j].instruction.replaceAll(' ', '');

          if (nodeTrimmed == instTrimmed) {
            incTest[j].testState = ChallengeTestState.passed;
            testedTest.add(incTest[j]);
          }

          if (incTest.length == testedTest.length) break out;
        }
      }
    }
    return testedTest;
  }

  Future<List<ChallengeTest>> testRunner(List<ChallengeTest> incTest) async {
    if (_testDocument.isNotEmpty) {
      List<ChallengeTest> passedTest = getPassedTest(incTest);
      List<ChallengeTest> failedTest = getFailedTest(incTest);

      log('running tests');

      List<ChallengeTest> allTest = List.from(passedTest)..addAll(failedTest);
      log((allTest.map((e) => e.testState)).toString());

      return allTest;
    } else {
      log('test document is empty');
    }

    return incTest;
  }
}
