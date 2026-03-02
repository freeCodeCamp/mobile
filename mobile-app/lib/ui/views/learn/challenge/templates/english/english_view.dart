import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';
import 'package:freecodecamp/ui/theme/fcc_theme.dart';
import 'package:freecodecamp/ui/views/learn/challenge/templates/english/english_viewmodel.dart';
import 'package:freecodecamp/ui/views/learn/utils/challenge_utils.dart';
import 'package:freecodecamp/ui/views/learn/widgets/challenge_card.dart';
import 'package:freecodecamp/ui/views/learn/widgets/explanation_widget.dart';
import 'package:freecodecamp/ui/views/learn/widgets/scene/scene_view.dart';
import 'package:freecodecamp/ui/views/news/html_handler/html_handler.dart';

class EnglishView extends ConsumerStatefulWidget {
  const EnglishView({
    super.key,
    required this.challenge,
    required this.block,
    required this.currentChallengeNum,
  });

  final Challenge challenge;
  final Block block;
  final int currentChallengeNum;

  @override
  ConsumerState<EnglishView> createState() => _EnglishViewState();
}

class _EnglishViewState extends ConsumerState<EnglishView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(englishViewModelProvider).initBlankInputStreamListener();
    });
  }

  @override
  Widget build(BuildContext context) {
    HTMLParser parser = HTMLParser(context: context);
    final model = ref.watch(englishViewModelProvider);

    return Scaffold(
      backgroundColor: FccColors.gray90,
      persistentFooterAlignment: AlignmentDirectional.topStart,
      appBar: AppBar(
        backgroundColor: FccColors.gray90,
        title: Text(handleChallengeTitle(widget.challenge, widget.block)),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            ChallengeCard(
              title: widget.challenge.title,
              child: Column(
                children: [
                  ...parser.parse(
                    widget.challenge.description,
                    customStyles: {
                      '*:not(h1):not(h2):not(h3):not(h4):not(h5):not(h6)':
                          Style(color: FccColors.gray05),
                    },
                  ),
                  ...parser.parse(
                    widget.challenge.instructions,
                    customStyles: {
                      '*:not(h1):not(h2):not(h3):not(h4):not(h5):not(h6)':
                          Style(color: FccColors.gray05),
                    },
                  ),
                ],
              ),
            ),
            if (widget.challenge.scene != null) ...[
              ChallengeCard(
                title: 'Scene',
                child: SceneView(
                  scene: widget.challenge.scene!,
                ),
              ),
            ],
            if (widget.challenge.fillInTheBlank != null)
              ChallengeCard(
                title: 'Fill in the Blank',
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: model.getFillInBlankWidgets(
                      widget.challenge,
                      context,
                    ),
                  ),
                ),
              ),
            if (model.feedback.isNotEmpty)
              ChallengeCard(
                title: 'Feedback',
                child: Column(
                  children: parser.parse(model.feedback),
                ),
              ),
            if (widget.challenge.explanation != null &&
                widget.challenge.explanation!.isNotEmpty) ...[
              ChallengeCard(
                title: 'Explanation',
                child: Explanation(
                  explanation: widget.challenge.explanation ?? '',
                ),
              ),
            ],
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
                      onPressed: model.allInputsCorrect
                          ? () => model.learnService.goToNextChallenge(
                                widget.block.challenges.length,
                                widget.challenge,
                                widget.block,
                              )
                          : () => {model.checkAnswers(widget.challenge)},
                      child: Text(
                        model.allInputsCorrect ||
                                widget.challenge.fillInTheBlank == null
                            ? 'Go to Next Challenge'
                            : 'Check Answers',
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ),
              ],
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
          ],
        ),
      ),
    );
  }
}
