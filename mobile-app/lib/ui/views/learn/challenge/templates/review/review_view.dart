import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecodecamp/extensions/i18n_extension.dart';
import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';
import 'package:freecodecamp/ui/theme/fcc_theme.dart';
import 'package:freecodecamp/ui/views/learn/challenge/templates/review/review_viewmodel.dart';
import 'package:freecodecamp/ui/views/learn/utils/challenge_utils.dart';
import 'package:freecodecamp/ui/views/learn/widgets/assignment_widget.dart';
import 'package:freecodecamp/ui/views/learn/widgets/audio/audio_player_view.dart';
import 'package:freecodecamp/ui/views/learn/widgets/challenge_card.dart';
import 'package:freecodecamp/ui/views/learn/widgets/scene/scene_view.dart';
import 'package:freecodecamp/ui/views/learn/widgets/transcript_widget.dart';
import 'package:freecodecamp/ui/views/learn/widgets/youtube_player_widget.dart';

class ReviewView extends ConsumerStatefulWidget {
  const ReviewView({
    super.key,
    required this.challenge,
    required this.block,
  });

  final Challenge challenge;
  final Block block;

  @override
  ConsumerState<ReviewView> createState() => _ReviewViewState();
}

class _ReviewViewState extends ConsumerState<ReviewView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(reviewViewModelProvider).initChallenge(widget.challenge, context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final model = ref.watch(reviewViewModelProvider);
    return Scaffold(
          backgroundColor: FccColors.gray90,
          persistentFooterAlignment: AlignmentDirectional.topStart,
          appBar: AppBar(
              backgroundColor: FccColors.gray90,
              title: Text(handleChallengeTitle(widget.challenge, widget.block))),
          body: SafeArea(
            child: ListView(
              children: [
                ChallengeCard(
                  title: widget.challenge.title,
                  child: Column(
                    children: [
                      ...model.parsedDescription,
                      ...model.parsedInstructions,
                    ],
                  ),
                ),
                if (widget.challenge.videoId != null) ...[
                  const SizedBox(height: 12),
                  ChallengeCard(
                    title: 'Video',
                    child: YoutubePlayerWidget(
                      videoId: widget.challenge.videoId!,
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                if (widget.challenge.scene != null) ...[
                  ChallengeCard(
                    title: 'Scene',
                    child: SceneView(
                      scene: widget.challenge.scene!,
                    ),
                  ),
                ] else if (widget.challenge.audio != null) ...[
                  ChallengeCard(
                    title: 'Listen to the Audio',
                    child: AudioPlayerView(
                      audio: widget.challenge.audio!,
                    ),
                  ),
                ],
                if (widget.challenge.transcript.isNotEmpty) ...[
                  ChallengeCard(
                    title: 'Transcript',
                    child: Transcript(
                      transcript: widget.challenge.transcript,
                      isCollapsible: widget.challenge.videoId != null,
                    ),
                  ),
                ],
                ChallengeCard(
                  title: 'Assignments',
                  child: Column(
                    children: [
                      for (final (i, assignment)
                          in widget.challenge.assignments!.indexed)
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
                                    widget.block.challenges.length,
                                    widget.challenge,
                                    widget.block,
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
  }
}
