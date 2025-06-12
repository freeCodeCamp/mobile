import 'package:flutter/material.dart';
import 'package:freecodecamp/extensions/i18n_extension.dart';
import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';
import 'package:freecodecamp/ui/views/learn/challenge/templates/multiple_choice/multiple_choice_viewmodel.dart';
import 'package:freecodecamp/ui/views/learn/widgets/assignment_widget.dart';
import 'package:freecodecamp/ui/views/learn/widgets/audio/audio_player_view.dart';
import 'package:freecodecamp/ui/views/learn/widgets/challenge_card.dart';
import 'package:freecodecamp/ui/views/learn/widgets/explanation_widget.dart';
import 'package:freecodecamp/ui/views/learn/widgets/youtube_player_widget.dart';
import 'package:freecodecamp/ui/views/news/html_handler/html_handler.dart';
import 'package:stacked/stacked.dart';

class MultipleChoiceView extends StatelessWidget {
  const MultipleChoiceView({
    super.key,
    required this.challenge,
    required this.block,
    required this.challengesCompleted,
    required this.currentChallengeNum,
  });

  final Challenge challenge;
  final Block block;
  final int currentChallengeNum;
  final int challengesCompleted;

  Widget buildDivider() {
    return const Divider(
      color: Colors.white,
      thickness: 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    HTMLParser parser = HTMLParser(context: context);

    return ViewModelBuilder<MultipleChoiceViewmodel>.reactive(
      viewModelBuilder: () => MultipleChoiceViewmodel(),
      onViewModelReady: (model) => model.initChallenge(challenge),
      builder: (context, model, child) {
        int numberOfDialogueHeaders = block.challenges
            .where((challenge) => challenge.title.contains('Dialogue'))
            .length;

        String handleChallengeTitle() {
          if (challenge.title.contains('Task')) {
            return '${challenge.title} of ${block.challenges.length - numberOfDialogueHeaders} Tasks';
          } else {
            return 'Question ${challenge.title} of ${block.challenges.length - numberOfDialogueHeaders} Questions';
          }
        }

        return Scaffold(
          backgroundColor: const Color(0xFF0a0a23),
          appBar: AppBar(
            backgroundColor: const Color(0xFF0a0a23),
            title: Text(handleChallengeTitle()),
          ),
          body: SafeArea(
            child: ListView(
              children: [
                if (challenge.videoId != null) ...[
                  ChallengeCard(
                    title: 'Watch the Video',
                    child: YoutubePlayerWidget(
                      videoId: challenge.videoId!,
                    ),
                  ),
                ],
                if (challenge.audio != null) ...[
                  ChallengeCard(
                    title: 'Listen to the Audio',
                    child: AudioPlayerView(
                      audio: challenge.audio!,
                    ),
                  ),
                ],
                if (challenge.assignments != null &&
                    challenge.assignments!.isNotEmpty) ...[
                  ChallengeCard(
                    title: 'Assignments',
                    child: Column(
                      children: [
                        for (final (i, assignment)
                            in challenge.assignments!.indexed)
                          Assignment(
                              label: assignment,
                              value: model.assignmentsStatus[i],
                              onTap: () {
                                model.setAssignmentStatus(i);
                              },
                              onChanged: (value) {
                                model.setAssignmentStatus(i);
                              }),
                      ],
                    ),
                  ),
                ],
                if (challenge.description.isNotEmpty)
                  ChallengeCard(
                    title: 'Description',
                    child: Column(
                      children: parser.parse(
                        challenge.description,
                      ),
                    ),
                  ),
                ChallengeCard(
                  title: 'Question',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...parser.parse(challenge.instructions),
                      ...parser.parse(
                        challenge.question!.text,
                      ),
                      const SizedBox(height: 8),
                      for (var answerObj
                          in challenge.question!.answers.asMap().entries)
                        questionOption(answerObj, model, context),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                if (challenge.explanation != null &&
                    challenge.explanation!.isNotEmpty) ...[
                  ChallengeCard(
                    title: 'Explanation',
                    child: Explanation(
                      explanation: challenge.explanation ?? '',
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(0, 50),
                      backgroundColor:
                          const Color.fromRGBO(0x3b, 0x3b, 0x4f, 1),
                      side: const BorderSide(
                        width: 2,
                        color: Colors.white,
                      ),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    onPressed: model.currentChoice != -1 &&
                            model.assignmentsStatus.every((element) => element)
                        ? model.choiceStatus != null && model.choiceStatus!
                            ? () => model.learnService.goToNextChallenge(
                                  block.challenges.length,
                                  challengesCompleted,
                                  challenge,
                                  block,
                                )
                            : () {
                                model.setValidationStatus(challenge);
                                model.updateFeedback(challenge, context);
                              }
                        : null,
                    child: Text(
                      model.choiceStatus != null
                          ? model.choiceStatus!
                              ? context.t.next_challenge
                              : context.t.try_again
                          : context.t.questions_check,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        );
      },
    );
  }

  Container questionOption(
    MapEntry<int, Answer> answerObj,
    MultipleChoiceViewmodel model,
    BuildContext context,
  ) {
    HTMLParser parser = HTMLParser(context: context);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Material(
        child: RadioListTile<int>(
          key: ValueKey(model.lastAnswer),
          selected: answerObj.key == model.currentChoice,
          tileColor: const Color(0xFF0a0a23),
          selectedTileColor: const Color(0xFF0a0a23),
          value: answerObj.key,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
            side: BorderSide(
              color: const Color(0xFFAAAAAA),
              width: 2,
            ),
          ),
          groupValue: model.currentChoice,
          onChanged: (value) {
            model.setChoiceStatus = null;
            model.setCurrentChoice = value ?? -1;
          },
          title: Align(
            alignment: Alignment.centerLeft,
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minHeight: 100,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: parser.parse(
                  answerObj.value.answer,
                  isSelectable: false,
                  removeParagraphMargin: true,
                ),
              ),
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (answerObj.key == model.lastAnswer) ...model.feedback,
            ],
          ),
        ),
      ),
    );
  }
}
