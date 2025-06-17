import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_scroll_shadow/flutter_scroll_shadow.dart';
import 'package:freecodecamp/enums/panel_type.dart';
import 'package:freecodecamp/extensions/i18n_extension.dart';
import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';
import 'package:freecodecamp/ui/theme/fcc_theme.dart';
import 'package:freecodecamp/ui/views/learn/challenge/challenge_viewmodel.dart';
import 'package:freecodecamp/ui/views/learn/test_runner.dart';
import 'package:freecodecamp/ui/views/learn/widgets/console/console_view.dart';
import 'package:freecodecamp/ui/views/learn/widgets/dynamic_panel/panels/dynamic_panel.dart';
import 'package:freecodecamp/ui/views/news/html_handler/html_handler.dart';
import 'package:phone_ide/phone_ide.dart';
import 'package:stacked/stacked.dart';

class ChallengeView extends StatelessWidget {
  const ChallengeView({
    super.key,
    required this.block,
    required this.challenge,
    required this.challengesCompleted,
    required this.isProject,
  });

  final Challenge challenge;
  final Block block;
  final int challengesCompleted;
  final bool isProject;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ChallengeViewModel>.reactive(
      viewModelBuilder: () => ChallengeViewModel(),
      onViewModelReady: (model) {
        model.init(block, challenge, challengesCompleted);
      },
      onDispose: (model) {
        model.closeWebViews();
        model.disposeOfListeners();
      },
      builder: (context, model, child) {
        int maxChallenges = block.challenges.length;
        ChallengeFile currFile = model.currentFile(challenge);

        bool keyboard = MediaQuery.of(context).viewInsets.bottom != 0;

        model.initFile(challenge, currFile);

        if (model.showPanel) {
          FocusManager.instance.primaryFocus?.unfocus();
        }

        if (model.editor == null) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size(
              MediaQuery.sizeOf(context).width,
              model.showPanel ? 0 : 50,
            ),
            child: AppBar(
              automaticallyImplyLeading:
                  !(model.showPreview || model.showConsole),
              title: (() {
                if (model.showPreview) {
                  return const Text('PREVIEW',
                      style: TextStyle(fontWeight: FontWeight.bold));
                } else if (model.showConsole) {
                  return const Text('CONSOLE',
                      style: TextStyle(fontWeight: FontWeight.bold));
                } else {
                  return Row(
                    children: [customTabBar(model, challenge, context)],
                  );
                }
              })(),
            ),
          ),
          bottomNavigationBar: Container(
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.white70,
                ),
              ),
            ),
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: customBottomBar(
              model,
              keyboard,
              challenge,
              context,
            ),
          ),
          body: model.showConsole
              ? Column(
                  children: [
                    if (model.showPanel && !keyboard)
                      DynamicPanel(
                        challenge: challenge,
                        model: model,
                        panel: model.panelType,
                        maxChallenges: maxChallenges,
                        challengesCompleted: challengesCompleted,
                        editor: model.editor!,
                      ),
                    JavaScriptConsole(
                      // TODO: Update logic when working on JS challenges
                      // messages: model.consoleMessages,
                      messages: [],
                    ),
                  ],
                )
              : model.showPreview
                  ? Column(
                      children: [
                        if (model.showPanel && !keyboard)
                          DynamicPanel(
                            challenge: challenge,
                            model: model,
                            panel: model.panelType,
                            maxChallenges: maxChallenges,
                            challengesCompleted: challengesCompleted,
                            editor: model.editor!,
                          ),
                        ProjectPreview(
                          challenge: challenge,
                          model: model,
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        if (model.showPanel && !keyboard)
                          DynamicPanel(
                            challenge: challenge,
                            model: model,
                            panel: model.panelType,
                            maxChallenges: maxChallenges,
                            challengesCompleted: challengesCompleted,
                            editor: model.editor!,
                          ),
                        if (model.showTestsPanel)
                          Expanded(child: testList(challenge, model)),
                        if (!model.showTestsPanel)
                          Expanded(child: model.editor!),
                      ],
                    ),
        );
      },
    );
  }

  Widget customTabBar(
    ChallengeViewModel model,
    Challenge challenge,
    BuildContext context,
  ) {
    return Expanded(
      child: Row(
        children: [
          Expanded(
            child: DropdownButton<String>(
                isExpanded: true,
                dropdownColor: FccColors.gray85,
                value: model.currentSelectedFile,
                items: [
                  for (ChallengeFile file in challenge.files)
                    DropdownMenuItem(
                      value: file.name,
                      child: Text(
                        file.name,
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                ],
                onChanged: (file) {
                  model.setShowTestsPanel = false;
                  model.setCurrentSelectedFile =
                      file ?? challenge.files[0].name;
                  model.setMounted = false;
                  ChallengeFile currFile = model.currentFile(challenge);
                  model.initFile(challenge, currFile);
                },
                underline: SizedBox(),
                selectedItemBuilder: (context) {
                  return challenge.files.map((file) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          file.name,
                          style: TextStyle(color: Colors.white),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: const Icon(Icons.file_copy),
                        )
                      ],
                    );
                  }).toList();
                },
                icon: SizedBox.shrink()),
          ),
          SizedBox(width: 8),
          Expanded(
            child: TextButton.icon(
              onPressed: () {
                model.setShowTestsPanel = !model.showTestsPanel;
              },
              label: Text('Tests'),
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(
                  FccColors.gray90,
                ),
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                ),
              ),
              icon: Icon(
                Icons.science_outlined,
                size: 30,
              ),
              iconAlignment: IconAlignment.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget customBottomBar(
    ChallengeViewModel model,
    bool keyboard,
    Challenge challenge,
    BuildContext context,
  ) {
    return BottomAppBar(
      height: keyboard ? 116 : 72,
      padding: keyboard ? const EdgeInsets.only(bottom: 8) : null,
      color: const Color(0x990a0a23),
      child: Column(
        children: [
          if (keyboard)
            SymbolBar(
              model: model,
              editor: model.editor!,
            ),
          Row(
            children: [
              SizedBox(
                height: 1,
                width: 1,
                child: InAppWebView(
                  initialData: InAppWebViewInitialData(
                    data:
                        '<html><head><title>Test Runner</title></head><body></body></html>',
                    mimeType: 'text/html',
                    baseUrl: WebUri('http://localhost:8080/test-runner'),
                  ),
                  onWebViewCreated: (controller) {
                    model.setTestController = controller;
                  },
                  onConsoleMessage: (controller, console) {
                    log('Test Runner Console message: ${console.message}');
                  },
                  onLoadStop: (controller, url) async {
                    ScriptBuilder builder = ScriptBuilder();
                    final res = await controller.callAsyncJavaScript(
                      functionBody: ScriptBuilder.runnerScript,
                      arguments: {
                        'userCode': '',
                        'workerType':
                            builder.getWorkerType(challenge.challengeType),
                        'combinedCode': '',
                        'editableRegionContent': '',
                        'hooks': {
                          'beforeAll': '',
                        },
                      },
                    );
                    log('TestRunner: $res');
                  },
                  initialSettings: InAppWebViewSettings(
                    isInspectable: true,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                color:
                    model.showPanel && model.panelType == PanelType.instruction
                        ? Colors.white
                        : const Color.fromRGBO(0x3B, 0x3B, 0x4F, 1),
                child: IconButton(
                  icon: Icon(
                    Icons.info_outline_rounded,
                    size: 32,
                    color: model.showPanel &&
                            model.panelType == PanelType.instruction
                        ? const Color.fromRGBO(0x3B, 0x3B, 0x4F, 1)
                        : Colors.white,
                  ),
                  onPressed: () {
                    if (model.showPanel &&
                        model.panelType != PanelType.instruction) {
                      model.setPanelType = PanelType.instruction;
                    } else {
                      model.setPanelType = PanelType.instruction;
                      if (MediaQuery.of(context).viewInsets.bottom > 0) {
                        FocusManager.instance.primaryFocus?.unfocus();
                        if (!model.showPanel) {
                          model.setShowPanel = true;
                        }
                      } else {
                        model.setShowPanel = !model.showPanel;
                      }
                    }
                  },
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                color: !model.showPreview
                    ? const Color.fromRGBO(0x3B, 0x3B, 0x4F, 1)
                    : Colors.white,
                child: IconButton(
                  icon: Icon(
                    Icons.remove_red_eye_outlined,
                    size: 32,
                    color: model.showPreview
                        ? const Color.fromRGBO(0x3B, 0x3B, 0x4F, 1)
                        : Colors.white,
                  ),
                  onPressed: () async {
                    ChallengeFile currFile = model.currentFile(challenge);
                    model.setShowPreview = !model.showPreview;
                    model.initFile(challenge, currFile);
                  },
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                color: model.showConsole
                    ? Colors.white
                    : const Color.fromRGBO(0x3B, 0x3B, 0x4F, 1),
                child: challenge.files.any((file) => file.ext.name == 'js')
                    ? IconButton(
                        icon: Icon(
                          Icons.terminal,
                          size: 32,
                          color: model.showConsole
                              ? const Color.fromRGBO(0x3B, 0x3B, 0x4F, 1)
                              : Colors.white,
                        ),
                        onPressed: () {
                          model.setShowConsole = !model.showConsole;
                          model.setShowPreview = false;
                        },
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                      )
                    : null,
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      color: !model.hasTypedInEditor
                          ? const Color.fromARGB(255, 9, 79, 125)
                          : model.completedChallenge
                              ? const Color.fromRGBO(60, 118, 61, 1)
                              : const Color.fromRGBO(0x1D, 0x9B, 0xF0, 1),
                      child: IconButton(
                        icon: model.runningTests
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(),
                              )
                            : model.completedChallenge
                                ? const Icon(Icons.arrow_forward_rounded,
                                    size: 30)
                                : const Icon(Icons.done_rounded, size: 30),
                        onPressed: model.hasTypedInEditor
                            ? () async {
                                // NOTE: Check comment in line 605 in viewmodel
                                // model.setConsoleMessages = [];
                                // model.setUserConsoleMessages = [];
                                if (model.showPanel &&
                                    model.panelType == PanelType.pass) {
                                  model.learnService.goToNextChallenge(
                                    model.block!.challenges.length,
                                    challengesCompleted,
                                    challenge,
                                    block,
                                  );
                                }

                                model.runTests();
                              }
                            : null,
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget testList(Challenge challenge, ChallengeViewModel model) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: challenge.tests.length,
      itemBuilder: (context, index) {
        final test = challenge.tests[index];
        return ExpansionTile(
          backgroundColor: FccColors.gray90,
          collapsedBackgroundColor: FccColors.gray85,
          title: Builder(
            builder: (context) {
              final parser = HTMLParser(context: context);
              final widgets = parser.parse(
                test.instruction,
                isSelectable: true,
                removeParagraphMargin: true,
                fontColor: FccColors.gray00,
              );
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widgets,
              );
            },
          ),
          children: [
            Container(
              width: double.infinity,
              color: FccColors.gray80,
              constraints: BoxConstraints(minHeight: 120, maxHeight: 1000),
              child: Editor(
                defaultLanguage: 'javascript',
                path: '',
                defaultValue: test.javaScript,
                options: EditorOptions(
                    isEditable: false,
                    takeFullHeight: false,
                    showLinebar: false),
              ),
            ),
          ],
        );
      },
    );
  }
}

class SymbolBar extends StatelessWidget {
  const SymbolBar({
    super.key,
    required this.editor,
    required this.model,
  });

  final Editor editor;
  final ChallengeViewModel model;

  static List<String> symbols = [
    'Tab',
    '<',
    '/',
    '>',
    '\\',
    '\'',
    '"',
    '=',
    '{',
    '}'
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      height: 50,
      color: const Color(0xFF1b1b32),
      child: ScrollShadow(
        size: 12,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          controller: model.symbolBarScrollController,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          itemCount: symbols.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 4,
                horizontal: 1,
              ),
              child: TextButton(
                onPressed: () {
                  model.insertSymbol(symbols[index], editor);
                },
                style: TextButton.styleFrom(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.zero),
                  ),
                ),
                child: Text(symbols[index]),
              ),
            );
          },
        ),
      ),
    );
  }
}

class ProjectPreview extends StatelessWidget {
  const ProjectPreview({
    super.key,
    required this.challenge,
    required this.model,
  });

  final Challenge challenge;
  final ChallengeViewModel model;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FutureBuilder(
        future: model.providePreview(challenge),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data is String) {
              return InAppWebView(
                initialData: InAppWebViewInitialData(
                  data: snapshot.data as String,
                  mimeType: 'text/html',
                ),
                onWebViewCreated: (controller) {
                  model.setWebviewController = controller;
                },
                initialSettings: InAppWebViewSettings(
                  // TODO: Set this to true only in dev mode
                  isInspectable: true,
                ),
              );
            }
          }

          if (snapshot.hasError) {
            Center(
              child: Text(context.t.error),
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
