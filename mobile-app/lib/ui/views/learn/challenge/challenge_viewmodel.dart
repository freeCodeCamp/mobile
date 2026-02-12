import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/app/app.router.dart';
import 'package:freecodecamp/enums/dialog_type.dart';
import 'package:freecodecamp/enums/ext_type.dart';
import 'package:freecodecamp/enums/panel_type.dart';
import 'package:freecodecamp/extensions/i18n_extension.dart';
import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';
import 'package:freecodecamp/models/learn/daily_challenge_model.dart';
import 'package:freecodecamp/service/dio_service.dart';
import 'package:freecodecamp/service/learn/daily_challenge_service.dart';
import 'package:freecodecamp/service/learn/learn_file_service.dart';
import 'package:freecodecamp/service/learn/learn_offline_service.dart';
import 'package:freecodecamp/service/learn/learn_service.dart';
import 'package:freecodecamp/ui/views/learn/test_runner.dart';
import 'package:freecodecamp/ui/views/learn/utils/challenge_utils.dart';
import 'package:freecodecamp/ui/views/learn/widgets/description/description_widget_view.dart';
import 'package:freecodecamp/ui/views/learn/widgets/hint/hint_widget_view.dart';
import 'package:freecodecamp/ui/views/learn/widgets/pass/pass_widget_view.dart';
import 'package:freecodecamp/ui/widgets/setup_dialog_ui.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:phone_ide/controller/custom_text_controller.dart';
import 'package:phone_ide/models/textfield_data.dart';
import 'package:phone_ide/phone_ide.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ChallengeViewModel extends BaseViewModel {
  bool get isDailyChallenge => _isDailyChallenge;
  final InAppLocalhostServer _localhostServer =
      InAppLocalhostServer(documentRoot: 'assets/test_runner');

  Editor? _editor;
  Editor? get editor => _editor;

  String? _editorText;
  String? get editorText => _editorText;

  String _editorLanguage = 'html';
  String get editorLanguage => _editorLanguage;

  String _currentSelectedFile = '';
  String get currentSelectedFile => _currentSelectedFile;

  bool _showPreview = false;
  bool get showPreview => _showPreview;

  bool _showProjectPreview = false;
  bool get showProjectPreview => _showProjectPreview;

  bool _showConsole = false;
  bool get showConsole => _showConsole;

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

  bool _symbolBarIsScrollable = true;
  bool get symbolBarIsScrollable => _symbolBarIsScrollable;

  List<String> _testConsoleMessages = [];
  List<String> get testConsoleMessages => _testConsoleMessages;

  List<String> _userConsoleMessages = [];
  List<String> get userConsoleMessages => _userConsoleMessages;

  ScrollController symbolBarScrollController = ScrollController();

  PanelType _panelType = PanelType.instruction;
  PanelType get panelType => _panelType;

  InAppWebViewController? _webviewController;
  InAppWebViewController? get webviewController => _webviewController;

  InAppWebViewController? _testController;
  InAppWebViewController? get testController => _testController;

  DateTime? _challengeDate;
  bool _isDailyChallenge = false;

  DailyChallengeLanguage? _selectedDailyChallengeLanguage;
  DailyChallengeLanguage? get selectedDailyChallengeLanguage =>
      _selectedDailyChallengeLanguage;

  final HeadlessInAppWebView _babelWebView = HeadlessInAppWebView(
    initialData: InAppWebViewInitialData(
      data: '<html><head><title>Babel</title></head><body></body></html>',
      mimeType: 'text/html',
      baseUrl: WebUri('http://localhost:8080/babel-transformer'),
    ),
    onConsoleMessage: (controller, console) {
      log('Babel Console message: ${console.message}');
    },
    onLoadStop: (controller, url) async {
      final res = await controller.injectJavascriptFileFromAsset(
          assetFilePath: 'assets/test_runner/babel/babel.min.js');
      log('Babel load: $res');
    },
    initialSettings: InAppWebViewSettings(
      isInspectable: true,
    ),
  );

  bool _mounted = false;
  bool get mounted => _mounted;

  String _editableRegionContent = '';
  String get editableRegionContent => _editableRegionContent;

  SnackbarService snackbar = locator<SnackbarService>();

  Challenge? _challenge;
  Challenge? get challenge => _challenge;

  Block? _block;
  Block? get block => _block;

  EditorOptions defaultEditorOptions = EditorOptions();

  TextFieldData? _textFieldData;
  TextFieldData? get textFieldData => _textFieldData;

  final _dialogService = locator<DialogService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final LearnFileService fileService = locator<LearnFileService>();
  final LearnService learnService = locator<LearnService>();
  final learnOfflineService = locator<LearnOfflineService>();
  final dailyChallengeService = locator<DailyChallengeService>();

  final _dio = DioService.dio;

  late StreamSubscription<TextFieldData> _textFieldDataSub;
  late StreamSubscription<String> _onTextChangeSub;
  StreamSubscription<String>? _editableRegionSub;

  set setCurrentSelectedFile(String value) {
    _currentSelectedFile = value;
    notifyListeners();
  }

  set setIsRunningTests(bool value) {
    _runningTests = value;
    notifyListeners();
  }

  set setEditableRegionContent(String value) {
    _editableRegionContent = value;
    notifyListeners();
  }

  set setTestController(InAppWebViewController controller) {
    _testController = controller;
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

  set setShowProjectPreview(bool value) {
    _showProjectPreview = value;
    notifyListeners();
  }

  set setShowConsole(bool value) {
    _showConsole = value;
    notifyListeners();
  }

  set setHasTypedInEditor(bool value) {
    _hasTypedInEditor = true;
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

  set setBlock(Block block) {
    _block = block;
    notifyListeners();
  }

  set setMounted(bool value) {
    _mounted = value;
    notifyListeners();
  }

  set setTextFieldData(TextFieldData textfieldData) {
    _textFieldData = textfieldData;
    notifyListeners();
  }

  set setSymbolBarIsScrollable(bool value) {
    _symbolBarIsScrollable = value;
    notifyListeners();
  }

  set setEditor(Editor editor) {
    _editor = editor;
    notifyListeners();
  }

  set setEditorLanguage(String value) {
    _editorLanguage = value;
    notifyListeners();
  }

  set setTestConsoleMessages(List<String> messages) {
    _testConsoleMessages = messages;
    notifyListeners();
  }

  set setUserConsoleMessages(List<String> messages) {
    _userConsoleMessages = messages;
    notifyListeners();
  }

  bool _showTestsPanel = false;
  bool get showTestsPanel => _showTestsPanel;

  set setShowTestsPanel(bool value) {
    _showTestsPanel = value;
    notifyListeners();
  }

  bool _drawerOpened = false;
  bool get drawerOpened => _drawerOpened;
  set setDrawerOpened(bool value) {
    _drawerOpened = value;
    notifyListeners();
  }

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;
  set setScaffoldKey(GlobalKey<ScaffoldState> key) {
    _scaffoldKey = key;
    notifyListeners();
  }

  void init({
    required Block block,
    required Challenge challenge,
    required DateTime? challengeDate,
  }) async {
    await _babelWebView.run();
    await _localhostServer.start();

    _challengeDate = challengeDate;
    _isDailyChallenge = challengeDate != null;

    if (challengeDate != null) {
      await loadSelectedDailyChallengeLanguage();
    }

    setupDialogUi();

    setChallenge = challenge;
    setBlock = block;

    listenToSymbolBarScrollController();
  }

  Future<void> setSelectedDailyChallengeLanguage(
      DailyChallengeLanguage lang, DateTime challengeDate) async {
    setShowTestsPanel = false;
    _selectedDailyChallengeLanguage = lang;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedDailyChallengeLanguage', lang.name);

    // Switching languages require re-fetching the challenge data
    // as we only store the data for a single language in the `challenge` object.
    // This, however, is not expensive because we do cache the challenge data in dailyChallengeService.
    final formattedChallengeDate = formatChallengeDate(challengeDate);
    Challenge dailyChallenge = await dailyChallengeService.getDailyChallenge(
      formattedChallengeDate,
      _block!,
      language: lang,
    );

    setChallenge = dailyChallenge;
    setMounted = false;
    initFile(dailyChallenge, dailyChallenge.files[0]);
  }

  void closeWebViews() async {
    await _babelWebView.dispose();
    await _localhostServer.close();
  }

  void initFile(
    Challenge challenge,
    ChallengeFile currFile,
  ) async {
    if (!_mounted) {
      String fileContents = await fileService.getExactFileFromCache(
        challenge,
        currFile,
      );

      setCurrentSelectedFile = getFullFileName(currFile);
      setEditorText = fileContents;
      setEditorLanguage = currFile.ext.value;
      initEditor(challenge, currFile);
      setMounted = true;
    }
  }

  void initEditor(Challenge challenge, ChallengeFile file) {
    bool editableRegion = file.editableRegionBoundaries.isNotEmpty;

    EditorOptions options = EditorOptions(
      regionOptions: editableRegion
          ? EditorRegionOptions(
              start: file.editableRegionBoundaries[0],
              end: file.editableRegionBoundaries[1],
            )
          : null,
      fontFamily: 'Hack',
    );

    Editor editor = Editor(
      key: ValueKey(editorText),
      defaultLanguage: editorLanguage,
      defaultValue: editorText ?? '',
      path: getFullFilePath(challenge, file),
      options: options,
    );

    setEditor = editor;

    initEditorListeners(challenge, file, editor);
  }

  void initEditorListeners(
    Challenge challenge,
    ChallengeFile file,
    Editor editor,
  ) {
    bool editableRegion = file.editableRegionBoundaries.isNotEmpty;

    _textFieldDataSub = editor.textfieldData.stream.listen((textfieldData) {
      setTextFieldData = textfieldData;
      setShowPanel = false;
    });

    _onTextChangeSub = editor.onTextChange.stream.listen((text) {
      fileService.saveFileInCache(
        challenge,
        currentSelectedFile,
        text,
      );

      setEditorText = text;
      setHasTypedInEditor = true;
      setCompletedChallenge = false;
    });

    if (editableRegion) {
      _editableRegionSub = editor.editableRegion.stream.listen((region) {
        setEditableRegionContent = region;
      });
    }
  }

  void disposeOfListeners() {
    _textFieldDataSub.cancel();
    _onTextChangeSub.cancel();

    if (_editableRegionSub != null) {
      _editableRegionSub!.cancel();
    }
  }

  void listenToSymbolBarScrollController() {
    symbolBarScrollController.addListener(() {
      ScrollPosition sp = symbolBarScrollController.position;

      if (sp.pixels >= sp.maxScrollExtent) {
        setSymbolBarIsScrollable = false;
      } else if (!symbolBarIsScrollable) {
        setSymbolBarIsScrollable = true;
      }
    });
  }

  // This function allows the symbols to be insterted into the text controllers
  void insertSymbol(String symbol, Editor editor) async {
    final TextEditingControllerIDE focused = textFieldData!.controller;
    final RegionPosition position = textFieldData!.position;
    final String text = focused.text;
    final selection = focused.selection;

    if (symbol == 'Tab') {
      symbol = '\t';
    }

    final newText = text.replaceRange(selection.start, selection.end, symbol);
    focused.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(
        offset: selection.start + 1,
      ),
    );

    editor.textfieldData.sink.add(
      TextFieldData(controller: focused, position: position),
    );
  }

  // This prevents the user from requesting the challenge more than once
  // when swichting between preview and the challenge.

  Future<Challenge> initChallenge(String url) async {
    // NOTE: Function is not used anywhere
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Response res = await _dio.get(url);

    if (prefs.getString(url) == null) {
      if (res.statusCode == 200) {
        Challenge challenge = Challenge.fromJson(res.data);

        await prefs.setString(url, res.data);

        return challenge;
      }
    }

    Challenge challenge = Challenge.fromJson(
      jsonDecode(prefs.getString(url) as String),
    );

    return challenge;
  }

  // This parses the preview document with the correct viewport size. This document
  // is then displayed in the preview panel. The preview document does not modify
  // the original challenge document.

  Future<String> parsePreviewDocument(String doc) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Challenge? currChallenge = challenge;

    if (currChallenge == null) return parse(doc).outerHtml;

    List<ChallengeFile> cssFiles = currChallenge.files
        .where((ChallengeFile file) => file.ext == Ext.css)
        .toList();

    List<ChallengeFile> jsFiles = currChallenge.files
        .where((ChallengeFile file) => file.ext == Ext.js)
        .toList();

    Document document = parse(doc);
    String? cssParsed, jsParsed;

    List<ChallengeFile> currentFile = currChallenge.files
        .where((element) => element.ext == Ext.html)
        .toList();

    String text = prefs.getString(
          '${currChallenge.id}.${getFullFileName(currentFile[0])}',
        ) ??
        currentFile[0].contents;

    // TODO: Remove check since we do it in function also
    if (cssFiles.isNotEmpty) {
      cssParsed = await fileService.parseCssDocumentsAsStyleTags(
        currChallenge,
        text,
      );

      document = parse(cssParsed);
    }

    if (jsFiles.isNotEmpty) {
      jsParsed = await fileService.parseJsDocumentsAsScriptTags(
        currChallenge,
        cssParsed ?? text,
        _babelWebView.webViewController,
      );

      document = parse(jsParsed);
    }

    String viewPort = '''<meta content="width=device-width,
         initial-scale=1.0, maximum-scale=1.0,
         user-scalable=no" name="viewport">
         <meta>''';

    Document viewPortParsed = parse(viewPort);
    Node meta = viewPortParsed.getElementsByTagName('META')[0];

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

  String parseUsersConsoleMessages(String string) {
    if (!string.startsWith('testMSG')) {
      return '<p>$string</p>';
    }

    return string;
  }

  void refresh() {
    setChallenge = challenge!;
    notifyListeners();
  }

  String getFullFileName(ChallengeFile file) {
    return '${file.name}.${file.ext.value}';
  }

  String getFullFilePath(Challenge challenge, ChallengeFile file) {
    return '/${challenge.id}/${getFullFileName(file)}';
  }

  ChallengeFile currentFile(Challenge challengeParam) {
    // For daily challenges, we don't use the `challenge` param passed from the view
    // but use the `_challenge` variable as the source of truth instead.
    // This is because when a camper switches languages,
    // we load a new `challenge` object and store it in `_challenge`.
    Challenge currChallenge =
        (isDailyChallenge && challenge != null) ? challenge! : challengeParam;

    if (currentSelectedFile.isNotEmpty) {
      ChallengeFile file = currChallenge.files.firstWhere(
        (file) => getFullFileName(file) == currentSelectedFile,
      );
      return file;
    }

    List<ChallengeFile>? fileWithEditableRegion = currChallenge.files
        .where((file) => file.editableRegionBoundaries.isNotEmpty)
        .toList();

    if (fileWithEditableRegion.isNotEmpty) {
      return fileWithEditableRegion[0];
    }

    return currChallenge.files[0];
  }

  void resetCode(Editor editor, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    DialogResponse? res = await _dialogService.showCustomDialog(
      barrierDismissible: true,
      variant: DialogType.buttonForm,
      title: context.t.reset_code,
      description: context.t.reset_description,
      mainButtonTitle: context.t.reset,
    );

    if (res?.confirmed != true) {
      return;
    }

    Challenge currChallenge = challenge!;

    for (ChallengeFile file in currChallenge.files) {
      // NOTE: Removes file content from cache
      await prefs.remove('${currChallenge.id}.${getFullFileName(file)}');
      // NOTE: Removes file editable region boundaries from cache
      await prefs.remove(getFullFilePath(currChallenge, file));
    }

    if (isDailyChallenge) {
      final formattedChallengeDate = formatChallengeDate(_challengeDate!);
      Challenge refreshedChallenge =
          await dailyChallengeService.getDailyChallenge(
        formattedChallengeDate,
        block!,
        language: selectedDailyChallengeLanguage!,
      );

      setChallenge = refreshedChallenge;

      closeWebViews();
      disposeOfListeners();

      _navigationService.replaceWith(
        Routes.challengeTemplateView,
        arguments: ChallengeTemplateViewArguments(
          block: block!,
          challengeId: currChallenge.id,
          challengeDate: _challengeDate,
        ),
      );
    } else {
      // For standard challenges, keep the existing behavior
      var challengeIndex = block!.challengeTiles.indexWhere(
        (element) => element.id == currChallenge.id,
      );

      String slug = block!.challengeTiles[challengeIndex].id;
      String url = LearnService.baseUrl;
      String challengeUrl =
          '$url/challenges/${block!.superBlock.dashedName}/${block!.dashedName}/$slug.json';

      await prefs.remove(challengeUrl);

      closeWebViews();
      disposeOfListeners();

      _navigationService.replaceWith(
        Routes.challengeTemplateView,
        arguments: ChallengeTemplateViewArguments(
          block: block!,
          challengeId: currChallenge.id,
        ),
      );
    }
  }

  String replacePlaceholders(
    String instruction,
    Map<dynamic, dynamic>? failedTestErr,
  ) {
    return instruction
        .replaceAll(
            '--fcc-expected--', (failedTestErr?['expected'] ?? '').toString())
        .replaceAll(
            '--fcc-actual--', (failedTestErr?['actual'] ?? '').toString());
  }

  void runTests() async {
    setShowPanel = false;
    setIsRunningTests = true;
    ChallengeTest? failedTest;
    Map<dynamic, dynamic>? failedTestErr;
    ScriptBuilder builder = ScriptBuilder();
    List<String> failedTestsConsole = [];

    _userConsoleMessages = [];
    setTestConsoleMessages = ['<p>// running tests</p>'];

    String userCode;
    try {
      userCode = await builder.buildUserCode(
        challenge!,
        _babelWebView.webViewController,
      );
    } catch (e) {
      String errorMessage = e.toString();
      if (errorMessage.contains('Babel transpilation failed')) {
        errorMessage = errorMessage.replaceFirst('Exception: ', '');
      }
      String userFriendlyMessage = parseSyntaxError(errorMessage);

      setPanelType = PanelType.hint;
      setHint = '<p>$userFriendlyMessage</p>';
      setTestConsoleMessages = [
        ...testConsoleMessages,
        '<p>$userFriendlyMessage</p>',
        '<p>// tests completed</p>',
      ];
      setIsRunningTests = false;
      _scaffoldKey.currentState?.openEndDrawer();
      return;
    }

    if ([1, 26, 28].contains(challenge!.challengeType)) {
      final evalResult = await testController!.callAsyncJavaScript(
        functionBody: userCode,
      );
      if (evalResult != null && evalResult.error != null) {
        setUserConsoleMessages = [
          if (userConsoleMessages.isNotEmpty)
            ...userConsoleMessages.sublist(0, userConsoleMessages.length - 1),
          '<p>${evalResult.error}</p>',
        ];
      }
    }

    // TODO: Handle the case when the test runner is not created
    // ignore: unused_local_variable
    final updateTestRunnerRes = await testController!.callAsyncJavaScript(
      functionBody: ScriptBuilder.runnerScript,
      arguments: {
        'userCode': userCode,
        'workerType': builder.getWorkerType(challenge!.challengeType),
        'combinedCode': await builder.combinedCode(challenge!),
        'editableRegionContent': editableRegionContent,
        'hooks': {
          'beforeAll': challenge!.hooks.beforeAll,
          'beforeEach': challenge!.hooks.beforeEach,
          'afterEach': challenge!.hooks.afterEach,
        },
      },
    );

    for (ChallengeTest test in challenge!.tests) {
      final testRes = await testController!.callAsyncJavaScript(
        functionBody: ScriptBuilder.testExecutionScript,
        arguments: {
          'testStr': test.javaScript,
        },
      );
      if (testRes != null && testRes.value['pass'] == null) {
        log('TEST FAILED: ${test.instruction} - ${test.javaScript} - ${testRes.value['err']}');
        failedTest = failedTest ?? test;
        failedTestErr = failedTestErr ?? testRes.value['err'] as Map;
        failedTestsConsole.add(
          '<li>${replacePlaceholders(test.instruction, failedTestErr)}</li>',
        );
      } else if (testRes == null) {
        log('TEST RESULT NULL: $testRes');
        throw Exception('Test result is null ${testRes.toString()}');
      }
    }

    if (failedTest != null) {
      setPanelType = PanelType.hint;
      setHint = replacePlaceholders(failedTest.instruction, failedTestErr);
      _scaffoldKey.currentState?.openEndDrawer();
    } else {
      setPanelType = PanelType.pass;
      setCompletedChallenge = true;
      _scaffoldKey.currentState?.openEndDrawer();
    }

    setTestConsoleMessages = [
      ...testConsoleMessages,
      failedTestsConsole.isNotEmpty
          ? '<ol>${failedTestsConsole.join()}</ol>'
          : '',
      '<p>// tests completed</p>',
    ];
    setIsRunningTests = false;
    // TODO: Do we still need this variable
    setShowPanel = true;
  }

  Future<void> loadSelectedDailyChallengeLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? langStr = prefs.getString('selectedDailyChallengeLanguage');

    _selectedDailyChallengeLanguage =
        DailyChallengeService.parseLanguageFromString(langStr);
    notifyListeners();
  }

  Widget getPanelWidget({
    required PanelType panelType,
    required Challenge challenge,
    required ChallengeViewModel model,
    required int maxChallenges,
  }) {
    switch (panelType) {
      case PanelType.instruction:
        return DescriptionView(
          description: challenge.description,
          instructions: challenge.instructions,
          challengeModel: model,
          maxChallenges: maxChallenges,
          title: challenge.title,
        );
      case PanelType.hint:
        return HintWidgetView(
          hint: model.hint,
          challengeModel: model,
          editor: model.editor!,
        );
      case PanelType.pass:
        return PassWidgetView(
          challengeModel: model,
          maxChallenges: maxChallenges,
        );
      default:
        return Container();
    }
  }
}
