import 'dart:convert';

import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/enums/challenge_test_state_type.dart';
import 'package:freecodecamp/enums/dialog_type.dart';
import 'package:freecodecamp/enums/panel_type.dart';
import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:freecodecamp/ui/views/learn/test_runner.dart';
import 'package:freecodecamp/ui/widgets/setup_dialog_ui.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ChallengeModel extends BaseViewModel {
  String? _editorText;
  String? get editorText => _editorText;

  bool _showPreview = false;
  bool get showPreview => _showPreview;

  bool _hideAppBar = false;
  bool get hideAppBar => _hideAppBar;

  String _hint = '';
  String get hint => _hint;

  bool _showPanel = false;
  bool get showPanel => _showPanel;

  bool _completedChallenge = false;
  bool get completedChallenge => _completedChallenge;

  PanelType _panelType = PanelType.none;
  PanelType get panelType => _panelType;

  WebViewController? _webviewController;
  WebViewController? get webviewController => _webviewController;

  WebViewController? _testController;
  WebViewController? get testController => _testController;

  Challenge? _challenge;
  Challenge? get challenge => _challenge;

  TestRunner runner = TestRunner();

  final _dialogService = locator<DialogService>();

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

  // When the content in the editor is changed, save it to the cache. This prevents
  // the user from losing their work when switching between panels e.g, the preview.
  // The cache is disposed when the user switches to a new challenge.

  void saveEditorTextInCache(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('editorText', value);
  }

  // Get the content of the editor from the cache if it exists. If it doesn't,
  // return an empty string. This prevents the user from losing their work when
  // switching between panels e.g, the preview.

  Future<String> getEditorTextFromCache() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString('editorText') ?? '';
  }

  // This removes the cached content of the editor. This is called when the user
  // switches to a new challenge.

  Future disposeCahce(String url) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getString(url) != null) {
      prefs.remove(url);
    }

    if (prefs.getString('editorText') != null) {
      prefs.remove('editorText');
    }
  }

  // This prevents the user from requesting the challenge more than once
  // when swichting between preview and the challenge.

  Future<Challenge?> initChallenge(String url) async {
    setupDialogUi();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getString(url) == null) {
      http.Response res = await http.get(Uri.parse(url));

      if (res.statusCode == 200) {
        prefs.setString(url, res.body);
        _challenge = Challenge.fromJson(jsonDecode(res.body)['result']['data']
            ['challengeNode']['challenge']);

        return _challenge;
      }
    } else {
      _challenge = Challenge.fromJson(
          jsonDecode(prefs.getString(url) as String)['result']['data']
              ['challengeNode']['challenge']);
      return _challenge;
    }

    return null;
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

  Future forumHelpDialog(String url) async {
    DialogResponse? res = await _dialogService.showCustomDialog(
        variant: DialogType.buttonForm,
        title: 'Ask for Help',
        description:
            "If you've already tried the Read-Search-Ask method, then you can try asking for help on the freeCodeCamp forum.",
        mainButtonTitle: 'Create a post');
    if (res!.confirmed) {
      launchUrlString(url);
    }
  }
}
