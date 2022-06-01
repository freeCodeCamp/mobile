import 'package:flutter/material.dart';
import 'package:flutter_code_editor/controller/editor_view_controller.dart';
import 'package:flutter_code_editor/controller/language_controller/syntax/index.dart';
import 'package:flutter_code_editor/models/editor_options.dart';
import 'package:flutter_code_editor/models/file_model.dart';
import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:freecodecamp/ui/views/learn/challenge_editor/challenge_model.dart';
import 'package:freecodecamp/ui/views/learn/challenge_editor/description/description_view.dart';
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
                body: FutureBuilder(
              future: model.initChallenge(url),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  // TODO: Check if challenge is null
                  Challenge? challenge = snapshot.data as Challenge?;
                  EditorViewController controller = EditorViewController(
                    language: Syntax.HTML,
                    options: EditorOptions(
                        useFileExplorer: false,
                        canCloseFiles: false,
                        customViewNames: [
                          const Text('Description'),
                        ],
                        customViews: [
                          DescriptionView(
                            description: challenge!.description,
                            instructions: challenge.instructions,
                            tests: challenge.tests,
                            editorText: model.editorText,
                          )
                        ]),
                    recentlyOpenedFiles: model.returnFiles(challenge),
                    file: FileIDE(
                        fileExplorer: null,
                        fileName: challenge.files[0].name,
                        filePath: '',
                        fileContent: challenge.files[0].contents,
                        parentDirectory: ''),
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
