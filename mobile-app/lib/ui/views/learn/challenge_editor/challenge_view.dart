import 'package:flutter/material.dart';
import 'package:flutter_code_editor/controller/editor_view_controller.dart';
import 'package:flutter_code_editor/controller/language_controller/syntax/index.dart';
import 'package:flutter_code_editor/models/editor_options.dart';
import 'package:flutter_code_editor/models/file_model.dart';
import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:freecodecamp/ui/views/learn/challenge_editor/challenge_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
        builder: (context, model, child) => FutureBuilder<Challenge?>(
              future: model.initChallenge(url),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  Challenge challenge = snapshot.data!;

                  return Scaffold(
                      appBar: AppBar(
                        automaticallyImplyLeading: false,
                        actions: [
                          Expanded(
                              child: DropdownButton(
                            isExpanded: true,
                            dropdownColor: const Color(0xFF0a0a23),
                            underline: Container(),
                            value: challenge.files[0].name +
                                '.' +
                                challenge.files[0].ext.name,
                            items: challenge.files
                                .map((file) => file.name + '.' + file.ext.name)
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    value,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (e) {},
                          )),
                          Expanded(
                            child: TextButton(
                              child: const Text('Preview'),
                              onPressed: () {},
                            ),
                          )
                        ],
                      ),
                      bottomNavigationBar: Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: BottomToolBar(
                          model: model,
                          challenge: challenge,
                        ),
                      ),
                      body: EditorViewController(
                        language: Syntax.HTML,
                        options: const EditorOptions(
                          useFileExplorer: false,
                          canCloseFiles: false,
                          showAppBar: false,
                          showTabBar: false,
                        ),
                        file: FileIDE(
                            fileExplorer: null,
                            fileName: challenge.files[0].name,
                            filePath: '',
                            fileContent: challenge.files[0].contents,
                            parentDirectory: ''),
                      ));
                }

                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ));
  }
}

class BottomToolBar extends StatelessWidget {
  const BottomToolBar({Key? key, required this.model, required this.challenge})
      : super(key: key);

  final ChallengeModel model;
  final Challenge challenge;

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: const Color(0xFF0a0a23),
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.all(8),
            color: const Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
            child: IconButton(
              icon: const FaIcon(FontAwesomeIcons.info),
              onPressed: () => {
                showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        color: const Color(0xFF0a0a23),
                        height: MediaQuery.of(context).size.height * 0.33,
                        child: DescriptionView(
                          description: challenge.description,
                          instructions: challenge.instructions,
                          tests: const [],
                          editorText: model.editorText,
                        ),
                      );
                    })
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
                  color: const Color.fromRGBO(0x1D, 0x9B, 0xF0, 1),
                  child: IconButton(
                    icon: const FaIcon(FontAwesomeIcons.check),
                    onPressed: () => {},
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
}
