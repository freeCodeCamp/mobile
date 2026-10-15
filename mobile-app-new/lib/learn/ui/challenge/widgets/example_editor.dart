import 'package:flutter/material.dart';
import 'package:mobile_app_new/learn/models/challenge_model.dart';
import 'package:mobile_app_new/learn/ui/challenge/widgets/parsed_html.dart';
import 'package:mobile_app_new/widgets/html_handler/code_block.dart';

class ExampleEditor extends StatelessWidget {
  const ExampleEditor({super.key, required this.nodules});
  final List<Nodule> nodules;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      for (final nodule in nodules)
        ...switch (nodule) {
          ParagraphNodule(:final contents) => [ParsedHtml(contents)],
          InteractiveEditorNodule(:final files) => [
            for (final file in files)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: FccCodeBlock(code: file.contents, language: file.ext),
              ),
          ],
        },
    ],
  );
}
