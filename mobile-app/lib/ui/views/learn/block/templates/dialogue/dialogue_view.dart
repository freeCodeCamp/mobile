import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_scroll_shadow/flutter_scroll_shadow.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';
import 'package:freecodecamp/ui/views/learn/block/block_template_viewmodel.dart';
import 'package:freecodecamp/ui/views/learn/block/templates/dialogue/dialogue_viewmodel.dart';
import 'package:freecodecamp/ui/views/learn/widgets/challenge_title.dart';
import 'package:stacked/stacked.dart';

class BlockDialogueView extends StatelessWidget {
  const BlockDialogueView({
    Key? key,
    required this.block,
    required this.model,
  }) : super(key: key);

  final Block block;
  final BlockTemplateViewModel model;

  @override
  Widget build(BuildContext context) {
    List<ChallengeOrder> challenges = block.challenges;
    List<List<ChallengeOrder>> structure = [];
    List<ChallengeOrder> dialogueHeaders = [];
    int dialogueIndex = 0;

    dialogueHeaders.add(challenges[0]);
    structure.add([]);

    for (int i = 1; i < challenges.length; i++) {
      if (challenges[i].title.contains('Dialogue')) {
        structure.add([]);
        dialogueHeaders.add(challenges[i]);
        dialogueIndex++;
      } else {
        structure[dialogueIndex].add(challenges[i]);
      }
    }

    log(structure.toString());

    return ViewModelBuilder.reactive(
      viewModelBuilder: () => BlockDialogueViewModel(),
      builder: (context, childModel, child) => Column(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width - 34,
            child: ListView.builder(
              physics: const ClampingScrollPhysics(),
              shrinkWrap: true,
              itemCount: structure.length,
              itemBuilder: (context, dialogueBlock) {
                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => model.routeToChallengeView(
                              block,
                              dialogueHeaders[dialogueBlock].id,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: model.completedChallenge(
                                  dialogueHeaders[dialogueBlock].id,
                                )
                                    ? const Color.fromRGBO(
                                        0x00, 0x2e, 0xad, 0.3)
                                    : const Color.fromRGBO(0x2a, 0x2a, 0x40, 1),
                                border: Border.all(
                                  color: model.completedChallenge(
                                          dialogueHeaders[dialogueBlock].id)
                                      ? const Color.fromRGBO(
                                          0xbc, 0xe8, 0xf1, 1)
                                      : const Color.fromRGBO(
                                          0x3b, 0x3b, 0x4f, 1),
                                  width: 1,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  dialogueHeaders[dialogueBlock].title,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 34,
                      height: 200,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ScrollShadow(
                          child: GridView.builder(
                            itemCount: structure[dialogueBlock].length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 6,
                              mainAxisSpacing: 3,
                              crossAxisSpacing: 3,
                            ),
                            itemBuilder: (context, task) {
                              return ChallengeTile(
                                block: block,
                                model: model,
                                challengeId: structure[dialogueBlock][task].id,
                                step: task + 1,
                                isDownloaded: false,
                              );
                            },
                          ),
                        ),
                      ),
                    )
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
