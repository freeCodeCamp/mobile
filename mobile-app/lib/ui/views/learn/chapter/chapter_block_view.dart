import 'package:flutter/material.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';
import 'package:freecodecamp/ui/views/learn/block/block_template_view.dart';
import 'package:freecodecamp/ui/views/learn/chapter/chapter_block_viewmodel.dart';
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
          body: ListView.builder(
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
              });

              return BlockTemplateView(
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
        );
      },
    );
  }
}
