import 'package:flutter/material.dart';
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
    required this.maxChallenges,
    required this.title,
    this.editorText,
  }) : super(key: key);

  final String description;
  final String instructions;
  final String? editorText;
  final ChallengeModel challengeModel;
  final int maxChallenges;
  final String title;

  @override
  Widget build(BuildContext context) {
    List<String> splitTitle = title.split(' ');
    bool isMultiStepChallenge = splitTitle.length == 2 &&
        splitTitle[0] == 'Step' &&
        int.tryParse(splitTitle[1]) != null;
    dev.log(editorText ?? '');
    return ViewModelBuilder<DescriptionModel>.reactive(
      viewModelBuilder: () => DescriptionModel(),
      builder: (context, model, child) => Scaffold(
        backgroundColor: const Color(0xFF0a0a23),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: instructions.isNotEmpty || description.isNotEmpty
              ? [
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Instructions',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Inter',
                            ),
                          ),
                          isMultiStepChallenge
                              ? Text(
                                  'Step ${splitTitle[1]} of $maxChallenges',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Inter',
                                    color: Colors.white70,
                                  ),
                                )
                              : Container(),
                        ],
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
                          children: instructions.isNotEmpty
                              ? HtmlHandler.htmlHandler(instructions, context)
                              : HtmlHandler.htmlHandler(description, context),
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
