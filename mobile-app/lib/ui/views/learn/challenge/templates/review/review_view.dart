import 'package:flutter/material.dart';
import 'package:freecodecamp/extensions/i18n_extension.dart';
import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';
import 'package:freecodecamp/ui/theme/fcc_theme.dart';
import 'package:freecodecamp/ui/views/learn/challenge/templates/review/review_viewmodel.dart';
import 'package:freecodecamp/ui/views/learn/widgets/assignment_widget.dart';
import 'package:freecodecamp/ui/views/learn/widgets/challenge_card.dart';
import 'package:freecodecamp/ui/views/learn/widgets/transcript_widget.dart';
import 'package:freecodecamp/ui/views/news/html_handler/html_handler.dart';
import 'package:stacked/stacked.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class ReviewView extends StatelessWidget {
  const ReviewView({
    super.key,
    required this.challenge,
    required this.block,
    required this.challengesCompleted,
  });

  final Challenge challenge;
  final Block block;
  final int challengesCompleted;

  @override
  Widget build(BuildContext context) {
    HTMLParser parser = HTMLParser(context: context);

    return ViewModelBuilder<ReviewViewmodel>.reactive(
      viewModelBuilder: () => ReviewViewmodel(),
      onViewModelReady: (model) => model.initChallenge(challenge),
      builder: (context, model, child) {
        YoutubePlayerController controller =
            YoutubePlayerController.fromVideoId(
          videoId: challenge.videoId!,
          autoPlay: false,
          params: const YoutubePlayerParams(
            showControls: true,
            showFullscreenButton: true,
            strictRelatedVideos: true,
          ),
        );

        controller.setFullScreenListener(
          (_) async {
            final videoData = await controller.videoData;
            final startSeconds = await controller.currentTime;

            final currentTime = await FullscreenYoutubePlayer.launch(
              context,
              videoId: videoData.videoId,
              startSeconds: startSeconds,
            );

            if (currentTime != null) {
              controller.seekTo(seconds: currentTime);
            }
          },
        );

        return Scaffold(
          backgroundColor: FccColors.gray90,
          persistentFooterAlignment: AlignmentDirectional.topStart,
          appBar: AppBar(
            backgroundColor: FccColors.gray90,
          ),
          body: SafeArea(
            child: ListView(
              children: [
                ChallengeCard(
                  title: challenge.title,
                  child: Column(
                    children: [
                      ...parser.parse(
                        challenge.instructions,
                        fontColor: FccColors.gray05,
                      ),
                      ...parser.parse(
                        challenge.description,
                        fontColor: FccColors.gray05,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
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
                if (challenge.transcript != null &&
                    challenge.transcript!.isNotEmpty) ...[
                  ChallengeCard(
                    title: 'Transcript',
                    child: Transcript(
                      transcript: challenge.transcript!,
                    ),
                  ),
                ],
                const SizedBox(height: 12),
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
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(0, 50),
                            backgroundColor:
                                const Color.fromRGBO(0x3b, 0x3b, 0x4f, 1),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                              side: BorderSide(
                                width: 2,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          onPressed: model.assignmentsStatus
                                  .every((element) => element)
                              ? () => model.learnService.goToNextChallenge(
                                  block.challenges.length,
                                  challengesCompleted,
                                  challenge,
                                  block)
                              : null,
                          child: Text(
                            context.t.next,
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
