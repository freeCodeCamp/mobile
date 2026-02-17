import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:freecodecamp/ui/views/learn/widgets/challenge_card.dart';
import 'package:freecodecamp/ui/views/news/html_handler/html_handler.dart';
import 'package:phone_ide/editor/editor.dart';
import 'package:phone_ide/editor/editor_options.dart';

class ExampleEditor extends StatelessWidget {
  const ExampleEditor({
    super.key,
    required this.nodules,
    required this.parser,
  });

  final List<Nodule> nodules;
  final HTMLParser parser;

  @override
  Widget build(BuildContext context) {
    return ChallengeCard(
      title: 'Lesson',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...nodules.map(
            (nodule) {
              return switch (nodule) {
                ParagraphNodule(:final contents) => Column(
                    children: parser.parse(
                      contents,
                      customStyles: {
                        '*': Style(
                          fontSize: FontSize(18),
                        ),
                        'ul': Style(
                            fontSize: FontSize(18),
                            padding: HtmlPaddings.only(left: 10))
                      },
                    ),
                  ),
                InteractiveEditorNodule(:final files) => Column(
                    children: files
                        .map(
                          (file) => Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  file.ext.toUpperCase(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Editor(
                                  options: EditorOptions(
                                    fontFamily: 'Hack',
                                    takeFullHeight: false,
                                    showLinebar: false,
                                    isEditable: false,
                                  ),
                                  defaultLanguage: file.ext,
                                  defaultValue: file.contents,
                                  path: '/',
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  )
              };
            },
          )
        ],
      ),
    );
  }
}
