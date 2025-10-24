import 'package:flutter/material.dart';
import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';
import 'package:freecodecamp/ui/views/learn/challenge/challenge_view.dart';
import 'package:freecodecamp/ui/views/learn/challenge/templates/english/english_view.dart';
import 'package:freecodecamp/ui/views/learn/challenge/templates/multiple_choice/multiple_choice_view.dart';
import 'package:freecodecamp/ui/views/learn/challenge/templates/python-project/python_project_view.dart';
import 'package:freecodecamp/ui/views/learn/challenge/templates/python/python_view.dart';
import 'package:freecodecamp/ui/views/learn/challenge/templates/quiz/quiz_view.dart';
import 'package:freecodecamp/ui/views/learn/challenge/templates/review/review_view.dart';
import 'package:freecodecamp/ui/views/learn/challenge/templates/template_viewmodel.dart';
import 'package:stacked/stacked.dart';

class ChallengeTemplateView extends StatelessWidget {
  const ChallengeTemplateView({
    super.key,
    required this.block,
    required this.challengeId,
    this.challengeDate,
  });

  final Block block;
  final String challengeId;

  // Used for daily challenges
  final DateTime? challengeDate;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ChallengeTemplateViewModel>.reactive(
      onViewModelReady: (model) =>
          model.initiate(block, challengeId, challengeDate),
      viewModelBuilder: () => ChallengeTemplateViewModel(),
      builder: (context, model, child) => Scaffold(
        resizeToAvoidBottomInset: false,
        body: FutureBuilder<Challenge?>(
          future: model.challenge,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Challenge challenge = snapshot.data!;

              List<ChallengeListTile> tiles = block.challengeTiles;
              int challNum =
                  tiles.indexWhere((el) => el.id == challenge.id) + 1;
              switch (challenge.challengeType) {
                case ChallengeType.html:
                case ChallengeType.js:
                case ChallengeType.multifileCertProject:
                case ChallengeType.python:
                case ChallengeType.multifilePythonCertProject:
                case ChallengeType.lab:
                case ChallengeType.jsLab:
                case ChallengeType.dailyChallengeJs:
                case ChallengeType.dailyChallengePy:
                  return ChallengeView(
                    challenge: challenge,
                    block: block,
                    isProject: tiles.length > 1,
                    challengeDate: challengeDate,
                  );
                case ChallengeType.quiz:
                  return QuizView(
                    challenge: challenge,
                    block: block,
                  );
                case ChallengeType.pythonProject:
                  return PythonProjectView(
                    challenge: challenge,
                    block: block,
                  );
                case ChallengeType.video:
                  return PythonView(
                    challenge: challenge,
                    block: block,
                    currentChallengeNum: challNum,
                  );
                case ChallengeType.theOdinProject:
                case ChallengeType.multipleChoice:
                  return MultipleChoiceView(
                    challenge: challenge,
                    block: block,
                    currentChallengeNum: challNum,
                  );
                case ChallengeType.dialogue:
                case ChallengeType.fillInTheBlank:
                  return EnglishView(
                    challenge: challenge,
                    block: block,
                    currentChallengeNum: challNum,
                  );
                case ChallengeType.generic:
                  return ReviewView(
                    challenge: challenge,
                    block: block,
                  );
                default:
                  return Center(
                    child: Text(
                      'Unknown Challenge, info : ${challenge.challengeType}',
                    ),
                  );
              }
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error: ${snapshot.error}\n${snapshot.stackTrace}',
                ),
              );
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
