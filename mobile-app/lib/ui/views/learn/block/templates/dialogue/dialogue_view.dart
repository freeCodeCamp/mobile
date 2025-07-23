import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_scroll_shadow/flutter_scroll_shadow.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';
import 'package:freecodecamp/ui/theme/fcc_theme.dart';
import 'package:freecodecamp/ui/views/learn/block/block_template_viewmodel.dart';
import 'package:freecodecamp/ui/views/learn/block/templates/dialogue/dialogue_viewmodel.dart';
import 'package:freecodecamp/ui/views/learn/widgets/challenge_tile.dart';
import 'package:freecodecamp/ui/views/news/html_handler/html_handler.dart';
import 'package:stacked/stacked.dart';

class BlockDialogueView extends StatelessWidget {
  const BlockDialogueView(
      {super.key,
      required this.block,
      required this.model,
      required this.isOpen,
      required this.isOpenFunction});

  final Block block;
  final BlockTemplateViewModel model;
  final bool isOpen;
  final Function isOpenFunction;

  @override
  Widget build(BuildContext context) {
    List<ChallengeOrder> challenges = block.challenges;
    List<List<ChallengeOrder>> structure = [];
    List<ChallengeOrder> dialogueHeaders = [];
    int dialogueIndex = 0;

    dialogueHeaders.add(challenges[0]);
    structure.add([]);

    for (int i = 1; i < challenges.length; i++) {
      if (challenges[i].title.contains('Dialogue')) {
        structure.add([]);
        dialogueHeaders.add(challenges[i]);
        dialogueIndex++;
      } else {
        structure[dialogueIndex].add(challenges[i]);
      }
    }

    HTMLParser parser = HTMLParser(context: context);

    return ViewModelBuilder.reactive(
      viewModelBuilder: () => BlockDialogueViewModel(),
      builder: (context, childModel, child) => Expanded(
        child: Column(
          children: [
            ...parser.parse(
              '<p>${block.description.join(' ')}</p>',
              isSelectable: false,
              customStyles: {
                '*:not(h1):not(h2):not(h3):not(h4):not(h5):not(h6)': Style(
                  color: FccColors.gray05,
                ),
                'p': Style(margin: Margins.zero),
              },
            ),
            _buildToggleButton(context),
            _buildChallengeList(context, structure, dialogueHeaders),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleButton(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: TextButton(
            onPressed: () {
              isOpenFunction();
            },
            style: TextButton.styleFrom(
              backgroundColor: const Color.fromRGBO(0x1b, 0x1b, 0x32, 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
                side: const BorderSide(
                  color: Color.fromRGBO(0x3b, 0x3b, 0x4f, 1),
                ),
              ),
            ),
            child: Text(
              isOpen ? 'Hide Tasks' : 'Show Tasks',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChallengeList(
    BuildContext context,
    List<List<ChallengeOrder>> structure,
    List<ChallengeOrder> dialogueHeaders,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: MediaQuery.of(context).size.width - 42,
            maxWidth: MediaQuery.of(context).size.width - 42,
            minHeight: 0,
            maxHeight: 400,
          ),
          child: ListView.builder(
            padding: const EdgeInsets.all(0),
            physics: const ClampingScrollPhysics(),
            shrinkWrap: true,
            itemCount: structure.length,
            itemBuilder: (context, dialogueBlock) {
              return isOpen
                  ? _buildDialogueBlock(
                      context, structure, dialogueHeaders, dialogueBlock)
                  : Container();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDialogueBlock(
    BuildContext context,
    List<List<ChallengeOrder>> structure,
    List<ChallengeOrder> dialogueHeaders,
    int dialogueBlock,
  ) {
    return FutureBuilder(
      future: model.completedChallenge(
        dialogueHeaders[dialogueBlock].id,
      ),
      builder: (context, snapshot) {
        bool isCompleted = snapshot.data ?? false;
        return Column(
          children: [
            _buildDialogueHeader(
              context,
              dialogueHeaders,
              dialogueBlock,
              isCompleted,
            ),
            _buildTaskGrid(context, structure, dialogueBlock),
          ],
        );
      },
    );
  }

  Widget _buildDialogueHeader(
    BuildContext context,
    List<ChallengeOrder> dialogueHeaders,
    int dialogueBlock,
    bool isCompleted,
  ) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: InkWell(
              onTap: () => model.routeToChallengeView(
                block,
                dialogueHeaders[dialogueBlock].id,
              ),
              child: Container(
                constraints: const BoxConstraints(
                  minHeight: 75,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: isCompleted
                      ? const Color.fromRGBO(0x00, 0x2e, 0xad, 0.3)
                      : const Color.fromRGBO(0x2a, 0x2a, 0x40, 1),
                  border: Border.all(
                    color: isCompleted
                        ? const Color.fromRGBO(0xbc, 0xe8, 0xf1, 1)
                        : const Color.fromRGBO(0x3b, 0x3b, 0x4f, 1),
                    width: 1,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    dialogueHeaders[dialogueBlock].title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTaskGrid(
    BuildContext context,
    List<List<ChallengeOrder>> structure,
    int dialogueBlock,
  ) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: MediaQuery.of(context).size.width - 38,
        maxWidth: MediaQuery.of(context).size.width - 38,
        minHeight: 100,
        maxHeight: 5000,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding:
                const EdgeInsets.only(right: 8, left: 8, bottom: 12, top: 4),
            child: ScrollShadow(
              child: GridView.builder(
                physics: const ClampingScrollPhysics(),
                shrinkWrap: true,
                itemCount: structure[dialogueBlock].length,
                padding: const EdgeInsets.all(0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 6,
                  mainAxisSpacing: 3,
                  crossAxisSpacing: 3,
                ),
                itemBuilder: (context, task) {
                  final challenge = structure[dialogueBlock][task];

                  final match = RegExp(r'\d+').firstMatch(challenge.title);
                  final taskNumber =
                      match != null ? int.parse(match.group(0)!) : task + 1;

                  return ChallengeTile(
                    block: block,
                    model: model,
                    challengeId: challenge.id,
                    step: taskNumber,
                    isDownloaded: false,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
