import 'package:flutter/material.dart';
import 'package:flutter_scroll_shadow/flutter_scroll_shadow.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';
import 'package:freecodecamp/ui/views/learn/block/block_template_viewmodel.dart';
import 'package:freecodecamp/ui/views/learn/block/templates/grid/grid_viewmodel.dart';
import 'package:freecodecamp/ui/views/learn/widgets/challenge_tile.dart';
import 'package:stacked/stacked.dart';

class BlockGridView extends StatelessWidget {
  const BlockGridView({
    Key? key,
    required this.block,
    required this.model,
  }) : super(key: key);

  final Block block;
  final BlockTemplateViewModel model;

  @override
  Widget build(BuildContext context) {
    // We want to make sure never to divide by 0 and show
    // a progress percentage of 1% if non have been completed.

    double progress = model.challengesCompleted == 0
        ? 0.01
        : model.challengesCompleted / block.challenges.length;

    return ViewModelBuilder.reactive(
      viewModelBuilder: () => BlockGridViewModel(),
      builder: (context, childModel, child) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            // For some dumb reason the progress indicator does not
            // get a specified width from the column.
            width: MediaQuery.of(context).size.width * 0.9,
            child: LinearProgressIndicator(
              minHeight: 10,
              value: progress,
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color.fromRGBO(0x99, 0xc9, 0xff, 1),
              ),
              backgroundColor: const Color.fromRGBO(0x2a, 0x2a, 0x40, 1),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: TextButton(
                  onPressed: () {
                    model.setIsOpen = !model.isOpen;
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
                    model.isOpen ? 'Hide Steps' : 'Show Steps',
                  ),
                ),
              ),
            ],
          ),
          if (model.isOpen)
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  height: 195,
                  width: MediaQuery.of(context).size.width - 34,
                  child: ScrollShadow(
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 6,
                        mainAxisSpacing: 3,
                        crossAxisSpacing: 3,
                      ),
                      itemCount: block.challenges.length,
                      itemBuilder: (context, step) {
                        return ChallengeTile(
                          block: block,
                          model: model,
                          step: step + 1,
                          challengeId: block.challengeTiles[step].id,
                          isDownloaded: false,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
