import 'package:flutter/material.dart';
import 'package:freecodecamp/extensions/i18n_extension.dart';
import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';
import 'package:freecodecamp/ui/theme/fcc_theme.dart';
import 'package:freecodecamp/ui/views/learn/challenge/templates/review/review_viewmodel.dart';
import 'package:freecodecamp/ui/views/learn/utils/challenge_utils.dart';
import 'package:freecodecamp/ui/views/learn/widgets/assignment_widget.dart';
import 'package:freecodecamp/ui/views/learn/widgets/challenge_card.dart';
import 'package:freecodecamp/ui/views/learn/widgets/scene/scene_view.dart';
import 'package:freecodecamp/ui/views/learn/widgets/audio/audio_player_view.dart';
import 'package:freecodecamp/ui/views/learn/widgets/transcript_widget.dart';
import 'package:freecodecamp/ui/views/learn/widgets/youtube_player_widget.dart';
import 'package:stacked/stacked.dart';

class ReviewView extends StatelessWidget {
  const ReviewView({
    super.key,
    required this.challenge,
    required this.block,
  });

  final Challenge challenge;
  final Block block;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ReviewViewmodel>.reactive(
      viewModelBuilder: () => ReviewViewmodel(),
      onViewModelReady: (model) => model.initChallenge(challenge, context),
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: FccColors.gray90,
          persistentFooterAlignment: AlignmentDirectional.topStart,
          appBar: AppBar(
              backgroundColor: FccColors.gray90,
              title: Text(handleChallengeTitle(challenge, block))),
          body: SafeArea(
            child: ListView(
              children: [
                ChallengeCard(
                  title: challenge.title,
                  child: Column(
                    children: [
                      ...model.parsedDescription,
                      ...model.parsedInstructions,
                    ],
                  ),
                ),
                if (challenge.videoId != null) ...[
                  const SizedBox(height: 12),
                  ChallengeCard(
                    title: 'Video',
                    child: YoutubePlayerWidget(
                      videoId: challenge.videoId!,
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                if (challenge.scene != null) ...[
                  ChallengeCard(
                    title: 'Scene',
                    child: SceneView(
                      scene: challenge.scene!,
                    ),
                  ),
                ] else if (challenge.audio != null) ...[
                  ChallengeCard(
                    title: 'Listen to the Audio',
                    child: AudioPlayerView(
                      audio: challenge.audio!,
                    ),
                  ),
                ],
                if (challenge.transcript.isNotEmpty) ...[
                  ChallengeCard(
                    title: 'Transcript',
                    child: Transcript(
                      transcript: challenge.transcript,
                      isCollapsible: challenge.videoId != null,
                    ),
                  ),
                ],
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
                                    challenge,
                                    block,
                                  )
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
