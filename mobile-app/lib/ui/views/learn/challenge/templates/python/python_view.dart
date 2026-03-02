import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecodecamp/extensions/i18n_extension.dart';
import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';
import 'package:freecodecamp/ui/theme/fcc_theme.dart';
import 'package:freecodecamp/ui/views/learn/challenge/templates/python/python_viewmodel.dart';
import 'package:freecodecamp/ui/views/learn/utils/challenge_utils.dart';
import 'package:freecodecamp/ui/views/learn/widgets/challenge_card.dart';
import 'package:freecodecamp/ui/views/learn/widgets/quiz_widget.dart';
import 'package:freecodecamp/ui/views/learn/widgets/transcript_widget.dart';
import 'package:freecodecamp/ui/views/learn/widgets/youtube_player_widget.dart';
import 'package:freecodecamp/ui/views/news/html_handler/html_handler.dart';

class PythonView extends ConsumerStatefulWidget {
  const PythonView({
    super.key,
    required this.challenge,
    required this.block,
    required this.currentChallengeNum,
  });

  final Challenge challenge;
  final Block block;
  final int currentChallengeNum;

  @override
  ConsumerState<PythonView> createState() => _PythonViewState();
}

class _PythonViewState extends ConsumerState<PythonView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(pythonViewModelProvider).initChallenge(widget.challenge);
    });
  }

  @override
  Widget build(BuildContext context) {
    HTMLParser parser = HTMLParser(context: context);
    final model = ref.watch(pythonViewModelProvider);

    return Scaffold(
      backgroundColor: FccColors.gray90,
      appBar: AppBar(
        title: Text(handleChallengeTitle(widget.challenge, widget.block)),
      ),
      body: SafeArea(
        bottom: false,
        child: ListView(
          children: [
            Container(
              margin: const EdgeInsets.all(8),
              child: Center(
                child: Text(
                  widget.challenge.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            if (widget.challenge.description.isNotEmpty)
              ChallengeCard(
                title: 'Description',
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    children: parser.parse(
                      widget.challenge.description,
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 12),
            if (widget.challenge.videoId != null)
              ChallengeCard(
                title: 'Video',
                child: YoutubePlayerWidget(
                  videoId: widget.challenge.videoId!,
                ),
              ),
            const SizedBox(height: 12),
            if (widget.challenge.transcript.isNotEmpty) ...[
              ChallengeCard(
                title: 'Transcript',
                child: Transcript(
                  transcript: widget.challenge.transcript,
                  isCollapsible: widget.challenge.videoId != null,
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
            QuizWidget(
                isValidated: model.isValidated,
                questions: model.quizQuestions,
                onChanged: (questionIndex, answerIndex) {
                  model.setSelectedAnswer(questionIndex, answerIndex);
                }),
            const SizedBox(height: 16),
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
            const SizedBox(height: 16),
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
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                ),
                onPressed: model.quizQuestions
                        .every((q) => q.selectedAnswer != -1)
                    ? () {
                        if (model.isValidated && model.hasPassedAllQuestions) {
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
