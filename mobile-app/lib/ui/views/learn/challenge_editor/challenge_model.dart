import 'dart:convert';
import 'package:flutter_code_editor/editor/editor.dart';
import 'package:flutter_code_editor/enums/syntax.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/app/app.router.dart';
import 'package:freecodecamp/enums/challenge_test_state_type.dart';
import 'package:freecodecamp/enums/dialog_type.dart';
import 'package:freecodecamp/enums/ext_type.dart';
import 'package:freecodecamp/enums/panel_type.dart';
import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';
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

  bool _showConsole = false;
  bool get showConsole => _showConsole;

  bool _hideAppBar = true;
  bool get hideAppBar => _hideAppBar;

  String _hint = '';
  String get hint => _hint;

  bool _showPanel = true;
  bool get showPanel => _showPanel;

  bool _runningTests = false;
  bool get runningTests => _runningTests;

  bool _hasTypedInEditor = false;
  bool get hasTypedInEditor => _hasTypedInEditor;

  bool _completedChallenge = false;
  bool get completedChallenge => _completedChallenge;

  PanelType _panelType = PanelType.instruction;
  PanelType get panelType => _panelType;

  WebViewController? _webviewController;
  WebViewController? get webviewController => _webviewController;

  WebViewController? _testController;
  WebViewController? get testController => _testController;

  Syntax _currFileType = Syntax.HTML;
  Syntax get currFileType => _currFileType;

  TestRunner runner = TestRunner();

  SnackbarService snackbar = locator<SnackbarService>();
  Future<Challenge>? _challenge;
  Future<Challenge>? get challenge => _challenge;

  Block? _block;
  Block? get block => _block;

  int _challengesCompleted = 0;
  int get challengesCompleted => _challengesCompleted;

  final _dialogService = locator<DialogService>();
  final NavigationService _navigationService = locator<NavigationService>();

  set setCurrentSelectedFile(String value) {
    _currentSelectedFile = value;
    notifyListeners();
  }

  set setIsRunningTests(bool value) {
    _runningTests = value;
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

  set setHasTypedInEditor(bool value) {
    _hasTypedInEditor = true;
    notifyListeners();
  }

  set setShowConsole(bool value) {
    _showConsole = value;
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

  set setCurrFileType(Syntax value) {
    _currFileType = value;
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

  // show a message that the console is not yet available
  void consoleSnackbar() {
    snackbar.showSnackbar(
      title: 'Not yet available',
      message: '',
    );
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

  Future<String> getExactFileFromCache(
    Challenge challenge,
    ChallengeFile file,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String cache = prefs.getString('${challenge.title}.${file.name}') ?? '';

    List<ChallengeFile> firstHtmlChallenge =
        challenge.files.where((file) => file.ext == Ext.html).toList();

    return cache.isEmpty ? firstHtmlChallenge[0].contents : cache;
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

  Future<String> parsePreviewDocument(String doc) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Challenge? currChallenge = await challenge;

    if (currChallenge == null) return parse(doc).outerHtml;

    dom.Document document = parse(doc);

    List<ChallengeFile> cssFiles = currChallenge.files
        .where((ChallengeFile file) => file.ext == Ext.css)
        .toList();

    // TODO: Handle javascript files and multiple html files

    List<ChallengeFile> currentFile = currChallenge.files
        .where((element) => element.ext == Ext.html)
        .toList();

    if (cssFiles.isNotEmpty) {
      String text =
          prefs.getString('${currChallenge.title}.${currentFile[0].name}') ??
              currentFile[0].contents;

      List<String> linkedCssFiles =
          await checkForLinks(parse(text), cssFiles, currChallenge);

      if (linkedCssFiles.isNotEmpty) {
        for (int i = 0; i < linkedCssFiles.length; i++) {
          String style = '''<style> ${linkedCssFiles[i]} </style>''';
          dom.Document styleParsed = parse(style);
          dom.Node styleTag = styleParsed.getElementsByTagName('STYLE')[0];
          document.getElementsByTagName('HEAD')[0].append(styleTag);
        }
      }
    }

    String viewPort = '''<meta content="width=device-width,
         initial-scale=1.0, maximum-scale=1.0,
         user-scalable=no" name="viewport">
         </meta>''';

    dom.Document viewPortParsed = parse(viewPort);
    dom.Node meta = viewPortParsed.getElementsByTagName('META')[0];

    document.getElementsByTagName('HEAD')[0].append(meta);

    return document.outerHtml;
  }

  Future<List<String>> checkForLinks(dom.Document document,
      List<ChallengeFile> cssFiles, Challenge currChallenge) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<dom.Node> links = document.getElementsByTagName('LINK');

    List<String> linkedFileNames = [];
    List<String> linkedFilesContent = [];

    if (links.isNotEmpty) {
      for (dom.Node node in links) {
        if (node.attributes['href'] == null) continue;

        if (node.attributes['href']!.contains('/')) {
          linkedFileNames.add(node.attributes['href']!.split('/').last);
        } else if (node.attributes['href']!.isNotEmpty) {
          linkedFileNames.add(node.attributes['href'] as String);
        }
      }
    }

    if (linkedFileNames.isNotEmpty) {
      for (int i = 0; i < linkedFileNames.length; i++) {
        List<ChallengeFile> files = cssFiles
            .where((ChallengeFile file) =>
                file.name == linkedFileNames[i].split('.')[0])
            .toList();

        String text =
            prefs.getString('${currChallenge.title}.${files[0].name}') ??
                files[0].contents;

        if (files.isNotEmpty) {
          linkedFilesContent.add(text);
        }
      }
    }

    return linkedFilesContent;
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

  ChallengeFile currentFile(Challenge challenge) {
    if (currentSelectedFile!.isNotEmpty) {
      ChallengeFile file = challenge.files.firstWhere(
          (file) => file.name == currentSelectedFile!.split('.')[0]);
      return file;
    }

    return challenge.files[0];
  }

  void resetCode(Editor editor) async {
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
      setEditorText = '';
      setCurrentSelectedFile =
          '${currChallenge.files[0].name}.${currChallenge.files[0].ext.name}';
      editor.fileTextStream.add(
        FileStreamEvent(
          ext: currentFile(currChallenge).ext.name.toUpperCase(),
          content: currentFile(currChallenge).contents,
        ),
      );
    }
  }

  void goToNextChallenge(
    int maxChallenges,
    int challengesCompleted,
  ) async {
    Challenge? currChallenge = await challenge;
    if (currChallenge != null) {
      var challengeIndex = block!.challenges.indexWhere(
        (element) => element.id == currChallenge.id,
      );
      if (challengeIndex == maxChallenges - 1) {
        _navigationService.back();
      } else {
        String challenge = block!.challenges[challengeIndex + 1].name
            .toLowerCase()
            .replaceAll(' ', '-');
        String url = 'https://freecodecamp.dev/page-data/learn';
        _navigationService.replaceWith(
          Routes.challengeView,
          arguments: ChallengeViewArguments(
            url:
                '$url/${block!.superBlock}/${block!.dashedName}/$challenge/page-data.json',
            block: block!,
            challengesCompleted: challengesCompleted + 1,
          ),
        );
      }
    }
  }
}
