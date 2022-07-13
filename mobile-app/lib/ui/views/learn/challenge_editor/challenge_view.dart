import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_code_editor/controller/editor_view_controller.dart';
import 'package:flutter_code_editor/controller/language_controller/syntax/index.dart';
import 'package:flutter_code_editor/models/editor_options.dart';
import 'package:flutter_code_editor/models/file_model.dart';
import 'package:freecodecamp/enums/panel_type.dart';
import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:freecodecamp/ui/views/learn/challenge_editor/challenge_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:freecodecamp/ui/views/learn/widgets/description/description_widget_view.dart';
import 'package:freecodecamp/ui/views/learn/widgets/hint/hint_widget_view.dart';
import 'package:freecodecamp/ui/views/learn/widgets/pass/pass_widget_view.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:stacked/stacked.dart';

class ChallengeView extends StatelessWidget {
  const ChallengeView({Key? key, required this.url}) : super(key: key);

  final String url;

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
                                customDropdown(challenge),
                                Expanded(
                                  child: TextButton(
                                    child: const Text('Preview'),
                                    onPressed: () {
                                      model.showPreview = true;
                                    },
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
                                        panel: model.panelType)
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
                                        panel: model.panelType)
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

  Widget customDropdown(Challenge challenge) {
    return Expanded(
        child: Align(
      alignment: Alignment.center,
      child: DropdownButton(
        dropdownColor: const Color(0xFF0a0a23),
        underline: Container(height: 5, color: Colors.blue),
        alignment: Alignment.topCenter,
        value: '${challenge.files[0].name}.${challenge.files[0].ext.name}',
        items: challenge.files
            .map((file) => '${file.name}.${file.ext.name}')
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
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
            color: const Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
            child: IconButton(
              icon: const FaIcon(FontAwesomeIcons.info),
              onPressed: () {
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
                onPressed: () => {model.showPreview = false},
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
  const DynamicPanel(
      {Key? key,
      required this.challenge,
      required this.model,
      required this.panel})
      : super(key: key);

  final Challenge challenge;
  final ChallengeModel model;
  final PanelType panel;

  Widget panelHandler(PanelType panel) {
    switch (panel) {
      case PanelType.instruction:
        return DescriptionView(
          description: challenge.description,
          instructions: challenge.instructions,
          tests: const [],
          editorText: model.editorText,
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
        height: MediaQuery.of(context).size.width,
        color: const Color(0xFF0a0a23),
        child: panelHandler(panel));
  }
}
