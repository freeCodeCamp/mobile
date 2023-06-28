import 'package:flutter/material.dart';
import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';
import 'package:freecodecamp/ui/views/learn/challenge/templates/python/python_viewmodel.dart';
import 'package:freecodecamp/ui/views/news/html_handler/html_handler.dart';
import 'package:freecodecamp/ui/widgets/drawer_widget/drawer_widget_view.dart';
import 'package:stacked/stacked.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class PythonView extends StatelessWidget {
  const PythonView({
    Key? key,
    required this.challenge,
    required this.block,
    required this.challengesCompleted,
  }) : super(key: key);

  final Challenge challenge;
  final Block block;
  final int challengesCompleted;

  @override
  Widget build(BuildContext context) {
    HTMLParser parser = HTMLParser(context: context);

    return ViewModelBuilder<PythonViewModel>.reactive(
      viewModelBuilder: () => PythonViewModel(),
      builder: (context, model, child) {
        YoutubePlayerController controller = YoutubePlayerController(
          initialVideoId: challenge.videoId!,
          params: const YoutubePlayerParams(
            showControls: true,
            showFullscreenButton: true,
            autoPlay: false,
            strictRelatedVideos: true,
          ),
        );

        return WillPopScope(
          onWillPop: () async {
            model.learnService.updateProgressOnPop(context, block);

            return Future.value(true);
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                '$challengesCompleted of ${block.challenges.length} Questions',
              ),
            ),
            body: SafeArea(
              bottom: false,
              child: ListView(
                padding: const EdgeInsets.all(12),
                children: [
                  const SizedBox(height: 12),
                  YoutubePlayerIFrame(
                    controller: controller,
                  ),
                  const SizedBox(height: 12),
                  ...parser.parse(
                    challenge.description,
                  ),
                  if (challenge.description.isNotEmpty) buildDivider(),
                  ...parser.parse(
                    challenge.question!.text,
                  ),
                  const SizedBox(height: 8),
                  for (var answer
                      in challenge.question!.answers.asMap().entries)
                    questionOption(answer, model),
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
                    onPressed: model.currentChoice != -1
                        ? model.choiceStatus != null && model.choiceStatus!
                            ? () => model.learnService.goToNextChallenge(
                                block.challenges.length,
                                challengesCompleted,
                                challenge,
                                block)
                            : () => model.checkOption(challenge)
                        : null,
                    child: Text(
                      model.choiceStatus != null
                          ? model.choiceStatus!
                              ? 'Next challenge'
                              : 'Try Again'
                          : 'Check your answer',
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

  Container questionOption(
    MapEntry<int, String> answer,
    PythonViewModel model,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: RadioListTile<int>(
        tileColor: const Color(0xFF0a0a23),
        value: answer.key,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 8,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
          side: BorderSide(
            color: answer.key == model.currentChoice
                ? const Color(0xFFFFFFFF)
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
              child: Text(
                model.removeHtmlTags(answer.value),
                style: const TextStyle(
                  fontSize: 20,
                  fontFamily: 'Lato',
                ),
              ),
            ),
            if (model.choiceStatus != null &&
                model.currentChoice == answer.key) ...{
              Expanded(
                flex: 0,
                child: Icon(
                  model.choiceStatus! ? Icons.check_circle : Icons.cancel,
                  color: model.choiceStatus! ? Colors.green : Colors.red,
                ),
              )
            }
          ],
        ),
      ),
    );
  }
}
