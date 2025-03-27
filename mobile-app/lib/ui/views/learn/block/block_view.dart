import 'package:flutter/material.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';
import 'package:freecodecamp/ui/views/learn/block/block_viewmodel.dart';
// import 'package:freecodecamp/ui/views/learn/utils/learn_globals.dart';
// import 'package:freecodecamp/ui/views/learn/widgets/download_button_widget.dart';
// import 'package:freecodecamp/ui/views/learn/widgets/progressbar_widget.dart';
// import 'package:freecodecamp/ui/widgets/drawer_widget/drawer_widget_view.dart';
import 'package:stacked/stacked.dart';

class BlockView extends StatelessWidget {
  final Block block;
  final bool isOpen;
  final bool isStepBased;

  const BlockView({
    Key? key,
    required this.block,
    required this.isOpen,
    required this.isStepBased,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BlockViewModel>.reactive(
      onViewModelReady: (model) async {
        model.init(block.challengeTiles);
        model.setIsOpen = isOpen;
        model.setIsDownloaded = await model.isBlockDownloaded(block);
        model.setIsDev = await model.developerService.developmentMode();
      },
      viewModelBuilder: () => BlockViewModel(),
      builder: (
        context,
        model,
        child,
      ) {
        double progress = model.challengesCompleted / block.challenges.length;

        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: const Color.fromRGBO(0x3b, 0x3b, 0x4f, 1),
              ),
              color: const Color.fromRGBO(0x1b, 0x1b, 0x32, 1),
            ),
            padding: const EdgeInsets.all(8),
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8),
                      child: Icon(
                        Icons.monitor,
                        color: Color.fromRGBO(0x19, 0x8e, 0xee, 1),
                        size: 40,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            block.name,
                            style: const TextStyle(
                              wordSpacing: 0,
                              letterSpacing: 0,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (block.challenges.length > 1)
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 8, bottom: 8, right: 10),
                              child: LinearProgressIndicator(
                                minHeight: 10,
                                value: progress,
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  Color.fromRGBO(0x99, 0xc9, 0xff, 1),
                                ),
                                backgroundColor:
                                    const Color.fromRGBO(0x2a, 0x2a, 0x40, 1),
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          if (block.challenges.length == 1)
                            Text(block.description.join()),
                          if (block.challenges.length > 1)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 4,
                                  ),
                                  child: TextButton(
                                    onPressed: () {
                                      model.setIsOpen = !model.isOpen;
                                    },
                                    style: TextButton.styleFrom(
                                      backgroundColor: const Color.fromRGBO(
                                          0x1b, 0x1b, 0x32, 1),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        side: const BorderSide(
                                          color: Color.fromRGBO(
                                              0x3b, 0x3b, 0x4f, 1),
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      model.isOpen
                                          ? 'Hide Steps'
                                          : 'Show Steps',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          if (model.isOpen)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 195,
                                  width:
                                      MediaQuery.of(context).size.width - 100,
                                  child: GridView.builder(
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 6,
                                            mainAxisExtent: 50,
                                            mainAxisSpacing: 3,
                                            crossAxisSpacing: 3),
                                    itemCount: block.challenges.length,
                                    itemBuilder: (context, step) {
                                      return ChallengeTile(
                                        block: block,
                                        model: model,
                                        step: step + 1,
                                        challengeId:
                                            block.challengeTiles[step].id,
                                        isDowloaded: false,
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (block.challenges.length == 1)
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              backgroundColor:
                                  const Color.fromRGBO(0x5a, 0x01, 0xa7, 1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            child: const Text(
                              'Start',
                              style: TextStyle(fontWeight: FontWeight.bold),
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

  Widget dialogueWidget(
    List<ChallengeOrder> challenges,
    BuildContext context,
    BlockViewModel model,
  ) {
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
    return Column(
      children: [
        ...List.generate(structure.length, (step) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  dialogueHeaders[step].title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              GridView.count(
                physics: const ClampingScrollPhysics(),
                shrinkWrap: true,
                padding: const EdgeInsets.all(16),
                crossAxisCount: (MediaQuery.of(context).size.width / 70 -
                        MediaQuery.of(context).viewPadding.horizontal)
                    .round(),
                children: List.generate(
                  structure[step].length,
                  (index) {
                    return Center(
                      child: ChallengeTile(
                        block: block,
                        model: model,
                        challengeId: structure[step][index].id,
                        step: int.parse(
                          structure[step][index].title.split('Task')[1],
                        ),
                        isDowloaded: false,
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        })
      ],
    );
  }
}

class ChallengeTile extends StatelessWidget {
  const ChallengeTile({
    Key? key,
    required this.block,
    required this.model,
    required this.step,
    required this.isDowloaded,
    required this.challengeId,
  }) : super(key: key);

  final Block block;
  final BlockViewModel model;
  final int step;
  final bool isDowloaded;
  final String challengeId;

  @override
  Widget build(BuildContext context) {
    bool isCompleted = model.completedChallenge(challengeId);

    return TextButton(
      onPressed: () {
        model.routeToChallengeView(
          block,
          challengeId,
        );
      },
      style: TextButton.styleFrom(
        backgroundColor: isCompleted
            ? const Color.fromRGBO(0x00, 0x2e, 0xad, 0.3)
            : const Color.fromRGBO(0x2a, 0x2a, 0x40, 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
          side: isCompleted
              ? const BorderSide(
                  width: 1,
                  color: Color.fromRGBO(0xbc, 0xe8, 0xf1, 1),
                )
              : const BorderSide(
                  color: Color.fromRGBO(0x3b, 0x3b, 0x4f, 1),
                ),
        ),
      ),
      child: Text(
        step.toString(),
      ),
    );
  }
}
