import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecodecamp/extensions/i18n_extension.dart';
import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';
import 'package:freecodecamp/ui/views/learn/challenge/templates/multiple_choice/multiple_choice_viewmodel.dart';
import 'package:freecodecamp/ui/views/learn/utils/challenge_utils.dart';
import 'package:freecodecamp/ui/views/learn/widgets/assignment_widget.dart';
import 'package:freecodecamp/ui/views/learn/widgets/audio/audio_player_view.dart';
import 'package:freecodecamp/ui/views/learn/widgets/challenge_card.dart';
import 'package:freecodecamp/ui/views/learn/widgets/explanation_widget.dart';
import 'package:freecodecamp/ui/views/learn/widgets/quiz_widget.dart';
import 'package:freecodecamp/ui/views/learn/widgets/scene/scene_view.dart';
import 'package:freecodecamp/ui/views/learn/widgets/transcript_widget.dart';
import 'package:freecodecamp/ui/views/learn/widgets/youtube_player_widget.dart';
import 'package:freecodecamp/ui/views/news/html_handler/html_handler.dart';

class MultipleChoiceView extends ConsumerStatefulWidget {
  const MultipleChoiceView({
    super.key,
    required this.challenge,
    required this.block,
    required this.currentChallengeNum,
  });

  final Challenge challenge;
  final Block block;
  final int currentChallengeNum;

  @override
  ConsumerState<MultipleChoiceView> createState() => _MultipleChoiceViewState();
}

class _MultipleChoiceViewState extends ConsumerState<MultipleChoiceView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final model = ref.read(multipleChoiceViewModelProvider);
      model.init(ref);
      model.initChallenge(widget.challenge);
    });
  }

  @override
  Widget build(BuildContext context) {
    final model = ref.watch(multipleChoiceViewModelProvider);
    HTMLParser parser = HTMLParser(context: context);

    return Scaffold(
      backgroundColor: const Color(0xFF0a0a23),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0a0a23),
        title: Text(handleChallengeTitle(widget.challenge, widget.block)),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            if (widget.challenge.description.isNotEmpty)
              ChallengeCard(
                title: 'Description',
                child: Column(
                  children: parser.parse(
                    widget.challenge.description,
                  ),
                ),
              ),
            if (widget.challenge.videoId != null) ...[
              ChallengeCard(
                title: 'Watch the Video',
                child: YoutubePlayerWidget(
                  videoId: widget.challenge.videoId!,
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
            if (widget.challenge.instructions.isNotEmpty)
              ChallengeCard(
                title: 'Instructions',
                child: Column(
                  children: parser.parse(
                    widget.challenge.instructions,
                  ),
                ),
              ),
            if (widget.challenge.assignments != null &&
                widget.challenge.assignments!.isNotEmpty) ...[
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
            ],
            QuizWidget(
                isValidated: model.isValidated,
                questions: model.quizQuestions,
                onChanged: (questionIndex, answerIndex) {
                  model.setSelectedAnswer(questionIndex, answerIndex);
                }),
            const SizedBox(height: 8),
            if (widget.challenge.explanation != null &&
                widget.challenge.explanation!.isNotEmpty) ...[
              ChallengeCard(
                title: 'Explanation',
                child: Explanation(
                  explanation: widget.challenge.explanation ?? '',
                ),
              ),
            ],
            const SizedBox(height: 8),
            if (model.errMessage.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  model.errMessage,
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(0, 50),
                  backgroundColor: const Color.fromRGBO(0x3b, 0x3b, 0x4f, 1),
                  side: const BorderSide(
                    width: 2,
                    color: Colors.white,
                  ),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                onPressed:
                    model.assignmentsStatus.every((element) => element) &&
                            model.quizQuestions
                                .every((q) => q.selectedAnswer != -1)
                        ? () {
                            if (model.isValidated &&
                                model.hasPassedAllQuestions) {
                              model.learnService.goToNextChallenge(
                                widget.block.challenges.length,
                                widget.challenge,
                                widget.block,
                              );
                            } else {
                              model.validateChallenge();
                            }
                          }
                        : null,
                child: Text(
                  model.isValidated
                      ? model.hasPassedAllQuestions
                          ? context.t.next_challenge
                          : context.t.try_again
                      : context.t.questions_check,
                  style: const TextStyle(fontSize: 20),
                ),
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
                      onPressed: () => model.learnService.forumHelpDialog(
                        widget.challenge,
                        widget.block,
                        context,
                      ),
                      child: const Text(
                        'Ask for Help',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
