import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';
import 'package:freecodecamp/ui/views/learn/block/block_template_view.dart';
import 'package:freecodecamp/ui/views/learn/chapter/chapter_block_viewmodel.dart';

class ChapterBlockView extends ConsumerStatefulWidget {
  const ChapterBlockView({
    super.key,
    required this.moduleName,
    required this.blocks,
  });

  final String moduleName;
  final List<Block> blocks;

  @override
  ConsumerState<ChapterBlockView> createState() => _ChapterBlockViewState();
}

class _ChapterBlockViewState extends ConsumerState<ChapterBlockView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(chapterBlockViewModelProvider).init(ref);
    });
  }

  @override
  Widget build(BuildContext context) {
    final model = ref.watch(chapterBlockViewModelProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.moduleName),
      ),
      body: FocusDetector(
        onFocusGained: () {
          model.updateUserProgress();
        },
        child: ListView.builder(
          itemCount: widget.blocks.length,
          padding: const EdgeInsets.all(8),
          itemBuilder: (context, index) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (model.blockOpenStates.isEmpty) {
                Map<String, bool> openStates = {
                  for (var block in widget.blocks) block.dashedName: false
                };

                // Set first block open
                String firstBlockKey = openStates.entries.toList()[0].key;

                openStates[firstBlockKey] = true;

                model.blockOpenStates = openStates;
              }
            });

            return BlockTemplateView(
              block: widget.blocks[index],
              isOpen:
                  model.blockOpenStates[widget.blocks[index].dashedName] ?? false,
              isOpenFunction: () => model.setBlockOpenClosedState(
                widget.blocks,
                index,
              ),
            );
          },
        ),
      ),
    );
  }
}
