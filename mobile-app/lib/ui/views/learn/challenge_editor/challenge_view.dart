import 'package:flutter/material.dart';
import 'package:flutter_code_editor/controller/editor_view_controller.dart';
import 'package:flutter_code_editor/controller/file_controller.dart';
import 'package:flutter_code_editor/models/editor_options.dart';
import 'package:flutter_code_editor/models/file_model.dart';
import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:freecodecamp/ui/views/learn/challenge_editor/challenge_model.dart';
import 'package:stacked/stacked.dart';
import 'dart:developer' as dev;

class ChallengeView extends StatelessWidget {
  const ChallengeView({Key? key, required this.url}) : super(key: key);

  final String url;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ChallengeModel>.reactive(
        viewModelBuilder: () => ChallengeModel(),
        builder: (context, model, child) => Scaffold(
                body: FutureBuilder(
              future: model.initChallenge(url),
              builder: (context, snapshot) {
                Challenge? challenge = snapshot.data as Challenge?;

                if (snapshot.hasData) {
                  return EditorViewController(
                    options: const EditorOptions(useFileExplorer: false),
                    file: FileIDE(
                        fileExplorer: null,
                        fileName: challenge!.files[0].fileName,
                        filePath: '',
                        fileContent: challenge.files[0].fileContents,
                        parentDirectory: ''),
                  );
                }

                return const Center(child: CircularProgressIndicator());
              },
            )));
  }
}
