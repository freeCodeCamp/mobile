import 'package:flutter/material.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';
import 'package:freecodecamp/ui/views/learn/learn-builders/challenge-builder/challenge_builder_model.dart';
import 'package:stacked/stacked.dart';

class ChallengeBuilderListView extends StatelessWidget {
  final Block block;

  const ChallengeBuilderListView({
    Key? key,
    required this.block,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ChallengeBuilderModel>.reactive(
        viewModelBuilder: () => ChallengeBuilderModel(),
        onModelReady: (model) => model.init(block.challenges),
        builder: (context, model, child) => Container(
            color: const Color(0xFF0a0a23),
            child: ListView(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              children: [
                ListTile(
                  tileColor: const Color(0xFF0a0a23),
                  leading: Icon(model.isOpen
                      ? Icons.arrow_drop_down_sharp
                      : Icons.arrow_right_sharp),
                  title:
                      Text(model.isOpen ? 'Collapse course' : 'Expand course'),
                  trailing: Text(
                    '${model.challengesCompleted}/${block.challenges.length}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    model.setIsOpen = !model.isOpen;
                  },
                ),
                model.isOpen
                    ? ListView.builder(
                        shrinkWrap: true,
                        itemCount: block.challenges.length,
                        physics: const ClampingScrollPhysics(),
                        itemBuilder: (context, i) => ListTile(
                              leading: model.getIcon(model
                                  .completedChallenge(block.challenges[i].id)),
                              title: Text(block.challenges[i].name),
                              onTap: () {
                                String challenge = block.challenges[i].name
                                    .toLowerCase()
                                    .replaceAll(' ', '-');
                                String url =
                                    'https://freecodecamp.dev/page-data/learn';

                                model.routeToBrowserView(
                                    '$url/${block.superBlock}/${block.dashedName}/$challenge/page-data.json');
                              },
                            ))
                    : Container()
              ],
            )));
  }
}
