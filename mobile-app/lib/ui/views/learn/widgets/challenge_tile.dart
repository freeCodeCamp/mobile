import 'package:flutter/material.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';
import 'package:freecodecamp/ui/views/learn/block/block_template_viewmodel.dart';

class ChallengeTile extends StatelessWidget {
  const ChallengeTile({
    super.key,
    required this.block,
    required this.model,
    required this.step,
    required this.isDownloaded,
    required this.challengeId,
  });

  final Block block;
  final BlockTemplateViewModel model;
  final int step;
  final bool isDownloaded;
  final String challengeId;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: model.completedChallenge(challengeId),
      builder: (context, snapshot) {
        final isCompleted = snapshot.data ?? false;

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
      },
    );
  }
}
