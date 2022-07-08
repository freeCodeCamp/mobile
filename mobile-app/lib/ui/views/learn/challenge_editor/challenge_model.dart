import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_code_editor/controller/editor_view_controller.dart';
import 'package:flutter_code_editor/models/file_model.dart';
import 'package:freecodecamp/enums/challenge_test_state_type.dart';
import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as dev;

class ChallengeModel extends BaseViewModel {
  String? _editorText;
  String? get editorText => _editorText;

  bool _showPreview = false;
  bool get showPreview => _showPreview;

  bool _hideAppBar = false;
  bool get hideAppBar => _hideAppBar;

  bool _showDescription = false;
  bool get showDescription => _showDescription;

  bool _pressedTestButton = false;
  bool get pressedTestButton => _pressedTestButton;

  String _testDocument = '';
  String get testDocument => _testDocument;

  WebViewController? _webviewController;
  WebViewController? get webviewController => _webviewController;

  WebViewController? _testController;
  WebViewController? get testController => _testController;

  void init() async {
    _editorText = await getEditorTextFromCache();
    notifyListeners();
  }

  set setTestController(WebViewController controller) {
    _testController = controller;
    notifyListeners();
  }

  set setHideAppBar(bool value) {
    _hideAppBar = value;
    notifyListeners();
  }

  set setShowDescription(bool value) {
    _showDescription = value;
    notifyListeners();
  }

  set setWebviewController(WebViewController value) {
    _webviewController = value;
    notifyListeners();
  }

  set showPreview(bool value) {
    _showPreview = value;
    notifyListeners();
  }

  set setEditorText(String? value) {
    _editorText = value;
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

  void saveEditorTextInCache(String value) async {
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString('editorText', value);
    });
  }

  Future<String> getEditorTextFromCache() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString('editorText') ?? '';
  }

  Future<Challenge?> initChallenge(String url) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getString(url) == null) {
      http.Response res = await http.get(Uri.parse(url));

      if (res.statusCode == 200) {
        prefs.setString(url, res.body);

        dev.log('challenge cache got add on: $url');

        return Challenge.fromJson(jsonDecode(res.body)['result']['data']
            ['challengeNode']['challenge']);
      }
    } else {
      return Challenge.fromJson(
          jsonDecode(prefs.getString(url) as String)['result']['data']
              ['challengeNode']['challenge']);
    }

    return null;
  }

  Future disposeCahce(String url) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getString(url) != null) {
      prefs.remove(url);
      dev.log('challenge cache got disposed');
    }

    if (prefs.getString('editorText') != null) {
      prefs.remove('editorText');
      dev.log('editorText cache got disposed');
    }

    EditorViewController controller = EditorViewController();

    controller.removeAllRecentlyOpenedFilesCache('');
  }

  String parsePreviewDocument(String docString) {
    dom.Document document = parse(docString);

    String viewPort =
        '<meta content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" name="viewport"></meta>';

    dom.Document viewPortParsed = parse(viewPort);
    dom.Node meta = viewPortParsed.getElementsByTagName('META')[0];

    document.getElementsByTagName('HEAD')[0].append(meta);

    dev.log(document.outerHtml);

    return document.outerHtml;
  }

  List<FileIDE> returnFiles(Challenge challenge) {
    List<FileIDE> files = [];

    for (ChallengeFile file in challenge.files) {
      files.add(FileIDE(
          fileName: file.name,
          filePath: '',
          fileContent: file.contents,
          parentDirectory: '',
          fileExplorer: null));
    }

    return files;
  }

  void updateText(String newText) {
    _editorText = newText;
    notifyListeners();
  }

  // sets the new content written in the editor and intit test framework

  void setWebViewContent(String content, List<ChallengeTest> tests,
      WebViewController webviewController) {
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
          mocha.checkLeaks();
       </script>
      ''',
      '''
       <script class="mocha-exec">
          const assert = chai.assert;
          let code = `$content`;
          
          ${parseTest(tests)}

          mocha.run();
       </script>
      '''
    ];

    for (String import in imports) {
      dom.Document importToNode = parse(import);

      // ignore: unused_local_variable
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
      stringArr.add('''it('${test.instruction}', () => {
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

          String nodeTrimmed = nodeSplit.join('>').replaceAll(' ', '') + '>';

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

      List<ChallengeTest> allTest = List.from(passedTest)..addAll(failedTest);
      log((allTest.map((e) => e.testState)).toString());

      return allTest;
    } else {
      dev.log('test document is empty');
    }

    return incTest;
  }
}
