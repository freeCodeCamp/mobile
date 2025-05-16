import 'package:flutter/material.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';
import 'package:freecodecamp/ui/views/learn/block/block_template_viewmodel.dart';
import 'package:freecodecamp/ui/views/learn/block/templates/grid/grid_viewmodel.dart';
import 'package:stacked/stacked.dart';

class BlockListView extends StatelessWidget {
  const BlockListView({
    super.key,
    required this.block,
    required this.model,
    required this.isOpen,
    required this.isOpenFunction,
  });

  final Block block;
  final BlockTemplateViewModel model;
  final bool isOpen;
  final Function isOpenFunction;

  @override
  Widget build(BuildContext context) {
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
                    isOpen ? 'Hide' : 'Show',
                  ),
                ),
              ),
            ],
          ),
          if (isOpen)
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  width: MediaQuery.of(context).size.width - 34,
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemCount: block.challenges.length,
                    itemBuilder: (context, index) {
                      bool isCompleted =
                          model.completedChallenge(block.challenges[index].id);

                      return InkWell(
                        onTap: () {
                          model.routeToChallengeView(
                            block,
                            block.challenges[index].id,
                          );
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                            side: isCompleted
                                ? const BorderSide(
                                    width: 1,
                                    color: Color.fromRGBO(0xbc, 0xe8, 0xf1, 1),
                                  )
                                : const BorderSide(
                                    color: Color.fromRGBO(0x3b, 0x3b, 0x4f, 1),
                                  ),
                          ),
                          color: isCompleted
                              ? const Color.fromRGBO(0x00, 0x2e, 0xad, 0.3)
                              : const Color.fromRGBO(0x2a, 0x2a, 0x40, 1),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(block.challenges[index].title),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
