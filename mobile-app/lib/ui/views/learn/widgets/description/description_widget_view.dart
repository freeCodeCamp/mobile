import 'package:flutter/material.dart';
import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:freecodecamp/ui/views/learn/widgets/description/description_widget_model.dart';
import 'package:freecodecamp/ui/views/news/html_handler/html_handler.dart';
import 'package:stacked/stacked.dart';
import 'dart:developer' as dev;

class DescriptionView extends StatelessWidget {
  const DescriptionView(
      {Key? key,
      required this.description,
      required this.instructions,
      this.editorText,
      required this.tests})
      : super(key: key);

  final String description;
  final String instructions;
  final List<ChallengeTest> tests;
  final String? editorText;

  @override
  Widget build(BuildContext context) {
    dev.log(editorText ?? '');
    return ViewModelBuilder<DescriptionModel>.reactive(
        viewModelBuilder: () => DescriptionModel(),
        builder: (context, model, child) => Scaffold(
              backgroundColor: const Color(0xFF0a0a23),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (instructions.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                            child: const Text(
                              'Instructions',
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Row(children: [
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Column(
                                  children: HtmlHandler.htmlHandler(
                                      instructions, context),
                                ),
                              ),
                            )
                          ]),
                        ],
                      ),
                    ),
                ],
              ),
            ));
  }
}
