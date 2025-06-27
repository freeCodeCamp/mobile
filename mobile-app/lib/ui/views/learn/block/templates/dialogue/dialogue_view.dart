import 'package:flutter/material.dart';
import 'package:flutter_scroll_shadow/flutter_scroll_shadow.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';
import 'package:freecodecamp/ui/views/learn/block/block_template_viewmodel.dart';
import 'package:freecodecamp/ui/views/learn/block/templates/dialogue/dialogue_viewmodel.dart';
import 'package:freecodecamp/ui/views/learn/widgets/challenge_tile.dart';
import 'package:stacked/stacked.dart';

class BlockDialogueView extends StatelessWidget {
  const BlockDialogueView(
      {super.key,
      required this.block,
      required this.model,
      required this.isOpen,
      required this.isOpenFunction});

  final Block block;
  final BlockTemplateViewModel model;
  final bool isOpen;
  final Function isOpenFunction;

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

    return ViewModelBuilder.reactive(
      viewModelBuilder: () => BlockDialogueViewModel(),
      builder: (context, childModel, child) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: TextButton(
                  onPressed: () {
                    isOpenFunction();
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(0x1b, 0x1b, 0x32, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                      side: const BorderSide(
                        color: Color.fromRGBO(0x3b, 0x3b, 0x4f, 1),
                      ),
                    ),
                  ),
                  child: Text(
                    isOpen ? 'Hide Tasks' : 'Show Tasks',
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width - 34,
            child: ListView.builder(
              physics: const ClampingScrollPhysics(),
              shrinkWrap: true,
              itemCount: structure.length,
              itemBuilder: (context, dialogueBlock) {
                return isOpen
                    ? FutureBuilder(
                        future: model.completedChallenge(
                          dialogueHeaders[dialogueBlock].id,
                        ),
                        builder: (context, snapshot) {
                          bool isCompleted = snapshot.data ?? false;
                          return Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        left: 8,
                                        right: 8,
                                      ),
                                      child: InkWell(
                                        onTap: () => model.routeToChallengeView(
                                          block,
                                          dialogueHeaders[dialogueBlock].id,
                                        ),
                                        child: Container(
                                          constraints: const BoxConstraints(
                                            minHeight: 75,
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: isCompleted
                                                ? const Color.fromRGBO(
                                                    0x00, 0x2e, 0xad, 0.3)
                                                : const Color.fromRGBO(
                                                    0x2a, 0x2a, 0x40, 1),
                                            border: Border.all(
                                              color: isCompleted
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
                                              dialogueHeaders[dialogueBlock]
                                                  .title,
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
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
                                  padding: const EdgeInsets.only(
                                      right: 8, left: 8, bottom: 12, top: 4),
                                  child: ScrollShadow(
                                    child: GridView.builder(
                                      itemCount:
                                          structure[dialogueBlock].length,
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 6,
                                        mainAxisSpacing: 3,
                                        crossAxisSpacing: 3,
                                      ),
                                      itemBuilder: (context, task) {
                                        final challenge =
                                            structure[dialogueBlock][task];

                                        // challenge.name follows the "Task 1", "Task 2" format
                                        // so we extract the task number here
                                        final match = RegExp(r'\d+')
                                            .firstMatch(challenge.title);
                                        final taskNumber = match != null
                                            ? int.parse(match.group(0)!)
                                            : task + 1;

                                        return ChallengeTile(
                                          block: block,
                                          model: model,
                                          challengeId: challenge.id,
                                          step: taskNumber,
                                          isDownloaded: false,
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              )
                            ],
                          );
                        })
                    : Container();
              },
            ),
          ),
        ],
      ),
    );
  }
}
