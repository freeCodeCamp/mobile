import 'package:flutter/material.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';
import 'package:freecodecamp/service/learn_service.dart';
import 'package:freecodecamp/ui/views/learn/learn-builders/challenge-builder/challenge_builder_model.dart';
import 'package:freecodecamp/ui/widgets/drawer_widget/drawer_widget_view.dart';
import 'package:stacked/stacked.dart';

// ignore: must_be_immutable
class ChallengeBuilderListView extends StatelessWidget {
  final Block block;
  final bool isOpen;

  ChallengeBuilderListView({
    Key? key,
    required this.block,
    required this.isOpen,
  }) : super(key: key);
  LearnService learnService = locator<LearnService>();
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ChallengeBuilderModel>.reactive(
        viewModelBuilder: () => ChallengeBuilderModel(),
        onModelReady: (model) {
          model.init(block.challenges);
          model.setIsOpen = isOpen;
        },
        builder: (context, model, child) => Container(
            color: const Color(0xFF0a0a23),
            child: ListView(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    block.blockName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 22),
                  ),
                ),
                buildDivider(),
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
                    model.setBlockOpenState(
                      block.blockName,
                      model.isOpen,
                    );
                  },
                ),
                model.isOpen
                    ? Column(
                        children: [
                          for (String blockString in block.description)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                              child: Text(
                                blockString,
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    height: 1.2,
                                    fontFamily: 'Lato',
                                    color: Colors.white.withOpacity(0.87)),
                              ),
                            ),
                          buildDivider(),
                          ListView.builder(
                              shrinkWrap: true,
                              itemCount: block.challenges.length,
                              physics: const ClampingScrollPhysics(),
                              itemBuilder: (context, i) => ListTile(
                                    leading: model.getIcon(
                                        model.completedChallenge(
                                            block.challenges[i].id)),
                                    title: Text(block.challenges[i].name),
                                    onTap: () async {
                                      String challenge = block
                                          .challenges[i].name
                                          .toLowerCase()
                                          .replaceAll(' ', '-')
                                          .replaceAll(RegExp(r"[@':]"), '');
                                      String url = await learnService
                                          .getBaseUrl('/page-data/learn');

                                      model.routeToBrowserView(
                                        '$url/${block.superBlock}/${block.dashedName}/$challenge/page-data.json',
                                        block,
                                      );
                                    },
                                  )),
                        ],
                      )
                    : Container()
              ],
            )));
  }
}
