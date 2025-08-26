import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
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
  });

  final Challenge challenge;
  final Block block;

  @override
  Widget build(BuildContext context) {
    HTMLParser parser = HTMLParser(context: context);

    return ViewModelBuilder<QuizViewModel>.reactive(
      viewModelBuilder: () => QuizViewModel(),
      onViewModelReady: (model) => model.initChallenge(challenge),
      builder: (context, model, child) {
        return PopScope<bool>(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) async {
            if (didPop) {
              return;
            }

            // Show confirmation dialog
            final shouldPop = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Are you sure?'),
                content: const Text(
                    'Do you want to leave this quiz? Your progress will be lost.'),
                actions: [
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: FccColors.gray80,
                    ),
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: FccColors.red15,
                    ),
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text(
                      'Leave',
                      style: TextStyle(color: FccColors.red90),
                    ),
                  ),
                ],
              ),
            );

            // If user confirmed leaving, allow navigation
            if (shouldPop == true) {
              Navigator.of(context).pop();
            }
          },
          child: Scaffold(
            backgroundColor: FccColors.gray90,
            persistentFooterAlignment: AlignmentDirectional.topStart,
            appBar: AppBar(
              backgroundColor: FccColors.gray90,
            ),
            body: SafeArea(
              bottom: false, // Don't pad bottom as we have a sticky footer
              child: ListView(
                // Add bottom padding to ensure content isn't hidden behind sticky footer
                padding: const EdgeInsets.only(bottom: 80),
                children: [
                  ChallengeCard(
                    title: challenge.title,
                    child: Column(
                      children: [
                        ...parser.parse(
                          challenge.description,
                          customStyles: {
                            '*:not(h1):not(h2):not(h3):not(h4):not(h5):not(h6)':
                                Style(color: FccColors.gray05),
                          },
                        ),
                        ...parser.parse(
                          challenge.instructions,
                          customStyles: {
                            '*:not(h1):not(h2):not(h3):not(h4):not(h5):not(h6)':
                                Style(color: FccColors.gray05),
                          },
                        ),
                      ],
                    ),
                  ),
                  QuizWidget(
                      isValidated: model.isValidated,
                      questions: model.quizQuestions,
                      onChanged: (questionIndex, answerIndex) {
                        model.setSelectedAnswer(questionIndex, answerIndex);
                      }),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            // Add sticky footer
            bottomNavigationBar: Container(
              decoration: BoxDecoration(
                color: FccColors.gray80,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 4,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Error message above the button
                      if (model.errMessage.isNotEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Text(
                            model.errMessage,
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                      // Action button
                      ElevatedButton(
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
                        onPressed: () {
                          if (model.isValidated &&
                              model.hasPassedAllQuestions) {
                            model.learnService.goToNextChallenge(
                              block.challenges.length,
                              challenge,
                              block,
                            );
                          } else if (model.isValidated &&
                              !model.hasPassedAllQuestions) {
                            model.resetQuiz();
                          } else {
                            model.validateChallenge();
                          }
                        },
                        child: Text(
                          model.isValidated
                              ? model.hasPassedAllQuestions
                                  ? context.t.next_challenge
                                  : context.t.try_again
                              : context.t.questions_check,
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
