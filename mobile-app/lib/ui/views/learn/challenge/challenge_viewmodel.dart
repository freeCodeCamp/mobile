import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:phone_ide/phone_ide.dart';

import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/app/app.router.dart';
import 'package:freecodecamp/enums/challenge_test_state_type.dart';
import 'package:freecodecamp/enums/dialog_type.dart';
import 'package:freecodecamp/enums/ext_type.dart';
import 'package:freecodecamp/enums/panel_type.dart';
import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';
import 'package:freecodecamp/service/learn/learn_file_service.dart';
import 'package:freecodecamp/service/learn/learn_offline_service.dart';
import 'package:freecodecamp/service/learn/learn_service.dart';
import 'package:freecodecamp/service/authentication/authentication_service.dart';
import 'package:freecodecamp/ui/views/learn/superblock/superblock_view.dart';
import 'package:freecodecamp/ui/views/learn/test_runner.dart';
import 'package:freecodecamp/ui/widgets/setup_dialog_ui.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ChallengeViewModel extends BaseViewModel {
  String? _editorText;
  String? get editorText => _editorText;

  String _currentSelectedFile = '';
  String get currentSelectedFile => _currentSelectedFile;

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

  InAppWebViewController? _webviewController;
  InAppWebViewController? get webviewController => _webviewController;

  InAppWebViewController? _testController;
  InAppWebViewController? get testController => _testController;

  List<ConsoleMessage> _consoleMessages = [];
  List<ConsoleMessage> get consoleMessage => _consoleMessages;

  Syntax _currFileType = Syntax.HTML;
  Syntax get currFileType => _currFileType;

  bool _mounted = false;

  TestRunner runner = TestRunner();

  SnackbarService snackbar = locator<SnackbarService>();
  Future<Challenge>? _challenge;
  Future<Challenge>? get challenge => _challenge;

  Block? _block;
  Block? get block => _block;

  int _challengesCompleted = 0;
  int get challengesCompleted => _challengesCompleted;

  EditorOptions defaultEditorOptions = EditorOptions();

  final _dialogService = locator<DialogService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final LearnFileService fileService = locator<LearnFileService>();
  final LearnService learnService = locator<LearnService>();
  final learnOfflineService = locator<LearnOfflineService>();

  set setCurrentSelectedFile(String value) {
    _currentSelectedFile = value;
    notifyListeners();
  }

  set setIsRunningTests(bool value) {
    _runningTests = value;
    notifyListeners();
  }

  set setTestController(InAppWebViewController controller) {
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

  set setWebviewController(InAppWebViewController value) {
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

  set setMounted(bool value) {
    _mounted = value;
    notifyListeners();
  }

  set setConsoleMessages(List<ConsoleMessage> messages) {
    _consoleMessages = messages;
    notifyListeners();
  }

  void init(
    String url,
    Block block,
    String challengeId,
    int challengesCompleted,
  ) async {
    setupDialogUi();
    learnService.init();

    setChallenge = learnOfflineService.getChallenge(url, challengeId);
    Challenge challenge = await _challenge!;

    List<ChallengeFile> currentEditedChallenge = challenge.files
        .where((element) => element.editableRegionBoundaries.isNotEmpty)
        .toList();

    if (editorText == null) {
      String text = await fileService.getExactFileFromCache(
        challenge,
        currentEditedChallenge.isEmpty
            ? challenge.files.first
            : currentEditedChallenge.first,
      );

      if (text != '') {
        setEditorText = text;
      }
    }

    setBlock = block;
    setChallengesCompleted = challengesCompleted;
    setCurrentSelectedFile = currentEditedChallenge.isEmpty
        ? challenge.files[0].name
        : currentEditedChallenge[0].name;
  }

  void initiateFile(
    Editor editor,
    Challenge challenge,
    ChallengeFile currFile,
    bool hasRegion,
  ) async {
    if (!_mounted) {
      await Future.delayed(Duration.zero);
      editor.fileTextStream.sink.add(
        FileIDE(
          id: challenge.id + currFile.name,
          ext: currFile.ext.name,
          name: currFile.name,
          content: editorText ?? currFile.contents,
          hasRegion: hasRegion,
          region: EditorRegionOptions(
            start: hasRegion ? currFile.editableRegionBoundaries[0] : null,
            end: hasRegion ? currFile.editableRegionBoundaries[1] : null,
            condition: completedChallenge,
          ),
        ),
      );
      _mounted = true;
    }
  }

  // When the content in the editor is changed, save it to the cache. This prevents
  // the user from losing their work when switching between panels e.g, the preview.
  // The cache is disposed when the user switches to a new challenge.

  // show a message that the console is not yet available
  void consoleSnackbar() {
    snackbar.showSnackbar(
      title: 'Not yet available',
      message: '',
    );
  }
  // This prevents the user from requesting the challenge more than once
  // when swichting between preview and the challenge.

  Future<Challenge> initChallenge(String url) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    http.Response res = await http.get(Uri.parse(url));

    if (prefs.getString(url) == null) {
      if (res.statusCode == 200) {
        Challenge challenge = Challenge.fromJson(
          jsonDecode(
            res.body,
          )['result']['data']['challengeNode']['challenge'],
        );

        prefs.setString(url, res.body);

        return challenge;
      }
    }

    Challenge challenge = Challenge.fromJson(
      jsonDecode(
        prefs.getString(url) as String,
      )['result']['data']['challengeNode']['challenge'],
    );

    return challenge;
  }

  // This parses the preview document with the correct viewport size. This document
  // is then displayed in the preview panel. The preview document does not modify
  // the original challenge document.

  Future<String> parsePreviewDocument(String doc) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Challenge? currChallenge = await challenge;

    if (currChallenge == null) return parse(doc).outerHtml;

    List<ChallengeFile> cssFiles = currChallenge.files
        .where((ChallengeFile file) => file.ext == Ext.css)
        .toList();

    dom.Document document = parse(doc);

    List<ChallengeFile> currentFile = currChallenge.files
        .where((element) => element.ext == Ext.html)
        .toList();

    if (cssFiles.isNotEmpty) {
      String text = prefs.getString(
            '${currChallenge.id}.${currentFile[0].name}',
          ) ??
          currentFile[0].contents;

      document = parse(
        await fileService.parseCssDocmentsAsStyleTags(
          currChallenge,
          text,
        ),
      );
    }

    String viewPort = '''<meta content="width=device-width,
         initial-scale=1.0, maximum-scale=1.0,
         user-scalable=no" name="viewport">
         <meta>''';

    dom.Document viewPortParsed = parse(viewPort);
    dom.Node meta = viewPortParsed.getElementsByTagName('META')[0];

    document.getElementsByTagName('HEAD')[0].append(meta);

    return document.outerHtml;
  }

  Future providePreview(Challenge challenge) async {
    String cacheString = await fileService.getFirstFileFromCache(
      challenge,
      Ext.html,
    );

    Future document = parsePreviewDocument(cacheString);

    return document;
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

  void refresh() {
    setChallenge = challenge!;
    notifyListeners();
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
    if (currentSelectedFile.isNotEmpty) {
      ChallengeFile file = challenge.files.firstWhere(
        (file) => file.name == currentSelectedFile,
      );
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
        prefs.remove('${currChallenge.id}.${file.name}');
        prefs.remove('${currChallenge.id}${file.name}');
      }

      var challengeIndex = block!.challengeTiles.indexWhere(
        (element) => element.id == currChallenge.id,
      );

      String slug = block!.challengeTiles[challengeIndex].name
          .toLowerCase()
          .replaceAll(' ', '-');
      String url = await learnService.getBaseUrl('/page-data/learn');
      String challengeUrl =
          '$url/${block!.superBlock.dashedName}/${block!.dashedName}/$slug/page-data.json';

      await prefs.remove(challengeUrl);

      _navigationService.replaceWith(
        Routes.challengeView,
        arguments: ChallengeViewArguments(
            url: challengeUrl,
            block: block!,
            challengeId: currChallenge.id,
            challengesCompleted: challengesCompleted,
            isProject: block!.challenges.length == 1),
      );
    }
  }

  void updateProgressOnPop(BuildContext context) async {
    learnOfflineService.hasInternet().then(
          (value) => Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              transitionDuration: Duration.zero,
              pageBuilder: (
                context,
                animation1,
                animation2,
              ) =>
                  SuperBlockView(
                superBlockDashedName: block!.superBlock.dashedName,
                superBlockName: block!.superBlock.name,
                hasInternet: value,
              ),
            ),
          ),
        );
  }

  void passChallenge(Challenge? challenge) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (challenge != null) {
      List challengeFiles = challenge.files.map((file) {
        return {
          'contents':
              prefs.getString('${challenge.id}.${file.name}') ?? file.contents,
          'ext': file.ext.name,
          'history': file.history,
          'key': file.fileKey,
          'name': file.name,
        };
      }).toList();
      await learnService.postChallengeCompleted(challenge, challengeFiles);
    }
  }

  void goToNextChallenge(
    int maxChallenges,
    int challengesCompleted,
  ) async {
    Challenge? currChallenge = await challenge;
    if (currChallenge != null) {
      if (AuthenticationService.staticIsloggedIn) {
        passChallenge(currChallenge);
      }
      var challengeIndex = block!.challengeTiles.indexWhere(
        (element) => element.id == currChallenge.id,
      );
      if (challengeIndex == maxChallenges - 1) {
        _navigationService.back();
      } else {
        String challenge = block!.challengeTiles[challengeIndex + 1].name
            .toLowerCase()
            .replaceAll(' ', '-');
        String url = await learnService.getBaseUrl('/page-data/learn');
        _navigationService.replaceWith(
          Routes.challengeView,
          arguments: ChallengeViewArguments(
              url:
                  '$url/${block!.superBlock.dashedName}/${block!.dashedName}/$challenge/page-data.json',
              block: block!,
              challengeId: block!.challengeTiles[challengeIndex + 1].id,
              challengesCompleted: challengesCompleted + 1,
              isProject: block!.challenges.length == 1),
        );
      }
    }
  }
}
