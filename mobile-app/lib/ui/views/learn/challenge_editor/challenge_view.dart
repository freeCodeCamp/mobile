// import 'dart:convert';

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_code_editor/controller/editor_view_controller.dart';
import 'package:flutter_code_editor/controller/language_controller/syntax/index.dart';
import 'package:flutter_code_editor/editor/editor.dart';
import 'package:flutter_code_editor/models/editor_options.dart';
import 'package:flutter_code_editor/models/file_model.dart';

import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';
import 'package:freecodecamp/ui/views/learn/challenge_editor/challenge_model.dart';
import 'package:freecodecamp/ui/views/learn/widgets/custom_bottom_bar/custom_bottom_bar.dart';
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

                  bool keyBoardIsActive =
                      MediaQuery.of(context).viewInsets.bottom != 0;

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
                  SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
                    bool keyboardPresent =
                        MediaQuery.of(context).viewInsets.bottom > 0;

                    if (!keyboardPresent && !model.showPanel) {
                      if (model.hideAppBar) {
                        model.setHideAppBar = false;
                      }
                    } else if (model.showPanel) {
                      if (!model.hideAppBar) {
                        model.setHideAppBar = true;
                      }
                    }
                  });
                  // ignore: unused_local_variable
                  EditorViewController controller = EditorViewController(
                    language: Syntax.HTML,
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
                          child: CustomBottomBar(
                              model: model,
                              challenge: challenge,
                              editor: editor)),
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
                            editor: Editor(language: Syntax.HTML),
                          ),
                        ),
                      ],
                    ));
              },
            ));
  }
}
