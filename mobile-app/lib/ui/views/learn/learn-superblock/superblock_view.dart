import 'package:flutter/material.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';
import 'package:freecodecamp/ui/views/learn/learn_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'package:url_launcher/url_launcher.dart';

class SuperBlockView extends StatelessWidget {
  const SuperBlockView({Key? key, required this.superBlockName})
      : super(key: key);

  final String superBlockName;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LearnViewModel>.reactive(
        viewModelBuilder: () => LearnViewModel(),
        builder: (context, model, child) => Scaffold(
              appBar: AppBar(),
              body: FutureBuilder<SuperBlock>(
                  future: model.getSuperBlockData(superBlockName),
                  builder: ((context, snapshot) {
                    if (snapshot.hasData) {
                      SuperBlock superBlock = snapshot.data as SuperBlock;

                      return superBlockTemplate(model, superBlock);
                    }

                    return const Center(child: CircularProgressIndicator());
                  })),
            ));
  }

  Widget superBlockTemplate(LearnViewModel model, SuperBlock superBlock) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: ListView.separated(
        separatorBuilder: (context, int i) => const Divider(
          height: 50,
          color: Color.fromRGBO(0, 0, 0, 0),
        ),
        shrinkWrap: true,
        itemCount: superBlock.blocks.length,
        physics: const ClampingScrollPhysics(),
        itemBuilder: (context, i) => blockBuilder(model, superBlock.blocks[i]),
      ),
    );
  }

  Widget blockBuilder(LearnViewModel model, Block block) {
    return Container(
      padding: const EdgeInsets.only(top: 32),
      color: const Color(0xFF0a0a23),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            block.blockName,
            textAlign: TextAlign.left,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            child: challengeBuilder(model, block),
          )
        ],
      ),
    );
  }

  Stepper challengeBuilder(LearnViewModel model, Block block) {
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
