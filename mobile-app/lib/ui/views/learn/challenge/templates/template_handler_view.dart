import 'package:flutter/material.dart';
import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';
import 'package:freecodecamp/service/learn/learn_service.dart';
import 'package:freecodecamp/ui/views/learn/challenge/challenge_view.dart';
import 'package:freecodecamp/ui/views/learn/challenge/templates/english/english_view.dart';
import 'package:freecodecamp/ui/views/learn/challenge/templates/multiple_choice/multiple_choice_view.dart';
import 'package:freecodecamp/ui/views/learn/challenge/templates/python-project/python_project_view.dart';
import 'package:freecodecamp/ui/views/learn/challenge/templates/python/python_view.dart';
import 'package:freecodecamp/ui/views/learn/challenge/templates/template_handler_viewmodel.dart';
import 'package:stacked/stacked.dart';

class HandleChallengeTemplateView extends StatelessWidget {
  const HandleChallengeTemplateView({
    Key? key,
    required this.block,
    required this.challengesCompleted,
  }) : super(key: key);

  final Block block;

  final int challengesCompleted;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HandleTemplateModel>.reactive(
      viewModelBuilder: () => HandleTemplateModel(),
      builder: (context, model, child) => FutureBuilder<Challenge?>(
        future: model.challenge,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Challenge challenge = snapshot.data!;

            int challengeType = challenge.challengeType;
            List<ChallengeListTile> tiles = block.challengeTiles;
            int challNum = tiles.indexWhere((el) => el.id == challenge.id) + 1;
            String url = LearnService.baseUrl;
            switch (challengeType) {
              case 10:
                return PythonProjectView(
                  challenge: challenge,
                  block: block,
                  challengesCompleted: challengesCompleted,
                );
              case 11:
                return PythonView(
                  challenge: challenge,
                  block: block,
                  challengesCompleted: challengesCompleted,
                  currentChallengeNum: challNum,
                );
              case 15:
              case 19:
                return MultipleChoiceView(
                  challenge: challenge,
                  block: block,
                  challengesCompleted: challengesCompleted,
                  currentChallengeNum: challNum,
                );
              case 21:
              case 22:
                return EnglishView(
                  challenge: challenge,
                  block: block,
                  currentChallengeNum: challNum,
                );
              case 0:
                return ChallengeView(
                    url:
                        '$url/challenges/${block.superBlock.dashedName}/${block.dashedName}/${challenge.id}.json',
                    block: block,
                    challengeId: challenge.id,
                    challengesCompleted: challengesCompleted,
                    isProject: tiles.length > 1);
              default:
                return const Text('Unknown Challenge Type');
            }
          }

          return Container();
        },
      ),
    );
  }
}
