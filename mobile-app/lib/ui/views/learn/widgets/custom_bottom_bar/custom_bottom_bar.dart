import 'package:flutter/material.dart';
import 'package:flutter_code_editor/editor/editor.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:freecodecamp/enums/panel_type.dart';
import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:freecodecamp/ui/views/learn/challenge_editor/challenge_model.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CustomBottomBar extends StatelessWidget {
  const CustomBottomBar(
      {Key? key,
      required this.model,
      required this.challenge,
      required this.editor})
      : super(key: key);

  final ChallengeModel model;
  final Challenge challenge;
  final Editor editor;

  @override
  Widget build(BuildContext context) {
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
                ChallengeFile currFile = model.currentFile(challenge);
                editor.fileTextStream.sink.add(
                  FileStreamEvent(
                    ext: currFile.ext.name.toUpperCase(),
                    content: currText == '' ? currFile.contents : currText,
                  ),
                );
                model.setEditorText = currText == ''
                    ? currFile.contents
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
