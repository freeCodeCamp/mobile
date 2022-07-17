import 'package:flutter/material.dart' show Align, Alignment, BuildContext, Colors, Column, Container, CrossAxisAlignment, EdgeInsets, Expanded, FontWeight, Icon, IconButton, Icons, Key, MainAxisAlignment, Padding, Row, SizedBox, StatelessWidget, Text, TextStyle, Widget;
import 'package:freecodecamp/ui/views/learn/challenge_editor/challenge_model.dart';
import 'package:freecodecamp/ui/views/learn/widgets/hint/hint_widget_model.dart';
import 'package:freecodecamp/ui/views/news/html_handler/html_handler.dart';
import 'package:stacked/stacked.dart';

class HintWidgetView extends StatelessWidget {
  const HintWidgetView(
      {Key? key, required this.hint, required this.challengeModel})
      : super(key: key);

  final String hint;
  final ChallengeModel challengeModel;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HintWidgetModel>.reactive(
        viewModelBuilder: () => HintWidgetModel(),
        builder: (context, model, child) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 28, horizontal: 16),
                      child: Text(
                        'Hint',
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Inter',
                            color: Colors.white.withOpacity(0.87)),
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
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                        child: HtmlHandler.htmlWidgetBuilder(hint, context))
                  ],
                ),
                Expanded(
                    child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.question_mark),
                        padding: const EdgeInsets.all(16),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.restart_alt),
                        padding: const EdgeInsets.all(16),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.remove_red_eye_outlined),
                        padding: const EdgeInsets.all(16),
                      )
                    ],
                  ),
                ))
              ],
            ));
  }
}
