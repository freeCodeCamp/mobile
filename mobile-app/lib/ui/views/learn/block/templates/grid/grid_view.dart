import 'package:flutter/material.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';
import 'package:freecodecamp/ui/views/learn/block/block_template_viewmodel.dart';
import 'package:freecodecamp/ui/views/learn/block/templates/grid/grid_viewmodel.dart';
import 'package:stacked/stacked.dart';

class BlockGridView extends StatelessWidget {
  const BlockGridView({
    Key? key,
    required this.block,
    required this.model,
  }) : super(key: key);

  final Block block;
  final BlockTemplateViewModel model;

  @override
  Widget build(BuildContext context) {
    // We want to make sure never to divide by 0 and show
    // a progress percentage of 1% if non have been completed.

    double progress = model.challengesCompleted == 0
        ? 0.01
        : model.challengesCompleted / block.challenges.length;

    return ViewModelBuilder.reactive(
      viewModelBuilder: () => BlockGridViewModel(),
      builder: (context, childModel, child) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            // For some dumb reason the progress indicator does not
            // get a specified width from the column.
            width: MediaQuery.of(context).size.width * 0.9,
            child: LinearProgressIndicator(
              minHeight: 10,
              value: progress,
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color.fromRGBO(0x99, 0xc9, 0xff, 1),
              ),
              backgroundColor: const Color.fromRGBO(0x2a, 0x2a, 0x40, 1),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: TextButton(
                  onPressed: () {
                    model.setIsOpen = !model.isOpen;
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
                    model.isOpen ? 'Hide Steps' : 'Show Steps',
                  ),
                ),
              ),
            ],
          ),
          if (model.isOpen)
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  height: 195,
                  width: MediaQuery.of(context).size.width - 34,
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 6,
                      mainAxisExtent: 60,
                      mainAxisSpacing: 3,
                      crossAxisSpacing: 3,
                    ),
                    itemCount: block.challenges.length,
                    itemBuilder: (context, step) {
                      return ChallengeTile(
                        block: block,
                        model: model,
                        step: step + 1,
                        challengeId: block.challengeTiles[step].id,
                        isDowloaded: false,
                      );
                    },
                  ),
                ),
              ],
            ),
        ],
      ),
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
  final BlockTemplateViewModel model;
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
