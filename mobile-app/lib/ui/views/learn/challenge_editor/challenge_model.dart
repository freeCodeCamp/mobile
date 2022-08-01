import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:freecodecamp/enums/challenge_test_state_type.dart';
import 'package:freecodecamp/enums/panel_type.dart';
import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';
import 'package:freecodecamp/ui/views/learn/challenge_editor/challenge_view.dart';
import 'package:freecodecamp/ui/views/learn/test_runner.dart';

import 'package:html/parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;

class ChallengeModel extends BaseViewModel {
  String? _editorText;
  String? get editorText => _editorText;

  bool _showPreview = false;
  bool get showPreview => _showPreview;

  bool _hideAppBar = true;
  bool get hideAppBar => _hideAppBar;

  String _currentSelectedFile = 'index.html';
  String get currentSelectedFile => _currentSelectedFile;

  String _hint = '';
  String get hint => _hint;

  bool _showPanel = true;
  bool get showPanel => _showPanel;

  bool _completedChallenge = false;
  bool get completedChallenge => _completedChallenge;

  PanelType _panelType = PanelType.instruction;
  PanelType get panelType => _panelType;

  WebViewController? _webviewController;
  WebViewController? get webviewController => _webviewController;

  WebViewController? _testController;
  WebViewController? get testController => _testController;

  TestRunner runner = TestRunner();

  Challenge? _challenge;
  Challenge? get challenge => _challenge;

  void init(Challenge challenge) async {
    setCurrentSelectedFile =
        '${challenge.files[0].name}.${challenge.files[0].ext.name}';
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

  set setCurrentSelectedFile(String value) {
    _currentSelectedFile = value;
    notifyListeners();
  }

  set setShowPanel(bool value) {
    _showPanel = value;
    notifyListeners();
  }

  set setWebviewController(WebViewController value) {
    _webviewController = value;
    notifyListeners();
  }

  set setShowPreview(bool value) {
    _showPreview = value;
    notifyListeners();
  }

  set setEditorText(String value) {
    _editorText = value;
    notifyListeners();
  }

  set setHint(String hint) {
    _hint = hint;
    notifyListeners();
  }

  set setPanelType(PanelType panelType) {
    _panelType = panelType;
    notifyListeners();
  }

  set setCompletedChallenge(bool completed) {
    _completedChallenge = completed;
    notifyListeners();
  }

  set setChallenge(Challenge challenge) {
    _challenge = challenge;
    notifyListeners();
  }

  // When the content in the editor is changed, save it to the cache. This prevents
  // the user from losing their work when switching between panels e.g, the preview.
  // The cache is disposed when the user switches to a new challenge.

  // void saveEditorTextInCache(String value, Challenge challenge) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();

  //   ChallengeFile currentFile = returnCurrentSelectedFile(challenge);

  //   prefs.setString(currentFile.name, value);
  // }

  // Get the content of the editor from the cache if it exists. If it doesn't,
  // return an empty string. This prevents the user from losing their work when
  // switching between panels e.g, the preview.

  // Future<String?> getEditorTextFromCache(Challenge challenge, String name) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();

  //   ChallengeFile currentFile = returnCurrentSelectedFile(challenge, name);

  //   return prefs.getString(currentFile.name);
  // }

  // This removes the cached content of the editor. This is called when the user
  // switches to a new challenge.

  Future disposeCahce(String url, Challenge? challenge) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getString(url) != null) {
      prefs.remove(url);
    }

    if (challenge != null) {
      for (ChallengeFile file in challenge.files) {
        if (prefs.getString(file.name) != null) {
          prefs.remove(file.name);
        }
      }
    } else {
      log('failed to clean editor cache');
    }
  }

  void setAppBarState(BuildContext context) {
    if (MediaQuery.of(context).viewInsets.bottom > 0 || !showPanel) {
      setHideAppBar = false;
    } else {
      setHideAppBar = true;
    }
  }

  // This prevents the user from requesting the challenge more than once
  // when swichting between preview and the challenge.

  Future<Challenge> initChallenge(String url, String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    http.Response res = await http.get(Uri.parse(url));

    if (prefs.getString('$url&$name') == null) {
      if (res.statusCode == 200) {
        if (name.isNotEmpty) prefs.setString('$url&$name', res.body);

        return Challenge.fromJson(jsonDecode(res.body)['result']['data']
            ['challengeNode']['challenge']);
      }
    }

    return Challenge.fromJson(
        jsonDecode(prefs.getString('$url&$name') as String)['result']['data']
            ['challengeNode']['challenge']);
  }

  // This parses the preview document with the correct viewport size. This document
  // is then displayed in the preview panel. The preview document does not modify
  // the original challenge document.

  String parsePreviewDocument(String docString) {
    dom.Document document = parse(docString);

    String viewPort = '''<meta content="width=device-width,
         initial-scale=1.0, maximum-scale=1.0,
         user-scalable=no" name="viewport">
         </meta>''';

    dom.Document viewPortParsed = parse(viewPort);
    dom.Node meta = viewPortParsed.getElementsByTagName('META')[0];

    document.getElementsByTagName('HEAD')[0].append(meta);

    return document.outerHtml;
  }

  // The hint text is the same as the test text. This is used to display the hint.
  // if the length of the hint is greater than 0, then the hint is displayed. If
  // the length of the hint is 0, then the challenge is completed.

  ChallengeTest? returnFirstFailedTest(List<ChallengeTest> incTest) {
    for (ChallengeTest test in incTest) {
      if (test.testState == ChallengeTestState.failed) {
        return test;
      }
    }
    return null;
  }

  // this function checks if the current default file value "index.html" is present in the available
  // challenge files. If not set it to the first file in the array.
  void handleCurrentDropdownState(Challenge challenge) {
    String firstFile =
        '${challenge.files[0].name}.${challenge.files[0].ext.name}';

    bool defaultFileIsPresent = challenge.files
        .map((file) => file.name)
        .contains(_currentSelectedFile.split('.')[0]);

    if (!defaultFileIsPresent && firstFile != currentSelectedFile) {
      setCurrentSelectedFile = firstFile;
    }
  }

  void pushNewChallengeView(
      BuildContext context, Block block, String url, String name) {
    Navigator.pushReplacement(
        context,
        PageRouteBuilder(
            transitionDuration: Duration.zero,
            pageBuilder: (context, animation1, animatiom2) => ChallengeView(
                  block: block,
                  challengeName: name,
                  url: url,
                )));
  }

  ChallengeFile returnCurrentSelectedFile(Challenge challenge, String? name) {
    if (name != null) {
      ChallengeFile file =
          challenge.files.firstWhere((file) => file.name == name.split('.')[0]);

      return file;
    }

    return challenge.files[0];
  }
}
