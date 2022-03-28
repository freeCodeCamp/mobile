import 'package:flutter/material.dart';
import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:freecodecamp/ui/views/learn/challenge_editor/description/description_model.dart';
import 'package:freecodecamp/ui/views/learn/challenge_editor/test_runner/test_model.dart';
import 'package:freecodecamp/ui/views/learn/challenge_editor/test_runner/test_view.dart';
import 'package:freecodecamp/ui/views/news/html_handler/html_handler.dart';
import 'package:stacked/stacked.dart';

class DescriptionView extends StatelessWidget {
  const DescriptionView(
      {Key? key,
      required this.description,
      required this.instructions,
      required this.tests})
      : super(key: key);

  final String description;
  final String instructions;
  final List<ChallengeTest> tests;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DescriptionModel>.reactive(
        viewModelBuilder: () => DescriptionModel(),
        builder: (context, model, child) => Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(left: 8),
                      child: const Text(
                        'Description',
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                    const Divider(
                      thickness: 2,
                    ),
                    Row(children: [
                      Expanded(
                          child: Column(
                        children:
                            HtmlHandler.smallHtmlHandler(description, context),
                      ))
                    ]),
                    Container(
                      padding: const EdgeInsets.only(left: 8),
                      child: const Text(
                        'Instructions',
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                    const Divider(
                      thickness: 2,
                    ),
                    Row(children: [
                      Expanded(
                          child: Column(
                        children:
                            HtmlHandler.smallHtmlHandler(instructions, context),
                      ))
                    ]),
                    Container(
                      padding: const EdgeInsets.only(left: 8),
                      child: const Text(
                        'Tests',
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                    const Divider(
                      thickness: 2,
                    ),
                    TestViewModel(tests: tests)
                  ],
                ),
              ),
            ));
  }
}
