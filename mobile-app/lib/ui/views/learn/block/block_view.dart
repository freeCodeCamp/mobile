import 'package:flutter/material.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';
import 'package:freecodecamp/ui/views/learn/block/block_viewmodel.dart';
import 'package:stacked/stacked.dart';

class BlockTemplateView extends StatelessWidget {
  final Block block;
  final bool isOpen;
  final bool isStepBased;

  const BlockTemplateView({
    Key? key,
    required this.block,
    required this.isOpen,
    required this.isStepBased,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BlockTemplateViewModel>.reactive(
      onViewModelReady: (model) async {
        model.init(block.challengeTiles);
        model.setIsDev = await model.developerService.developmentMode();
      },
      viewModelBuilder: () => BlockTemplateViewModel(),
      builder: (
        context,
        model,
        child,
      ) {
        // double progress = model.challengesCompleted / block.challenges.length;

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
              child: Container()),
        );
      },
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
