import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_code_editor/controller/editor_view_controller.dart';
import 'package:flutter_code_editor/controller/language_controller/syntax/index.dart';
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
  const ChallengeView({Key? key, required this.url, required this.block})
      : super(key: key);

  final String url;
  final Block block;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ChallengeModel>.reactive(
        viewModelBuilder: () => ChallengeModel(),
        onDispose: (model) => model.disposeCahce(url),
        builder: (context, model, child) => FutureBuilder<Challenge?>(
              future: model.initChallenge(url),
              builder: (context, snapshot) {
                if (MediaQuery.of(context).viewInsets.bottom > 0 ||
                    !model.showPanel) {
                  model.setHideAppBar = false;
                } else {
                  model.setHideAppBar = true;
                }
                if (snapshot.hasData) {
                  Challenge challenge = snapshot.data!;
                  int maxChallenges = block.challenges.length;

                  EditorViewController controller = EditorViewController(
                    language: Syntax.HTML,
                    options: const EditorOptions(
                        useFileExplorer: false,
                        canCloseFiles: false,
                        showAppBar: false,
                        showTabBar: false),
                    file: FileIDE(
                        fileExplorer: null,
                        fileName: challenge.files[0].name,
                        filePath: '',
                        fileContent:
                            model.editorText ?? challenge.files[0].contents,
                        parentDirectory: ''),
                  );

                  controller.editorTextStream.stream.listen((event) {
                    model.saveEditorTextInCache(event);
                    model.setEditorText = event;
                    model.setCompletedChallenge = false;
                  });

                  return Scaffold(
                      appBar: !model.hideAppBar
                          ? AppBar(
                              automaticallyImplyLeading: false,
                              actions: [
                                Expanded(
                                  child: Container(
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: !model.showPreview
                                                      ? Colors.blue
                                                      : Colors.transparent,
                                                  width: 4))),
                                      child: customDropdown(challenge, model)),
                                ),
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: model.showPreview
                                                    ? Colors.blue
                                                    : Colors.transparent,
                                                width: 4))),
                                    child: TextButton(
                                      child: Text(
                                        'preview',
                                        style: TextStyle(
                                            color: model.showPreview
                                                ? Colors.blue
                                                : Colors.white,
                                            fontWeight: model.showPreview
                                                ? FontWeight.bold
                                                : null),
                                      ),
                                      onPressed: () {
                                        model.setShowPreview =
                                            !model.showPreview;
                                      },
                                    ),
                                  ),
                                )
                              ],
                            )
                          : null,
                      bottomNavigationBar: Padding(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child:
                              bottomBar(model, challenge, context, controller)),
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
                                      )
                                    : Container(),
                                editor(controller, model)
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
                                      )
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

                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ));
  }

  Widget customDropdown(Challenge challenge, ChallengeModel model) {
    return Expanded(
        child: Align(
      alignment: Alignment.center,
      child: DropdownButton(
        dropdownColor: const Color(0xFF0a0a23),
        underline: Container(
          height: 0,
        ),
        iconEnabledColor: !model.showPreview ? Colors.blue : Colors.white,
        value: '${challenge.files[0].name}.${challenge.files[0].ext.name}',
        items: challenge.files
            .map((file) => '${file.name}.${file.ext.name}')
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            alignment: Alignment.centerLeft,
            child: Text(
              'Editors',
              style: TextStyle(
                  color: !model.showPreview ? Colors.blue : Colors.white,
                  fontWeight: !model.showPreview ? FontWeight.bold : null),
            ),
          );
        }).toList(),
        onChanged: (e) {},
      ),
    ));
  }

  Widget bottomBar(ChallengeModel model, Challenge challenge,
      BuildContext context, EditorViewController controller) {
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
                controller.editorTextStream.stream.listen((event) async {
                  model.runner.setWebViewContent(
                      event, challenge.tests, model.testController!);
                });
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
          if (model.showPreview)
            Container(
              margin: const EdgeInsets.all(8),
              color: const Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
              child: IconButton(
                icon: const FaIcon(FontAwesomeIcons.code),
                onPressed: () => {model.setShowPreview = !model.showPreview},
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
          )
        ],
      ),
    );
  }

  Widget editor(EditorViewController controller, ChallengeModel model) {
    return Expanded(child: controller);
  }
}

class DynamicPanel extends StatelessWidget {
  const DynamicPanel({
    Key? key,
    required this.challenge,
    required this.model,
    required this.panel,
    required this.maxChallenges,
  }) : super(key: key);

  final Challenge challenge;
  final ChallengeModel model;
  final PanelType panel;
  final int maxChallenges;

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
        );
      case PanelType.hint:
        return HintWidgetView(
          hint: model.hint,
          challengeModel: model,
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
