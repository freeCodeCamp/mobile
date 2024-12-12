import 'package:flutter/material.dart';

import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';
import 'package:freecodecamp/ui/views/learn/challenge/templates/english/english_viewmodel.dart';
import 'package:freecodecamp/ui/views/learn/widgets/audio/audio_player_view.dart';
import 'package:freecodecamp/ui/views/news/html_handler/html_handler.dart';
import 'package:stacked/stacked.dart';

class EnglishView extends StatelessWidget {
  const EnglishView({
    Key? key,
    required this.challenge,
    required this.block,
    required this.currentChallengeNum,
  }) : super(key: key);

  final Challenge challenge;
  final Block block;
  final int currentChallengeNum;

  @override
  Widget build(BuildContext context) {
    HTMLParser parser = HTMLParser(context: context);

    int numberOfDialogueHeaders = block.challenges
        .where((challenge) => challenge.title.contains('Dialogue'))
        .length;

    return ViewModelBuilder<EnglishViewModel>.reactive(
      viewModelBuilder: () => EnglishViewModel(),
      builder: (context, model, child) {
        return PopScope(
          canPop: true,
          onPopInvokedWithResult: (bool didPop, dynamic result) {
            model.learnService.updateProgressOnPop(context, block);
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                '${challenge.title} of ${block.challenges.length - numberOfDialogueHeaders}',
              ),
            ),
            body: SafeArea(
              child: ListView(
                children: [
                  Container(
                    margin: const EdgeInsets.all(8),
                    color: const Color(0xFF0a0a23),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [...parser.parse(challenge.description)],
                          ),
                        )
                      ],
                    ),
                  ),
                  if (challenge.fillInTheBlank != null)
                    Container(
                      color: const Color(0xFF0a0a23),
                      margin: const EdgeInsets.all(8),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Wrap(
                                children: [
                                  ...model.getFillInBlankWidgets(
                                    challenge,
                                    context,
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  else
                    Container(),
                  if (challenge.audio != null)
                    Container(
                      color: const Color(0xFF0a0a23),
                      margin: const EdgeInsets.all(8),
                      child: AudioPlayerView(
                        audio: challenge.audio!,
                      ),
                    ),
                  Container(
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
                        model.allInputsCorrect
                            ? 'Go to Next Challenge'
                            : 'Check Answers',
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
