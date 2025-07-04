import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';
import 'package:freecodecamp/ui/views/learn/block/block_template_view.dart';
import 'package:freecodecamp/ui/views/learn/chapter/chapter_block_viewmodel.dart';
import 'package:freecodecamp/ui/widgets/floating_navigation_buttons.dart';
import 'package:stacked/stacked.dart';

class ChapterBlockView extends StatelessWidget {
  const ChapterBlockView({
    super.key,
    required this.moduleName,
    required this.blocks,
  });

  final String moduleName;
  final List<Block> blocks;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
      viewModelBuilder: () => ChapterBlockViewmodel(),
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(moduleName),
          ),
          floatingActionButton: blocks.isNotEmpty
              ? FloatingNavigationButtons(
                  onPrevious: model.scrollToPrevious,
                  onNext: model.scrollToNext,
                  hasPrevious: model.hasPrevious,
                  hasNext: model.hasNext,
                  isAnimating: model.isAnimating,
                )
              : null,
          body: FocusDetector(
                onFocusGained: () {
                  model.updateUserProgress();
                },
                child: ListView.builder(
                  controller: model.scrollController,
                  itemCount: blocks.length,
                  padding: const EdgeInsets.all(8),
                  itemBuilder: (context, index) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (model.blockOpenStates.isEmpty) {
                        Map<String, bool> openStates = {
                          for (var block in blocks) block.dashedName: false
                        };

                        // Set first block open
                        String firstBlockKey = openStates.entries.toList()[0].key;

                        openStates[firstBlockKey] = true;

                        model.blockOpenStates = openStates;
                      }
                      
                      if (model.blocks.isEmpty) {
                        model.setBlocks(blocks);
                        model.initializeScrollListener();
                      }
                    });

                    return BlockTemplateView(
                      key: model.blockKeys.isNotEmpty && index < model.blockKeys.length 
                          ? model.blockKeys[index] 
                          : ValueKey(index),
                      block: blocks[index],
                      isOpen:
                          model.blockOpenStates[blocks[index].dashedName] ?? false,
                      isOpenFunction: () => model.setBlockOpenClosedState(
                        blocks,
                        index,
                      ),
                    );
                  },
                ),
              ),
        );
      },
    );
  }
}
