import 'dart:convert';

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

  Future<Challenge>? _challenge;
  Future<Challenge>? get challenge => _challenge;

  set setTestController(WebViewController controller) {
    _testController = controller;
    notifyListeners();
  }

  set setHideAppBar(bool value) {
    _hideAppBar = value;
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

  set setChallenge(Future<Challenge> challenge) {
    _challenge = challenge;
    notifyListeners();
  }

  void init(String url, String? name) async {
    Challenge challenge = await initChallenge(url, name ?? '');

    setChallenge = initChallenge(url, name ?? '');

    if (editorText == null) {
      String text = await getTextFromCache(challenge, name ?? '');

      if (text != '') {
        setEditorText = text;
      }
    }
  }

  // When the content in the editor is changed, save it to the cache. This prevents
  // the user from losing their work when switching between panels e.g, the preview.
  // The cache is disposed when the user switches to a new challenge.

  void saveTextInCache(String value, Challenge challenge, String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (name.isEmpty) {
      prefs.setString('${challenge.title}.${challenge.files[0].name}', value);
    } else {
      prefs.setString('${challenge.title}.${name.split('.')[0]}', value);
    }
  }

  // Get the content of the editor from the cache if it exists. If it doesn't,
  // return an empty string. This prevents the user from losing their work when
  // switching between panels e.g, the preview.

  Future<String> getTextFromCache(Challenge challenge, String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (name.isEmpty) {
      return prefs.getString('${challenge.title}.${challenge.files[0].name}') ??
          '';
    } else {
      return prefs.getString('${challenge.title}.${name.split('.')[0]}') ?? '';
    }
  }

  void setAppBarState(BuildContext context) {
    if (MediaQuery.of(context).viewInsets.bottom > 0 || !showPanel) {
      setHideAppBar = false;
    } else {
      setHideAppBar = true;
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

    if (name.isNotEmpty && showPanel && panelType == PanelType.instruction) {
      setShowPanel = false;
    }

    if (prefs.getString(url) == null) {
      if (res.statusCode == 200) {
        Challenge challenge = Challenge.fromJson(jsonDecode(res.body)['result']
            ['data']['challengeNode']['challenge']);

        prefs.setString(url, res.body);

        return challenge;
      }
    }

    Challenge challenge = Challenge.fromJson(
        jsonDecode(prefs.getString(url) as String)['result']['data']
            ['challengeNode']['challenge']);

    return challenge;
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

  ChallengeFile currentFile(Challenge challenge, String? name) {
    if (name != null) {
      ChallengeFile file =
          challenge.files.firstWhere((file) => file.name == name.split('.')[0]);

      return file;
    }

    return challenge.files[0];
  }
}
