import 'package:flutter/material.dart';

import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';
import 'package:freecodecamp/ui/views/learn/challenge/templates/english/english_viewmodel.dart';
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
                '$currentChallengeNum of ${block.challenges.length} Tasks',
              ),
            ),
            body: SafeArea(
              child: ListView(
                children: [
                  ...parser.parse(challenge.description),
                  if (challenge.fillInTheBlank != null)
                    Container(
                      color: const Color(0xFF0a0a23),
                      margin: const EdgeInsets.all(8),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                ...parser.parse(
                                  challenge.fillInTheBlank!.sentence.replaceAll(
                                      'BLANK', '<input value="e" />'),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  else
                    Container(),
                  if (challenge.audio != null)
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
                        onPressed: () => {
                          model.setAudio(challenge.audio!.fileName),
                          model.playOrPauseAudio(),
                        },
                        child: Text(
                          '${model.isPlaying ? 'Pause' : 'Play'} Audio',
                          style: const TextStyle(fontSize: 20),
                        ),
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
                      onPressed: () => {},
                      child: const Text(
                        'Check Answers',
                        style: TextStyle(fontSize: 20),
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
