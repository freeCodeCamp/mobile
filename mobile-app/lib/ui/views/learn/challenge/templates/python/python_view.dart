import 'package:flutter/material.dart';
import 'package:freecodecamp/extensions/i18n_extension.dart';
import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';
import 'package:freecodecamp/ui/views/learn/challenge/templates/python/python_viewmodel.dart';
import 'package:freecodecamp/ui/views/learn/utils/challenge_utils.dart';
import 'package:freecodecamp/ui/views/learn/widgets/challenge_card.dart';
import 'package:freecodecamp/ui/views/learn/widgets/transcript_widget.dart';
import 'package:freecodecamp/ui/views/learn/widgets/quiz_widget.dart';
import 'package:freecodecamp/ui/views/learn/widgets/youtube_player_widget.dart';
import 'package:freecodecamp/ui/views/news/html_handler/html_handler.dart';
import 'package:freecodecamp/ui/widgets/drawer_widget/drawer_widget_view.dart';
import 'package:stacked/stacked.dart';

class PythonView extends StatelessWidget {
  const PythonView({
    super.key,
    required this.challenge,
    required this.block,
    required this.challengesCompleted,
    required this.currentChallengeNum,
  });

  final Challenge challenge;
  final Block block;
  final int currentChallengeNum;
  final int challengesCompleted;

  @override
  Widget build(BuildContext context) {
    HTMLParser parser = HTMLParser(context: context);

    return ViewModelBuilder<PythonViewModel>.reactive(
      viewModelBuilder: () => PythonViewModel(),
      onViewModelReady: (model) => model.initChallenge(challenge),
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(handleChallengeTitle(challenge, block)),
          ),
          body: SafeArea(
            bottom: false,
            child: ListView(
              children: [
                Center(
                  child: Text(
                    challenge.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                if (challenge.description.isNotEmpty)
                  ChallengeCard(
                    title: 'Description',
                    child: Column(
                      children: parser.parse(
                        challenge.description,
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  child: YoutubePlayerWidget(
                    videoId: challenge.videoId!,
                  ),
                ),
                const SizedBox(height: 12),
                if (challenge.transcript.isNotEmpty) ...[
                  ChallengeCard(
                    title: 'Transcript',
                    child: Transcript(
                      transcript: challenge.transcript,
                    ),
                  ),
                ],
                if (challenge.instructions.isNotEmpty)
                  ChallengeCard(
                    title: 'Instructions',
                    child: Column(
                      children: parser.parse(
                        challenge.instructions,
                      ),
                    ),
                  ),
                QuizWidget(
                    isValidated: model.isValidated,
                    questions: model.quizQuestions,
                    onChanged: (questionIndex, answerIndex) {
                      model.setSelectedAnswer(questionIndex, answerIndex);
                    }),
                const SizedBox(height: 16),
                if (model.errMessage.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      model.errMessage,
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(0, 50),
                      backgroundColor:
                          const Color.fromRGBO(0x3b, 0x3b, 0x4f, 1),
                      side: const BorderSide(
                        width: 2,
                        color: Colors.white,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                    onPressed:
                        model.quizQuestions.every((q) => q.selectedAnswer != -1)
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
                      model.isValidated
                          ? model.hasPassedAllQuestions
                              ? context.t.next_challenge
                              : context.t.try_again
                          : context.t.questions_check,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        );
      },
    );
  }
}
