import 'package:flutter/material.dart';
import 'package:flutter_scroll_shadow/flutter_scroll_shadow.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';
import 'package:freecodecamp/ui/theme/fcc_theme.dart';
import 'package:freecodecamp/ui/views/learn/block/block_template_viewmodel.dart';
import 'package:freecodecamp/ui/views/learn/block/templates/grid/grid_viewmodel.dart';
import 'package:freecodecamp/ui/views/learn/widgets/challenge_tile.dart';
import 'package:freecodecamp/ui/views/news/html_handler/html_handler.dart';
import 'package:stacked/stacked.dart';

class BlockGridView extends StatelessWidget {
  const BlockGridView({
    super.key,
    required this.block,
    required this.model,
    required this.isOpen,
    required this.isOpenFunction,
    required this.color,
  });

  final Block block;
  final BlockTemplateViewModel model;
  final bool isOpen;
  final Function isOpenFunction;
  final Color color;

  @override
  Widget build(BuildContext context) {
    // We want to make sure never to divide by 0 and show
    // a progress percentage of 1% if non have been completed.

    double progress = model.challengesCompleted == 0
        ? 0.01
        : model.challengesCompleted / block.challenges.length;

    HTMLParser parser = HTMLParser(context: context);

    return ViewModelBuilder.reactive(
      viewModelBuilder: () => BlockGridViewModel(),
      builder: (context, childModel, child) => Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                model.challengesCompleted == block.challenges.length
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Icon(
                                Icons.check_circle,
                                color: color,
                              ),
                            ),
                            Text(
                              'Completed',
                              style: TextStyle(
                                  color: color, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      )
                    : Container(
                        padding: const EdgeInsets.all(10),
                        // For some dumb reason the progress indicator does not
                        // get a specified width from the column.
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: LinearProgressIndicator(
                          minHeight: 12,
                          value: progress,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            color,
                          ),
                          backgroundColor:
                              const Color.fromRGBO(0x2a, 0x2a, 0x40, 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
              ],
            ),
            ...parser.parse(
              '<p>${block.description.join(' ')}</p>',
              fontColor: FccColors.gray05,
              removeParagraphMargin: true,
              isSelectable: false,
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextButton(
                    onPressed: () {
                      isOpenFunction();
                    },
                    style: TextButton.styleFrom(
                      backgroundColor:
                          const Color.fromRGBO(0x1b, 0x1b, 0x32, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                        side: const BorderSide(
                          color: Color.fromRGBO(0x3b, 0x3b, 0x4f, 1),
                        ),
                      ),
                    ),
                    child: Text(
                      isOpen ? 'Hide Steps' : 'Show Steps',
                    ),
                  ),
                ),
              ],
            ),
            if (isOpen)
              Container(
                padding: const EdgeInsets.all(8),
                constraints: BoxConstraints(
                  maxHeight: 300,
                ),
                child: Builder(builder: (context) {
                  final tiles = block.challengeTiles.length;

                  final scrollOn = tiles > 24;

                  return ScrollShadow(
                    child: GridView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(0),
                      physics: scrollOn
                          ? const AlwaysScrollableScrollPhysics()
                          : const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 6,
                        mainAxisSpacing: 3,
                        crossAxisSpacing: 3,
                      ),
                      itemCount: block.challenges.length,
                      itemBuilder: (context, step) {
                        final challenge = block.challengeTiles[step];
                        final match = RegExp(r'\d+').firstMatch(challenge.name);
                        final stepNumber = match != null
                            ? int.parse(match.group(0)!)
                            : step + 1;

                        return ChallengeTile(
                          block: block,
                          model: model,
                          step: stepNumber,
                          challengeId: challenge.id,
                          isDownloaded: false,
                        );
                      },
                    ),
                  );
                }),
              )
          ],
        ),
      ),
    );
  }
}
