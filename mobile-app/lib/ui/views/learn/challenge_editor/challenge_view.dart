import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_code_editor/controller/editor_view_controller.dart';
import 'package:flutter_code_editor/editor/editor.dart';
import 'package:flutter_code_editor/models/editor_options.dart';
import 'package:flutter_code_editor/models/file_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:freecodecamp/enums/panel_type.dart';

import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';
import 'package:freecodecamp/ui/views/learn/challenge_editor/challenge_model.dart';
import 'package:freecodecamp/ui/views/learn/widgets/custom_tab_bar/custom_tab_bar.dart';

import 'package:freecodecamp/ui/views/learn/widgets/dynamic_panel/dynamic_panel.dart';
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
        onModelReady: (model) => {model.init(url, block, challengesCompleted)},
        builder: (context, model, child) => FutureBuilder<Challenge?>(
              future: model.challenge,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  Challenge challenge = snapshot.data!;

                  int maxChallenges = block.challenges.length;
                  ChallengeFile currFile = model.currentFile(challenge);

                  bool keyBoardIsActive =
                      MediaQuery.of(context).viewInsets.bottom != 0;

                  Editor editor = Editor(
                    language: currFile.ext.name.toUpperCase(),
                    openedFile: FileIDE(
                        fileExplorer: null,
                        fileName: currFile.name,
                        filePath: '',
                        fileContent: model.editorText ?? currFile.contents,
                        parentDirectory: ''),
                  );

                  editor.onTextChange.stream.listen((text) {
                    model.saveTextInCache(text, challenge);
                    model.setEditorText = text;
                    model.setCompletedChallenge = false;
                  });
                  SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
                    bool keyboardPresent =
                        MediaQuery.of(context).viewInsets.bottom > 0;

                    if (keyboardPresent && !model.showPanel) {
                      if (model.hideAppBar) {
                        model.setHideAppBar = false;
                      }
                    } else if (keyboardPresent && model.showPanel) {
                      if (model.hideAppBar) {
                        model.setHideAppBar = false;
                      }
                    } else if (!keyboardPresent && model.showPanel) {
                      if (!model.hideAppBar) {
                        model.setHideAppBar = true;
                      }
                    } else {
                      if (model.hideAppBar) {
                        model.setHideAppBar = false;
                      }
                    }

                    // if (!keyboardPresent) {
                    //   if (model.hideAppBar) {
                    //     model.setHideAppBar = false;
                    //   }
                    // } else if (model.showPanel) {
                    //   if (!model.hideAppBar) {
                    //     model.setHideAppBar = true;
                    //   }
                    // }
                  });
                  // ignore: unused_local_variable
                  EditorViewController controller = EditorViewController(
                    options: const EditorOptions(
                        useFileExplorer: false,
                        canCloseFiles: false,
                        showAppBar: false,
                        showTabBar: false),
                    editor: editor,
                  );

                  return Scaffold(
                      appBar: !model.hideAppBar
                          ? AppBar(
                              automaticallyImplyLeading: false,
                              title: challenge.files.length == 1
                                  ? const Text('Editor')
                                  : null,
                              actions: [
                                if (model.showPreview)
                                  Expanded(
                                      child: Container(
                                    decoration: model.showPreview
                                        ? const BoxDecoration(
                                            border: Border(
                                                bottom: BorderSide(
                                                    width: 4,
                                                    color: Colors.blue)))
                                        : null,
                                    child: Container(
                                      decoration: model.showConsole
                                          ? const BoxDecoration(
                                              border: Border(
                                                  bottom: BorderSide(
                                                      width: 4,
                                                      color: Colors.blue)))
                                          : null,
                                      child: ElevatedButton(
                                        child: const Text('Preview'),
                                        onPressed: () {},
                                      ),
                                    ),
                                  )),
                                if (model.showPreview)
                                  Expanded(
                                      child: ElevatedButton(
                                    child: const Text('Console'),
                                    onPressed: () {
                                      model.consoleSnackbar();
                                    },
                                  )),
                                if (!model.showPreview)
                                  if (challenge.files.length > 1)
                                    for (ChallengeFile file in challenge.files)
                                      CustomTabBar(
                                        challenge: challenge,
                                        file: file,
                                        editor: editor,
                                        model: model,
                                      )
                              ],
                            )
                          : null,
                      bottomNavigationBar: Padding(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: customBottomBar(
                            model,
                            challenge,
                            editor,
                            context,
                            maxChallenges,
                            challengesCompleted,
                          )),
                      body: !model.showPreview
                          ? Column(
                              children: [
                                model.showPanel && !keyBoardIsActive
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
                                model.showPanel && !keyBoardIsActive
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
                                    onWebViewCreated: (WebViewController
                                        webcontroller) async {
                                      model.setWebviewController =
                                          webcontroller;
                                      webcontroller.loadUrl(Uri.dataFromString(
                                              await model.parsePreviewDocument(
                                                  await model
                                                      .getExactFileFromCache(
                                                          challenge,
                                                          challenge.files[0])),
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
                            editor: Editor(language: 'HTML'),
                          ),
                        ),
                      ],
                    ));
              },
            ));
  }

  Widget customBottomBar(
    ChallengeModel model,
    Challenge challenge,
    Editor editor,
    BuildContext context,
    int maxChallenges,
    int challengesCompleted,
  ) {
    if (model.testController != null) {
      editor.onTextChange.stream.listen((event) {
        model.setHasTypedInEditor = true;
      });
    }

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
              },
              javascriptMode: JavascriptMode.unrestricted,
              javascriptChannels: {
                JavascriptChannel(
                  name: 'Print',
                  onMessageReceived: (JavascriptMessage message) async {
                    if (message.message == 'completed') {
                      model.setPanelType = PanelType.pass;
                      model.setCompletedChallenge = true;
                      model.setShowPanel = true;
                    } else {
                      model.setPanelType = PanelType.hint;
                      model.setHint = message.message;
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
                  size: 32,
                  color: model.showPreview
                      ? const Color.fromRGBO(0x2A, 0x2A, 0x40, 1)
                      : Colors.white),
              onPressed: () async {
                String currText = await model.getTextFromCache(challenge);
                ChallengeFile currFile = model.currentFile(challenge);
                editor.fileTextStream.sink.add(
                  FileStreamEvent(
                    ext: currFile.ext.name.toUpperCase(),
                    content: currText == '' ? currFile.contents : currText,
                  ),
                );
                model.setEditorText =
                    currText == '' ? currFile.contents : currText;
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
                  color: !model.hasTypedInEditor
                      ? const Color.fromARGB(255, 9, 79, 125)
                      : model.completedChallenge
                          ? const Color.fromRGBO(0x20, 0xD0, 0x32, 1)
                          : const Color.fromRGBO(0x1D, 0x9B, 0xF0, 1),
                  child: IconButton(
                    icon: model.runningTests
                        ? const CircularProgressIndicator()
                        : model.completedChallenge
                            ? const FaIcon(FontAwesomeIcons.arrowRight)
                            : const FaIcon(FontAwesomeIcons.check),
                    onPressed: model.hasTypedInEditor
                        ? () async {
                            if (model.showPanel &&
                                model.panelType == PanelType.pass) {
                              model.goToNextChallenge(
                                  maxChallenges, challengesCompleted);
                              return;
                            }
                            model.setIsRunningTests = true;
                            await model.runner.setWebViewContent(challenge,
                                webviewController: model.testController!);
                            model.setIsRunningTests = false;
                            FocusManager.instance.primaryFocus?.unfocus();
                            model.testController?.runJavascript('''
                                (function(){Flutter.postMessage(window.document.body.outerHTML)})();
                              ''');
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
    );
  }
}
