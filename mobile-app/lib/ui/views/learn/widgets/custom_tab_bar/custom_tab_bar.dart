import 'package:flutter/material.dart';
import 'package:flutter_code_editor/editor/editor.dart';
import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:freecodecamp/ui/views/learn/challenge_editor/challenge_model.dart';

class CustomTabBar extends StatelessWidget {
  const CustomTabBar(
      {Key? key,
      required this.model,
      required this.challenge,
      required this.file,
      required this.editor})
      : super(key: key);

  final ChallengeModel model;
  final Challenge challenge;
  final ChallengeFile file;
  final Editor editor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
      decoration: BoxDecoration(
          border: Border(
              bottom: model.currentFile(challenge).name == file.name
                  ? const BorderSide(width: 4, color: Colors.blue)
                  : const BorderSide())),
      child: ElevatedButton(
          onPressed: () async {
            model.setCurrentSelectedFile = '${file.name}.${file.ext.name}';
            String currText = await model.getTextFromCache(challenge);
            editor.fileTextStream.sink.add(currText == ''
                ? model.currentFile(challenge).contents
                : currText);
            model.setEditorText = currText == ''
                ? model.currentFile(challenge).contents
                : currText;
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
          )),
    ));
  }
}
