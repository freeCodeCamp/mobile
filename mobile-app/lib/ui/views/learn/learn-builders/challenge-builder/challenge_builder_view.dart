import 'package:flutter/material.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';
import 'package:freecodecamp/ui/views/learn/learn-builders/challenge-builder/challenge_builder_model.dart';
import 'package:stacked/stacked.dart';

class ChallengeBuilderView extends StatelessWidget {
  final Block block;

  const ChallengeBuilderView({
    Key? key,
    required this.block,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ChallengeBuilderModel>.reactive(
        viewModelBuilder: () => ChallengeBuilderModel(),
        builder: (context, model, child) => Container(
            color: const Color(0xFF0a0a23),
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: block.challenges.length,
                physics: const ClampingScrollPhysics(),
                itemBuilder: (context, i) => ListTile(
                      leading: model.hasCompletedChallenge(false),
                      title: Text(block.challenges[i].name),
                      onTap: () {
                        String challenge = block.challenges[i].name
                            .toLowerCase()
                            .replaceAll(' ', '-');
                        String url = 'https://freecodecamp.dev/page-data/learn';

                        model.routeToBrowserView(
                            '$url/${block.superBlock}/${block.dashedName}/$challenge/page-data.json');
                      },
                    ))));
  }
}
