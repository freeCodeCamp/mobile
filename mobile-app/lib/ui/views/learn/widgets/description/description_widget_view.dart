import 'package:flutter/material.dart' show Alignment, BuildContext, Color, Column, Container, CrossAxisAlignment, Expanded, FontWeight, Icon, IconButton, Icons, Key, Row, Scaffold, StatelessWidget, Text, TextStyle, Widget;
import 'package:freecodecamp/ui/views/learn/challenge_editor/challenge_model.dart';
import 'package:freecodecamp/ui/views/learn/widgets/description/description_widget_model.dart';
import 'package:freecodecamp/ui/views/news/html_handler/html_handler.dart';
import 'package:stacked/stacked.dart';
import 'dart:developer' as dev;

class DescriptionView extends StatelessWidget {
  const DescriptionView({
    Key? key,
    required this.description,
    required this.instructions,
    required this.challengeModel,
    this.editorText,
  }) : super(key: key);

  final String description;
  final String instructions;
  final String? editorText;
  final ChallengeModel challengeModel;

  @override
  Widget build(BuildContext context) {
    dev.log(editorText ?? '');
    return ViewModelBuilder<DescriptionModel>.reactive(
      viewModelBuilder: () => DescriptionModel(),
      builder: (context, model, child) => Scaffold(
        backgroundColor: const Color(0xFF0a0a23),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: instructions.isNotEmpty
              ? [
                  Row(
                    children: [
                      const Text(
                        'Instructions',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Inter',
                        ),
                      ),
                      Expanded(
                        child: Container(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            onPressed: () {
                              challengeModel.setShowPanel = false;
                            },
                            icon: const Icon(Icons.clear_sharp),
                            iconSize: 40,
                          ),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children:
                              HtmlHandler.htmlHandler(instructions, context),
                        ),
                      )
                    ],
                  ),
                ]
              : [],
        ),
      ),
    );
  }
}
