import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecodecamp/learn/controllers/curriculum_controller.dart';
import 'package:freecodecamp/learn/models/curriculum_model.dart';
import 'package:freecodecamp/learn/ui/widgets/block_card.dart';
import 'package:freecodecamp/widgets/error_retry.dart';

class ModuleView extends ConsumerWidget {
  const ModuleView({super.key, required this.superBlock, required this.module});

  final String superBlock;
  final String module;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = superBlockProvider(superBlock);
    final found = ref.watch(
      provider.select(
        (s) => s.whenData(
          (superBlock) => switch (superBlock) {
            ChapterSuperBlock(:final chapters) =>
              chapters
                  .expand((chapter) => chapter.modules)
                  .firstWhereOrNull((m) => m.dashedName == module),
            BlockSuperBlock() => null,
          },
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(title: Text(found.value?.name ?? '')),
      body: found.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => ErrorRetry(
          message: 'Something went wrong!',
          onRetry: () => ref.invalidate(provider),
        ),
        data: (module) => module == null
            ? const ErrorRetry(message: 'No blocks available right now.')
            : BlockList(
                blocks: module.blocks,
                padding: const EdgeInsets.all(8),
              ),
      ),
    );
  }
}
