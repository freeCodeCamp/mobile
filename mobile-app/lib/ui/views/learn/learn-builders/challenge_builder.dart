import 'package:flutter/material.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';
import 'package:freecodecamp/ui/views/learn/learn_viewmodel.dart';
import 'package:url_launcher/url_launcher.dart';

class ChallengeBuilder extends StatelessWidget {
  final Block block;
  final LearnViewModel model;

  const ChallengeBuilder({Key? key, required this.block, required this.model})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stepper(
        onStepTapped: (value) => {model.setCurrentStep = value},
        controlsBuilder: (context, details) => Row(children: []),
        currentStep: model.currentStep,
        physics: const ClampingScrollPhysics(),
        steps: [
          for (int i = 0; i < block.challenges.length; i++)
            Step(
                title: Text(
                  block.challenges[i].name,
                  style: const TextStyle(fontSize: 16),
                ),
                content: TextButton(
                  style: TextButton.styleFrom(
                      backgroundColor:
                          const Color.fromRGBO(0x2A, 0x2A, 0x40, 1)),
                  onPressed: () {
                    String challenge = block.challenges[i].name
                        .toLowerCase()
                        .replaceAll(' ', '-');
                    String url = 'https://freecodecamp.dev/learn';

                    launch(
                        '$url/${block.superBlock}/${block.dashedName}/$challenge');
                  },
                  child: const Text('CONTINUE THIS CHALLENGE'),
                ))
        ]);
  }
}
