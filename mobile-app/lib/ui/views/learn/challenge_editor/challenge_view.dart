import 'package:flutter/material.dart';
import 'package:flutter_code_editor/controller/editor_view_controller.dart';
import 'package:flutter_code_editor/controller/language_controller/syntax/index.dart';
import 'package:flutter_code_editor/models/editor_options.dart';
import 'package:freecodecamp/ui/views/learn/challenge_editor/challenge_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stacked/stacked.dart';

class ChallengeView extends StatelessWidget {
  const ChallengeView({Key? key, required this.url}) : super(key: key);

  final String url;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ChallengeModel>.reactive(
        viewModelBuilder: () => ChallengeModel(),
        onDispose: (model) => model.disposeCahce(url),
        builder: (context, model, child) => Scaffold(
            bottomNavigationBar: BottomAppBar(
              color: const Color(0xFF0a0a23),
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.all(8),
                    color: const Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
                    child: IconButton(
                      icon: const FaIcon(FontAwesomeIcons.info),
                      onPressed: () => {},
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          margin: const EdgeInsets.all(8),
                          color: const Color.fromRGBO(0x1D, 0x9B, 0xF0, 1),
                          child: IconButton(
                            icon: const FaIcon(FontAwesomeIcons.check),
                            onPressed: () => {},
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            body: FutureBuilder(
              future: model.initChallenge(url),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  // Challenge? challenge = snapshot.data as Challenge?;
                  EditorViewController controller = EditorViewController(
                    language: Syntax.HTML,
                    options: const EditorOptions(
                      useFileExplorer: false,
                      canCloseFiles: false,
                    ),
                  );

                  controller.editorTextStream.stream.listen((event) {
                    model.updateText(event);
                  });

                  return controller;
                }

                if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                }

                return const Center(child: CircularProgressIndicator());
              },
            )));
  }
}
