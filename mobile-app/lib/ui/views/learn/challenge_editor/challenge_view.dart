import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_code_editor/controller/editor_view_controller.dart';
import 'package:flutter_code_editor/editor/editor.dart';
import 'package:flutter_code_editor/models/editor_options.dart';
import 'package:flutter_code_editor/models/file_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:freecodecamp/enums/ext_type.dart';
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
      onModelReady: (model) {
        model.init(url, block, challengesCompleted);
      },
      builder: (context, model, child) => FutureBuilder<Challenge?>(
        future: model.challenge,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Challenge challenge = snapshot.data!;

            int maxChallenges = block.challenges.length;
            ChallengeFile currFile = model.currentFile(challenge);

            bool keyboard = MediaQuery.of(context).viewInsets.bottom != 0;

            bool editableRegion = currFile.editableRegionBoundaries.isNotEmpty;
            EditorOptions options = EditorOptions(
              hasEditableRegion: editableRegion,
              useFileExplorer: false,
              canCloseFiles: false,
              showAppBar: false,
              showTabBar: false,
            );

            Editor editor = Editor(
              regionStart:
                  editableRegion ? currFile.editableRegionBoundaries[0] : null,
              regionEnd:
                  editableRegion ? currFile.editableRegionBoundaries[1] : null,
              condition: model.completedChallenge,
              language: currFile.ext.name.toUpperCase(),
              options: options,
              openedFile: FileIDE(
                fileExplorer: null,
                fileName: currFile.name,
                filePath: '',
                fileContent: model.editorText ?? currFile.contents,
                parentDirectory: '',
              ),
            );

            editor.onTextChange.stream.listen((text) {
              model.fileService.saveFileInCache(
                challenge,
                model.currentSelectedFile,
                text,
              );
              model.setEditorText = text;
              model.setCompletedChallenge = false;
              model.setHasTypedInEditor = true;
            });

            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              if (keyboard && !model.showPanel) {
                if (model.hideAppBar) {
                  model.setHideAppBar = false;
                }
              } else if (keyboard && model.showPanel) {
                if (model.hideAppBar) {
                  model.setHideAppBar = false;
                }
              } else if (!keyboard && model.showPanel) {
                if (!model.hideAppBar) {
                  model.setHideAppBar = true;
                }
              } else {
                if (model.hideAppBar) {
                  model.setHideAppBar = false;
                }
              }
            });

            BoxDecoration decoration = const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 4,
                  color: Colors.blue,
                ),
              ),
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
                            decoration: model.showPreview ? decoration : null,
                            child: Container(
                              decoration: model.showConsole ? decoration : null,
                              child: const ElevatedButton(
                                onPressed: null,
                                child: Text('Preview'),
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
                            ),
                          ),
                        if (!model.showPreview && challenge.files.length > 1)
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
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: customBottomBar(
                  model,
                  challenge,
                  editor,
                  context,
                ),
              ),
              body: !model.showPreview
                  ? Column(
                      children: [
                        if (model.showPanel && !keyboard)
                          DynamicPanel(
                            challenge: challenge,
                            model: model,
                            panel: model.panelType,
                            maxChallenges: maxChallenges,
                            challengesCompleted: challengesCompleted,
                            editor: editor,
                          ),
                        Expanded(child: editor)
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
                            editor: editor,
                          ),
                        ProjectPreview(
                          challenge: challenge,
                          model: model,
                        ),
                      ],
                    ),
            );
          }

          return Scaffold(
            appBar: AppBar(
              title: const Text('Loading'),
              automaticallyImplyLeading: false,
            ),
            body: Row(
              children: [
                Expanded(
                  child: EditorViewController(
                    options: model.defaultEditorOptions,
                    editor: Editor(
                      options: model.defaultEditorOptions,
                      language: 'HTML',
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget customBottomBar(
    ChallengeModel model,
    Challenge challenge,
    Editor editor,
    BuildContext context,
  ) {
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
                    model.setIsRunningTests = false;
                  },
                )
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.all(8),
            color: model.showPanel && model.panelType == PanelType.instruction
                ? Colors.white
                : const Color.fromRGBO(0x3B, 0x3B, 0x4F, 1),
            child: IconButton(
              icon: FaIcon(
                FontAwesomeIcons.info,
                size: 32,
                color:
                    model.showPanel && model.panelType == PanelType.instruction
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

                String currText = await model.fileService.getExactFileFromCache(
                  challenge,
                  currFile,
                );

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
                                model.block!.challenges.length,
                                challengesCompleted,
                              );
                            }

                            model.setIsRunningTests = true;
                            await model.runner.setWebViewContent(
                              challenge,
                              webviewController: model.testController!,
                            );
                            FocusManager.instance.primaryFocus?.unfocus();
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

class ProjectPreview extends StatelessWidget {
  const ProjectPreview({
    Key? key,
    required this.challenge,
    required this.model,
  }) : super(key: key);

  final Challenge challenge;
  final ChallengeModel model;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: WebView(
        userAgent: 'random',
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webcontroller) async {
          model.setWebviewController = webcontroller;
          webcontroller.loadUrl(
            Uri.dataFromString(
              await model.parsePreviewDocument(
                await model.fileService.getFirstFileFromCache(
                  challenge,
                  Ext.html,
                ),
              ),
              mimeType: 'text/html',
              encoding: utf8,
            ).toString(),
          );
        },
      ),
    );
  }
}
