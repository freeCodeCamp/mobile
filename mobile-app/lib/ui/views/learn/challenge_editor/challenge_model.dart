import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/enums/challenge_test_state_type.dart';
import 'package:freecodecamp/enums/dialog_type.dart';
import 'package:freecodecamp/enums/panel_type.dart';
import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';
import 'package:freecodecamp/ui/views/learn/challenge_editor/challenge_view.dart';
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

  String? _currentSelectedFile = '';
  String? get currentSelectedFile => _currentSelectedFile;

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

  Block? _block;
  Block? get block => _block;

  int _challengesCompleted = 0;
  int get challengesCompleted => _challengesCompleted;

  final _dialogService = locator<DialogService>();

  set setCurrentSelectedFile(String value) {
    _currentSelectedFile = value;
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

  set setChallenge(Future<Challenge> challenge) {
    _challenge = challenge;
    notifyListeners();
  }

  set setBlock(Block block) {
    _block = block;
    notifyListeners();
  }

  set setChallengesCompleted(int value) {
    _challengesCompleted = value;
    notifyListeners();
  }

  void init(String url, Block block, int challengesCompleted) async {
    setupDialogUi();

    setChallenge = initChallenge(url);
    Challenge challenge = await _challenge!;

    if (editorText == null) {
      String text = await getTextFromCache(challenge);

      if (text != '') {
        setEditorText = text;
      }
    }

    setBlock = block;
    setChallengesCompleted = challengesCompleted;
  }

  // When the content in the editor is changed, save it to the cache. This prevents
  // the user from losing their work when switching between panels e.g, the preview.
  // The cache is disposed when the user switches to a new challenge.

  void saveTextInCache(String value, Challenge challenge) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (currentSelectedFile!.isEmpty) {
      prefs.setString('${challenge.title}.${challenge.files[0].name}', value);
    } else {
      prefs.setString(
          '${challenge.title}.${currentSelectedFile!.split('.')[0]}', value);
    }
  }

  // Get the content of the editor from the cache if it exists. If it doesn't,
  // return an empty string. This prevents the user from losing their work when
  // switching between panels e.g, the preview.

  Future<String> getTextFromCache(Challenge challenge) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (currentSelectedFile!.isEmpty) {
      return prefs.getString('${challenge.title}.${challenge.files[0].name}') ??
          '';
    } else {
      return prefs.getString(
              '${challenge.title}.${currentSelectedFile!.split('.')[0]}') ??
          '';
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

  Future<Challenge> initChallenge(String url) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    http.Response res = await http.get(Uri.parse(url));

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

  Future forumHelpDialog(String url) async {
    DialogResponse? res = await _dialogService.showCustomDialog(
        variant: DialogType.buttonForm,
        title: 'Ask for Help',
        description:
            "If you've already tried the Read-Search-Ask method, then you can try asking for help on the freeCodeCamp forum.",
        mainButtonTitle: 'Create a post');
    if (res != null && res.confirmed) {
      launchUrlString(url);
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
          url: url,
          challengesCompleted: _challengesCompleted,
        ),
      ),
    );
  }

  ChallengeFile currentFile(Challenge challenge) {
    if (currentSelectedFile!.isNotEmpty) {
      ChallengeFile file = challenge.files.firstWhere(
          (file) => file.name == currentSelectedFile!.split('.')[0]);

      return file;
    }

    return challenge.files[0];
  }

  void resetCode(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    DialogResponse? res = await _dialogService.showCustomDialog(
        variant: DialogType.buttonForm,
        title: 'Reset Code',
        description: 'Are you sure you want to reset your code?',
        mainButtonTitle: 'Reset');

    if (res!.confirmed) {
      Challenge? currChallenge = await challenge;
      for (ChallengeFile file in currChallenge!.files) {
        prefs.remove('${currChallenge.title}.${file.name}');
      }
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: Duration.zero,
          pageBuilder: (context, animation1, animatiom2) => ChallengeView(
            block: block!,
            url:
                'https://freecodecamp.dev/page-data${currChallenge.slug}/page-data.json',
            challengesCompleted: _challengesCompleted,
          ),
        ),
      );
    }
  }
}
