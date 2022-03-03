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
      color: const Color(0xFF0a0a23),
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: superBlock.blocks.length,
        physics: const ClampingScrollPhysics(),
        itemBuilder: (context, i) => blockBuilder(model, superBlock.blocks[i]),
      ),
    );
  }

  Widget blockBuilder(LearnViewModel model, Block block) {
    return Column(
      children: [
        Text(
          block.blockName,
          textAlign: TextAlign.left,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        Stepper(
            onStepTapped: (value) => {model.setCurrentStep = value},
            controlsBuilder: (context, details) => Row(children: []),
            margin: const EdgeInsets.all(10),
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
            ])
      ],
    );
  }
}
