import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:freecodecamp/extensions/i18n_extension.dart';
import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';
import 'package:freecodecamp/ui/views/learn/challenge/templates/multiple_choice/multiple_choice_viewmodel.dart';
import 'package:freecodecamp/ui/views/learn/widgets/audio/audio_player_view.dart';
import 'package:freecodecamp/ui/views/news/html_handler/html_handler.dart';
import 'package:freecodecamp/ui/widgets/drawer_widget/drawer_widget_view.dart';
import 'package:stacked/stacked.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class MultipleChoiceView extends StatelessWidget {
  const MultipleChoiceView({
    Key? key,
    required this.challenge,
    required this.block,
    required this.challengesCompleted,
    required this.currentChallengeNum,
  }) : super(key: key);

  final Challenge challenge;
  final Block block;
  final int currentChallengeNum;
  final int challengesCompleted;

  @override
  Widget build(BuildContext context) {
    HTMLParser parser = HTMLParser(context: context);

    return ViewModelBuilder<MultipleChoiceViewmodel>.reactive(
      viewModelBuilder: () => MultipleChoiceViewmodel(),
      onViewModelReady: (model) => model.initChallenge(challenge),
      builder: (context, model, child) {
        YoutubePlayerController controller =
            YoutubePlayerController.fromVideoId(
          videoId: challenge.videoId ?? '',
          autoPlay: false,
          params: const YoutubePlayerParams(
            showControls: true,
            showFullscreenButton: true,
            strictRelatedVideos: true,
          ),
        );

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

        return PopScope(
          canPop: true,
          onPopInvokedWithResult: (bool didPop, dynamic result) {
            model.learnService.updateProgressOnPop(context, block);
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                handleChallengeTitle(),
              ),
            ),
            body: SafeArea(
              bottom: false,
              child: ListView(
                padding: const EdgeInsets.all(12),
                children: [
                  Center(
                    child: Text(
                      challenge.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (challenge.videoId != null) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      child: YoutubePlayer(
                        controller: controller,
                        enableFullScreenOnVerticalDrag: false,
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                  ...parser.parse(
                    challenge.description,
                  ),
                  if (challenge.audio != null) ...[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Listen to the Audio',
                        style: TextStyle(
                          fontSize: FontSize.large.value,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                    Container(
                      color: const Color(0xFF0a0a23),
                      padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.all(8),
                      child: AudioPlayerView(
                        audio: challenge.audio!,
                      ),
                    )
                  ],
                  if (challenge.assignments != null &&
                      challenge.assignments!.isNotEmpty) ...[
                    buildDivider(),
                    Text(
                      'Assignments',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: FontSize.xLarge.value,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 8),
                    for (final (i, assignment)
                        in challenge.assignments!.indexed)
                      assignmentTile(assignment, i, model, context),
                  ],
                  if (challenge.description.isNotEmpty) buildDivider(),
                  ...parser.parse(
                    challenge.question!.text,
                  ),
                  const SizedBox(height: 8),
                  for (var answerObj
                      in challenge.question!.answers.asMap().entries)
                    questionOption(answerObj, model, context),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(0, 50),
                      backgroundColor:
                          const Color.fromRGBO(0x3b, 0x3b, 0x4f, 1),
                      side: const BorderSide(
                        width: 2,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: model.currentChoice != -1 &&
                            model.assignmentStatus.every((element) => element)
                        ? model.choiceStatus != null && model.choiceStatus!
                            ? () => model.learnService.goToNextChallenge(
                                  block.challenges.length,
                                  challengesCompleted,
                                  challenge,
                                  block,
                                )
                            : () => model.checkOption(challenge)
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
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Container assignmentTile(
    String assignment,
    int ind,
    MultipleChoiceViewmodel model,
    BuildContext context,
  ) {
    HTMLParser parser = HTMLParser(context: context);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        selected: model.assignmentStatus[ind],
        tileColor: const Color(0xFF0a0a23),
        selectedTileColor: const Color(0xDEFFFFFF),
        onTap: () {
          model.setAssignmentStatus = model.assignmentStatus
            ..[ind] = !model.assignmentStatus[ind];
        },
        leading: Checkbox(
          focusNode: FocusNode(),
          value: model.assignmentStatus[ind],
          onChanged: (value) {
            model.setAssignmentStatus = model.assignmentStatus
              ..[ind] = value ?? false;
          },
          activeColor: const Color(0xFF0a0a23),
          checkColor: const Color(0xDEFFFFFF),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
          side: BorderSide(
            color: model.assignmentStatus[ind]
                ? const Color(0xFF0a0a23)
                : const Color(0xFFAAAAAA),
            width: 2,
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: parser.parse(
                  assignment,
                  isSelectable: false,
                  fontColor: model.assignmentStatus[ind]
                      ? const Color(0xFF0a0a23)
                      : null,
                ),
              ),
            ),
          ],
        ),
      ),
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
      child: RadioListTile<int>(
        selected: answerObj.key == model.currentChoice,
        tileColor: const Color(0xFF0a0a23),
        selectedTileColor: const Color(0xDEFFFFFF),
        activeColor: const Color(0xFF0a0a23),
        value: answerObj.key,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
          side: BorderSide(
            color: answerObj.key == model.currentChoice
                ? const Color(0xFF0a0a23)
                : const Color(0xFFAAAAAA),
            width: 2,
          ),
        ),
        groupValue: model.currentChoice,
        onChanged: (value) {
          model.setChoiceStatus = null;
          model.setCurrentChoice = value ?? -1;
        },
        title: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: parser.parse(
                  answerObj.value.answer,
                  isSelectable: false,
                  fontColor: answerObj.key == model.currentChoice
                      ? const Color(0xFF0a0a23)
                      : null,
                ),
              ),
            ),
            SizedBox(
              width: 24,
              child: model.choiceStatus != null &&
                      model.currentChoice == answerObj.key
                  ? Icon(
                      model.choiceStatus! ? Icons.check_circle : Icons.cancel,
                      color: model.choiceStatus!
                          ? Colors.green.shade600
                          : Colors.red.shade600,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
