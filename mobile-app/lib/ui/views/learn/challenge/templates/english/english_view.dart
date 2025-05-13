import 'package:flutter/material.dart';
import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';
import 'package:freecodecamp/ui/theme/fcc_theme.dart';
import 'package:freecodecamp/ui/views/learn/challenge/templates/english/english_viewmodel.dart';
import 'package:freecodecamp/ui/views/learn/widgets/audio/audio_player_view.dart';
import 'package:freecodecamp/ui/views/learn/widgets/challenge_card.dart';
import 'package:freecodecamp/ui/views/learn/widgets/explanation_widget.dart';
import 'package:freecodecamp/ui/views/news/html_handler/html_handler.dart';
import 'package:stacked/stacked.dart';

class EnglishView extends StatelessWidget {
  const EnglishView({
    super.key,
    required this.challenge,
    required this.block,
    required this.currentChallengeNum,
  });

  final Challenge challenge;
  final Block block;
  final int currentChallengeNum;

  @override
  Widget build(BuildContext context) {
    HTMLParser parser = HTMLParser(context: context);

    return ViewModelBuilder<EnglishViewModel>.reactive(
      viewModelBuilder: () => EnglishViewModel(),
      builder: (context, model, child) {
        return PopScope(
          canPop: true,
          onPopInvokedWithResult: (bool didPop, dynamic result) {
            model.learnService.updateProgressOnPop(context, block);
          },
          child: Scaffold(
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
                          challenge.description,
                          fontColor: FccColors.gray05,
                        ),
                      ],
                    ),
                  ),
                  if (challenge.audio != null) ...[
                    ChallengeCard(
                      title: 'Listen to the Audio',
                      child: AudioPlayerView(
                        audio: challenge.audio!,
                      ),
                    ),
                  ],
                  if (model.feedback.isNotEmpty)
                    ChallengeCard(
                      title: 'Feedback',
                      child: Column(
                        children: parser.parse(model.feedback),
                      ),
                    ),
                  if (challenge.fillInTheBlank != null)
                    ChallengeCard(
                      title: 'Fill in the Blank',
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: model.getFillInBlankWidgets(
                            challenge,
                            context,
                          ),
                        ),
                      ),
                    ),
                  if (challenge.explanation != null &&
                      challenge.explanation!.isNotEmpty) ...[
                    ChallengeCard(
                      title: 'Explanation',
                      child: Explanation(challenge: challenge),
                    ),
                  ],
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
                            onPressed: model.allInputsCorrect
                                ? () => model.learnService.goToNextChallenge(
                                    block.challenges.length,
                                    currentChallengeNum,
                                    challenge,
                                    block)
                                : () => {model.checkAnswers(challenge)},
                            child: Text(
                              model.allInputsCorrect ||
                                      challenge.fillInTheBlank == null
                                  ? 'Go to Next Challenge'
                                  : 'Check Answers',
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
          ),
        );
      },
    );
  }
}
