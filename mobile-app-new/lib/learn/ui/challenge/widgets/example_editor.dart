import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:mobile_app_new/learn/models/challenge_model.dart';
import 'package:mobile_app_new/learn/ui/challenge/widgets/challenge_card.dart';
import 'package:mobile_app_new/widgets/html_handler/html_handler.dart';
import 'package:phone_ide/phone_ide.dart';

class ExampleEditor extends StatefulWidget {
  const ExampleEditor({super.key, required this.nodules});

  final List<Nodule> nodules;

  @override
  State<ExampleEditor> createState() => _ExampleEditorState();
}

class _ExampleEditorState extends State<ExampleEditor> {
  Widget? _card;

  @override
  Widget build(BuildContext context) => _card ??= _build(context);

  Widget _build(BuildContext context) {
    final parser = HTMLParser(context: context);

    return ChallengeCard(
      title: 'Lesson',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final nodule in widget.nodules)
            ...switch (nodule) {
              ParagraphNodule(:final contents) => parser.parse(
                contents,
                customStyles: {
                  '*': Style(fontSize: FontSize(18)),
                  'ul': Style(
                    fontSize: FontSize(18),
                    padding: HtmlPaddings.only(left: 10),
                  ),
                },
              ),
              InteractiveEditorNodule(:final files) => [
                for (final file in files)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
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
              ],
            },
        ],
      ),
    );
  }
}
