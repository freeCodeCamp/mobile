//TODO: Organise imports before merging
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:freecodecamp/ui/views/learn/widgets/console/console_view.dart';
import 'package:freecodecamp/ui/views/news/html_handler/html_handler.dart';
import 'package:freecodecamp/ui/widgets/drawer_widget/drawer_widget_view.dart';
import 'package:phone_ide/phone_ide.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:freecodecamp/enums/panel_type.dart';

import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';
import 'package:freecodecamp/ui/views/learn/challenge/challenge_viewmodel.dart';

import 'package:freecodecamp/ui/views/learn/widgets/dynamic_panel/panels/dynamic_panel.dart';
import 'package:stacked/stacked.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class ChallengeView extends StatelessWidget {
  const ChallengeView({
    Key? key,
    required this.url,
    required this.block,
    required this.challengeId,
    required this.challengesCompleted,
    required this.isProject,
  }) : super(key: key);

  final String url;
  final Block block;
  final String challengeId;
  final int challengesCompleted;
  final bool isProject;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ChallengeViewModel>.reactive(
      viewModelBuilder: () => ChallengeViewModel(),
      onViewModelReady: (model) {
        model.init(url, block, challengeId, challengesCompleted);
      },
      builder: (context, model, child) => FutureBuilder<Challenge?>(
        future: model.challenge,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Challenge challenge = snapshot.data!;
            int maxChallenges = block.challenges.length;

            if (challenge.challengeType == 11) {
              YoutubePlayerController controller = YoutubePlayerController(
                initialVideoId: challenge.videoId!,
                params: const YoutubePlayerParams(
                  showControls: true,
                  showFullscreenButton: true,
                  autoPlay: false,
                ),
              );
              return WillPopScope(
                onWillPop: () async {
                  model.updateProgressOnPop(context);

                  return Future.value(true);
                },
                child: Scaffold(
                  appBar: AppBar(
                    title: Text(challenge.title),
                  ),
                  body: ListView(
                    padding: const EdgeInsets.all(12),
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              challenge.title,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          YoutubePlayerIFrame(
                            controller: controller,
                          ),
                          const SizedBox(height: 12),
                          ...HtmlHandler.htmlHandler(
                            challenge.description,
                            context,
                            null,
                            'Inter',
                          ),
                          buildDivider(),
                          ...HtmlHandler.htmlHandler(
                            challenge.question!.text,
                            context,
                            null,
                            'Inter',
                          ),
                          const SizedBox(height: 8),
                          for (var answer
                              in challenge.question!.answers.asMap().entries)
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(0),
                                border: Border.all(
                                  color: answer.key == model.currentChoice
                                      ? const Color(0xFFFFFFFF)
                                      : const Color(0xFFAAAAAA),
                                  width:
                                      answer.key == model.currentChoice ? 3 : 1,
                                ),
                              ),
                              child: RadioListTile<int>(
                                // contentPadding: const EdgeInsets.all(0),
                                tileColor: const Color(0xFF0a0a23),
                                value: answer.key,
                                groupValue: model.currentChoice,
                                onChanged: (value) {
                                  model.setChoiceStatus = null;
                                  model.setCurrentChoice = value ?? -1;
                                },
                                title: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ...HtmlHandler.htmlHandler(
                                            // NOTE: Might need to make separate handler for challenges
                                            // Also the current handler breaks the default behavior here
                                            // by not allowing user to select the tile within the text
                                            answer.value,
                                            context,
                                            null,
                                            'Inter',
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (model.choiceStatus != null &&
                                        model.currentChoice == answer.key) ...{
                                      Expanded(
                                        flex: 0,
                                        child: Icon(
                                          model.choiceStatus!
                                              ? Icons.check_circle
                                              : Icons.cancel,
                                          color: model.choiceStatus!
                                              ? Colors.green
                                              : Colors.red,
                                        ),
                                      ),
                                    }
                                  ],
                                ),
                              ),
                            ),
                          // TODO: spacing or divider
                          // const SizedBox(height: 20),
                          buildDivider(),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(0, 50),
                                    backgroundColor: const Color.fromRGBO(
                                      0x3b,
                                      0x3b,
                                      0x4f,
                                      1,
                                    ),
                                    side: const BorderSide(
                                      width: 2,
                                      color: Colors.white,
                                    ),
                                  ),
                                  onPressed: model.currentChoice != -1
                                      ? () => model.checkOption()
                                      : null,
                                  child: Text(
                                    model.choiceStatus != null
                                        ? model.choiceStatus!
                                            ? 'Next challenge'
                                            : 'Try Again'
                                        : 'Check your answer',
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            } else {
              ChallengeFile currFile = model.currentFile(challenge);

              bool keyboard = MediaQuery.of(context).viewInsets.bottom != 0;

              bool onlyJs =
                  challenge.files.every((file) => file.ext.name == 'js');

              bool editableRegion =
                  currFile.editableRegionBoundaries.isNotEmpty;
              EditorOptions options = EditorOptions(
                hasRegion: editableRegion,
              );

              Editor editor = Editor(
                language: currFile.ext.name.toUpperCase(),
                options: options,
              );

              model.initiateFile(editor, challenge, currFile, editableRegion);

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
              editor.onTextChange.stream.listen((text) {
                model.fileService.saveFileInCache(
                  challenge,
                  model.currentSelectedFile != ''
                      ? model.currentSelectedFile
                      : challenge.files[0].name,
                  text,
                );

                model.setEditorText = text;
                model.setHasTypedInEditor = true;
                model.setCompletedChallenge = false;
              });

              BoxDecoration decoration = const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: 4,
                    color: Colors.blue,
                  ),
                ),
              );

              return WillPopScope(
                onWillPop: () async {
                  model.updateProgressOnPop(context);

                  return Future.value(true);
                },
                child: Scaffold(
                  appBar: !model.hideAppBar
                      ? AppBar(
                          automaticallyImplyLeading: !model.showPreview,
                          title: challenge.files.length == 1 &&
                                  !model.showPreview
                              ? const Text('Editor')
                              : Row(
                                  children: [
                                    if (model.showPreview && !onlyJs)
                                      Expanded(
                                        child: Container(
                                          decoration: model.showProjectPreview
                                              ? decoration
                                              : null,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              model.setShowConsole = false;
                                              model.setShowProjectPreview =
                                                  true;
                                            },
                                            child: const Text('PREVIEW'),
                                          ),
                                        ),
                                      ),
                                    if (model.showPreview)
                                      Expanded(
                                        child: Container(
                                          decoration: model.showConsole
                                              ? decoration
                                              : null,
                                          child: ElevatedButton(
                                            child: const Text('CONSOLE'),
                                            onPressed: () {
                                              model.setShowConsole = true;
                                              model.setShowProjectPreview =
                                                  false;
                                            },
                                          ),
                                        ),
                                      ),
                                    if (!model.showPreview &&
                                        challenge.files.length > 1)
                                      for (ChallengeFile file
                                          in challenge.files)
                                        customTabBar(
                                          model,
                                          challenge,
                                          file,
                                          editor,
                                        )
                                  ],
                                ),
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
                            model.showProjectPreview && !onlyJs
                                ? ProjectPreview(
                                    challenge: challenge,
                                    model: model,
                                  )
                                : JavaScriptConsole(
                                    messages: model.consoleMessages,
                                  )
                          ],
                        ),
                ),
              );
            }
          }

          return Scaffold(
            appBar: AppBar(
              title: const Text('Loading'),
              automaticallyImplyLeading: false,
            ),
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
    );
  }

  Widget customTabBar(
    ChallengeViewModel model,
    Challenge challenge,
    ChallengeFile file,
    Editor editor,
  ) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: model.currentFile(challenge).name == file.name
                ? const BorderSide(width: 4, color: Colors.blue)
                : const BorderSide(),
          ),
        ),
        child: ElevatedButton(
          onPressed: () async {
            model.setCurrentSelectedFile = file.name;
            ChallengeFile currFile = model.currentFile(challenge);

            String currText = await model.fileService.getExactFileFromCache(
              challenge,
              currFile,
            );

            bool hasRegion = currFile.editableRegionBoundaries.isNotEmpty;

            editor.fileTextStream.sink.add(
              FileIDE(
                id: challenge.id + currFile.name,
                ext: currFile.ext.name.toUpperCase(),
                name: currFile.name,
                content: currText == '' ? currFile.contents : currText,
                hasRegion: currFile.editableRegionBoundaries.isNotEmpty,
                region: EditorRegionOptions(
                  start:
                      hasRegion ? currFile.editableRegionBoundaries[0] : null,
                  end: hasRegion ? currFile.editableRegionBoundaries[1] : null,
                ),
              ),
            );

            model.setEditorText = currText == '' ? currFile.contents : currText;
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
          ),
        ),
      ),
    );
  }

  Widget customBottomBar(
    ChallengeViewModel model,
    Challenge challenge,
    Editor editor,
    BuildContext context,
  ) {
    return BottomAppBar(
      color: const Color(0xFF0a0a23),
      child: Row(
        children: [
          SizedBox(
            width: 1,
            height: 1,
            child: InAppWebView(
              onWebViewCreated: (controller) {
                model.setTestController = controller;
              },
              onConsoleMessage: (controller, console) {
                model.handleConsoleLogMessagges(console, challenge);
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

                model.setMounted = false;

                editor.fileTextStream.sink.add(FileIDE(
                  id: challenge.id + currFile.name,
                  ext: currFile.ext.name.toUpperCase(),
                  name: currFile.name,
                  content: currText == '' ? currFile.contents : currText,
                  hasRegion: currFile.editableRegionBoundaries.isNotEmpty,
                  region: EditorRegionOptions(
                    start: currFile.editableRegionBoundaries.isNotEmpty
                        ? currFile.editableRegionBoundaries[0]
                        : null,
                    end: currFile.editableRegionBoundaries.isNotEmpty
                        ? currFile.editableRegionBoundaries[1]
                        : null,
                  ),
                ));
                model.setEditorText =
                    currText == '' ? currFile.contents : currText;
                model.setShowPreview = !model.showPreview;

                if (!model.showProjectPreview && !model.showConsole) {
                  model.setShowProjectPreview = true;
                }

                model.refresh();
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
                            model.setAfterFirstTest = false;
                            model.setConsoleMessages = [];
                            model.setUserConsoleMessages = [];
                            if (model.showPanel &&
                                model.panelType == PanelType.pass) {
                              model.goToNextChallenge(
                                model.block!.challenges.length,
                                challengesCompleted,
                              );
                            }

                            model.setShowPanel = false;
                            model.setIsRunningTests = true;
                            await model.runner.setWebViewContent(
                              challenge,
                              controller: model.testController!,
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
              );
            }
          }

          if (snapshot.hasError) {
            const Center(
              child: Text('something went wrong!'),
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
