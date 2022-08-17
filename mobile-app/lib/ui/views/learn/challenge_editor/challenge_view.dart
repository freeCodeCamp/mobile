import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_code_editor/controller/editor_view_controller.dart';
import 'package:flutter_code_editor/controller/language_controller/syntax/index.dart';
import 'package:flutter_code_editor/editor/editor.dart';
import 'package:flutter_code_editor/models/editor_options.dart';
import 'package:flutter_code_editor/models/file_model.dart';
import 'package:freecodecamp/enums/panel_type.dart';
import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';
import 'package:freecodecamp/ui/views/learn/challenge_editor/challenge_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:freecodecamp/ui/views/learn/widgets/description/description_widget_view.dart';
import 'package:freecodecamp/ui/views/learn/widgets/hint/hint_widget_view.dart';
import 'package:freecodecamp/ui/views/learn/widgets/pass/pass_widget_view.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:stacked/stacked.dart';

class ChallengeView extends StatelessWidget {
  const ChallengeView({
    Key? key,
    required this.url,
    required this.block,
    required this.challengesCompleted,
  }) : super(key: key);

  final String url;
  final Block block;
  final int challengesCompleted;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ChallengeModel>.reactive(
        viewModelBuilder: () => ChallengeModel(),
        onModelReady: (model) => {
              model.setAppBarState(context),
              model.init(url, block, challengesCompleted)
            },
        builder: (context, model, child) => FutureBuilder<Challenge?>(
              future: model.challenge,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  Challenge challenge = snapshot.data!;

                  int maxChallenges = block.challenges.length;

                  Editor editor = Editor(
                    language: Syntax.HTML,
                    openedFile: FileIDE(
                        fileExplorer: null,
                        fileName: model.currentFile(challenge).name,
                        filePath: '',
                        fileContent: model.editorText ??
                            model.currentFile(challenge).contents,
                        parentDirectory: ''),
                  );

                  editor.onTextChange.stream.listen((text) {
                    model.saveTextInCache(text, challenge);
                    model.setEditorText = text;
                    model.setCompletedChallenge = false;
                  });

                  EditorViewController controller = EditorViewController(
                    language: Syntax.HTML,
                    options: const EditorOptions(
                        useFileExplorer: false,
                        canCloseFiles: false,
                        showAppBar: false,
                        showTabBar: false),
                    editor: editor,
                  );

                  log('new instance of editor');
                  log(model.currentSelectedFile.toString());
                  return Scaffold(
                      appBar: !model.hideAppBar
                          ? AppBar(
                              automaticallyImplyLeading: false,
                              title: challenge.files.length == 1
                                  ? const Text('Editor')
                                  : null,
                              actions: [
                                if (challenge.files.length > 1)
                                  for (ChallengeFile file in challenge.files)
                                    customTabBar(file, model, challenge, editor)
                              ],
                            )
                          : null,
                      bottomNavigationBar: Padding(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: bottomBar(
                              model, challenge, context, controller, editor)),
                      body: !model.showPreview
                          ? Column(
                              children: [
                                model.showPanel &&
                                        MediaQuery.of(context)
                                                .viewInsets
                                                .bottom ==
                                            0
                                    ? DynamicPanel(
                                        challenge: challenge,
                                        model: model,
                                        panel: model.panelType,
                                        maxChallenges: maxChallenges,
                                        challengesCompleted:
                                            challengesCompleted,
                                        editor: editor,
                                      )
                                    : Container(),
                                Expanded(child: editor)
                              ],
                            )
                          : Column(
                              children: [
                                model.showPanel &&
                                        MediaQuery.of(context)
                                                .viewInsets
                                                .bottom ==
                                            0
                                    ? DynamicPanel(
                                        challenge: challenge,
                                        model: model,
                                        panel: model.panelType,
                                        maxChallenges: maxChallenges,
                                        challengesCompleted:
                                            challengesCompleted,
                                        editor: editor)
                                    : Container(),
                                Expanded(
                                  child: WebView(
                                    userAgent: 'random',
                                    javascriptMode: JavascriptMode.unrestricted,
                                    onWebViewCreated:
                                        (WebViewController webcontroller) {
                                      model.setWebviewController =
                                          webcontroller;
                                      webcontroller.loadUrl(Uri.dataFromString(
                                              model.parsePreviewDocument(model
                                                      .editorText ??
                                                  challenge.files[0].contents),
                                              mimeType: 'text/html',
                                              encoding: utf8)
                                          .toString());
                                    },
                                  ),
                                ),
                              ],
                            ));
                }

                return Scaffold(
                    appBar: AppBar(
                      title: const Text('Loading..'),
                      automaticallyImplyLeading: false,
                    ),
                    body: Row(
                      children: [
                        Expanded(
                          child: EditorViewController(
                            options: const EditorOptions(
                                useFileExplorer: false,
                                canCloseFiles: false,
                                showAppBar: false,
                                showTabBar: false),
                            editor: Editor(language: Syntax.HTML),
                          ),
                        ),
                      ],
                    ));
              },
            ));
  }

  Widget customTabBar(ChallengeFile file, ChallengeModel model,
      Challenge challenge, Editor editor) {
    return Expanded(
        child: Container(
      decoration: BoxDecoration(
          border: Border(
              bottom: model.currentFile(challenge).name == file.name
                  ? const BorderSide(width: 4, color: Colors.blue)
                  : const BorderSide())),
      child: ElevatedButton(
          onPressed: () async {
            model.setCurrentSelectedFile = '${file.name}.${file.ext.name}';
            String currText = await model.getTextFromCache(challenge);
            editor.fileTextStream.sink.add(currText == ''
                ? model.currentFile(challenge).contents
                : currText);
            model.setEditorText = currText;
            model.setShowPreview = false;
          },
          child: Text(
            '${file.name}.${file.ext.name}',
            style: TextStyle(
                color: model.currentFile(challenge).name == file.name
                    ? Colors.blue
                    : Colors.white,
                fontWeight: model.currentFile(challenge).name == file.name
                    ? FontWeight.bold
                    : null),
          )),
    ));
  }

  Widget bottomBar(ChallengeModel model, Challenge challenge,
      BuildContext context, EditorViewController controller, Editor editor) {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      bool keyboardPresent = MediaQuery.of(context).viewInsets.bottom > 0;

      if (keyboardPresent && !model.showPanel) {
        if (!model.hideAppBar && model.manuallyHiddenAppBar) {
          model.setHideAppBar = true;
        }
      } else if (!keyboardPresent && !model.showPanel) {
        if (model.hideAppBar) {
          model.setHideAppBar = false;
        }
      }
    });
    return BottomAppBar(
      color: const Color(0xFF0a0a23),
      child: Row(
        children: [
          SizedBox(
            height: 1,
            width: 1,
            child: WebView(
              onWebViewCreated: (WebViewController webcontroller) async {
                model.setTestController = webcontroller;
                // controller.editorTextStream.stream.listen((event) async {
                //   model.runner.setWebViewContent(
                //       event, challenge.tests, model.testController!);
                // });
              },
              javascriptMode: JavascriptMode.unrestricted,
              javascriptChannels: {
                JavascriptChannel(
                  name: 'Flutter',
                  onMessageReceived: (JavascriptMessage message) async {
                    model.runner.setTestDocument = message.message;
                    List<ChallengeTest> tests =
                        await model.runner.testRunner(challenge.tests);

                    ChallengeTest? test = model.returnFirstFailedTest(tests);

                    if (test != null) {
                      model.setPanelType = PanelType.hint;
                      model.setHint = test.instruction;
                      model.setShowPanel = true;
                    } else {
                      model.setPanelType = PanelType.pass;
                      model.setCompletedChallenge = true;
                      model.setShowPanel = true;
                    }
                  },
                )
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.all(8),
            color: model.showPanel && model.panelType == PanelType.instruction
                ? Colors.white
                : const Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
            child: IconButton(
              icon: FaIcon(
                FontAwesomeIcons.info,
                size: 32,
                color:
                    model.showPanel && model.panelType == PanelType.instruction
                        ? const Color.fromRGBO(0x2A, 0x2A, 0x40, 1)
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
                      model.setHideAppBar = true;
                    }
                  } else {
                    model.setHideAppBar = !model.hideAppBar;
                    model.setShowPanel = !model.showPanel;
                  }
                }
              },
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
          ),
          Container(
            margin: const EdgeInsets.all(8),
            color: !model.showPreview
                ? const Color.fromRGBO(0x2A, 0x2A, 0x40, 1)
                : Colors.white,
            child: IconButton(
              icon: Icon(Icons.remove_red_eye_outlined,
                  color: model.showPreview
                      ? const Color.fromRGBO(0x2A, 0x2A, 0x40, 1)
                      : Colors.white),
              onPressed: () async {
                String currText = await model.getTextFromCache(challenge);
                editor.fileTextStream.sink.add(currText == ''
                    ? model.currentFile(challenge).contents
                    : currText);
                model.setEditorText = currText == ''
                    ? model.currentFile(challenge).contents
                    : currText;
                model.setShowPreview = !model.showPreview;
              },
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  margin: const EdgeInsets.all(8),
                  color: model.completedChallenge
                      ? const Color.fromRGBO(0x20, 0xD0, 0x32, 1)
                      : const Color.fromRGBO(0x1D, 0x9B, 0xF0, 1),
                  child: IconButton(
                    icon: model.completedChallenge
                        ? const FaIcon(FontAwesomeIcons.arrowRight)
                        : const FaIcon(FontAwesomeIcons.check),
                    onPressed: () async => {
                      FocusManager.instance.primaryFocus?.unfocus(),
                      model.testController?.runJavascript('''
                                (function(){Flutter.postMessage(window.document.body.outerHTML)})();
                              '''),
                    },
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DynamicPanel extends StatelessWidget {
  const DynamicPanel(
      {Key? key,
      required this.challenge,
      required this.model,
      required this.panel,
      required this.maxChallenges,
      required this.challengesCompleted,
      required this.editor})
      : super(key: key);

  final Challenge challenge;
  final ChallengeModel model;
  final PanelType panel;
  final int maxChallenges;
  final int challengesCompleted;

  final Editor editor;

  Widget panelHandler(PanelType panel) {
    switch (panel) {
      case PanelType.instruction:
        return DescriptionView(
          description: challenge.description,
          instructions: challenge.instructions,
          challengeModel: model,
          editorText: model.editorText,
          maxChallenges: maxChallenges,
          title: challenge.title,
        );
      case PanelType.pass:
        return PassWidgetView(
          challengeModel: model,
          challengesCompleted: challengesCompleted,
          maxChallenges: maxChallenges,
        );
      case PanelType.hint:
        return HintWidgetView(
          hint: model.hint,
          challengeModel: model,
          editor: editor,
        );
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height * 0.75,
        color: const Color(0xFF0a0a23),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 30, 16, 16),
          child: panelHandler(panel),
        ));
  }
}
