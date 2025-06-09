import 'package:flutter/material.dart';
import 'package:freecodecamp/extensions/i18n_extension.dart';
import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';
import 'package:freecodecamp/ui/theme/fcc_theme.dart';
import 'package:freecodecamp/ui/views/learn/challenge/templates/quiz/quiz_viewmodel.dart';
import 'package:freecodecamp/ui/views/learn/widgets/challenge_card.dart';
import 'package:freecodecamp/ui/views/learn/widgets/quiz_widget.dart';
import 'package:freecodecamp/ui/views/news/html_handler/html_handler.dart';
import 'package:stacked/stacked.dart';

class QuizView extends StatelessWidget {
  const QuizView({
    super.key,
    required this.challenge,
    required this.block,
    required this.challengesCompleted,
  });

  final Challenge challenge;
  final Block block;
  final int challengesCompleted;

  @override
  Widget build(BuildContext context) {
    HTMLParser parser = HTMLParser(context: context);

    return ViewModelBuilder<QuizViewModel>.reactive(
      viewModelBuilder: () => QuizViewModel(),
      onViewModelReady: (model) => model.initChallenge(challenge),
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: FccColors.gray90,
          persistentFooterAlignment: AlignmentDirectional.topStart,
          appBar: AppBar(
            backgroundColor: FccColors.gray90,
          ),
          body: SafeArea(
            child: ListView(
              children: [
                ChallengeCard(
                  title: challenge.title,
                  child: Column(
                    children: [
                      ...parser.parse(
                        challenge.instructions,
                        fontColor: FccColors.gray05,
                      ),
                      ...parser.parse(
                        challenge.description,
                        fontColor: FccColors.gray05,
                      ),
                    ],
                  ),
                ),
                Quiz(
                    isValidated: model.isValidated,
                    questions: model.quizQuestions,
                    onChanged: (questionIndex, answerIndex) {
                      model.setSelectedAnswer(questionIndex, answerIndex);
                    }),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(0, 50),
                            backgroundColor:
                                const Color.fromRGBO(0x3b, 0x3b, 0x4f, 1),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                              side: BorderSide(
                                width: 2,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          onPressed: model.quizQuestions
                                  .every((q) => q.selectedAnswer != -1)
                              ? () {
                                  if (model.isValidated &&
                                      model.hasPassedAllQuestions) {
                                    model.learnService.goToNextChallenge(
                                      block.challenges.length,
                                      challengesCompleted,
                                      challenge,
                                      block,
                                    );
                                  } else {
                                    model.validateChallenge();
                                  }
                                }
                              : null,
                          child: Text(
                            context.t.next,
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
