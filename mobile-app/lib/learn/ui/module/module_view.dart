import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecodecamp/fcc_theme.dart';
import 'package:freecodecamp/learn/controllers/curriculum_controller.dart';
import 'package:freecodecamp/learn/models/curriculum_model.dart';
import 'package:freecodecamp/learn/ui/widgets/block_card.dart';
import 'package:freecodecamp/routing/learn.dart';
import 'package:freecodecamp/services/auth_service.dart';
import 'package:freecodecamp/widgets/app_bottom_navigation.dart';
import 'package:freecodecamp/widgets/error_retry.dart';

class ModuleView extends ConsumerWidget {
  const ModuleView({super.key, required this.superBlock, required this.module});
  final String superBlock;
  final String module;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = superBlockProvider(superBlock);
    final curriculum = ref.watch(provider);
    final fullCourseTitle = ref.watch(
      curriculumStagesProvider.select(
        (s) => s.value
            ?.expand((stage) => stage.superBlocks)
            .firstWhereOrNull((sb) => sb.dashedName == superBlock)
            ?.title,
      ),
    );
    final courseTitle = fullCourseTitle?.replaceFirst(
      RegExp(r'\s+Certification$', caseSensitive: false),
      '',
    );
    final found = switch (curriculum.value) {
      ChapterSuperBlock(:final chapters) =>
        chapters
            .expand((c) => c.modules)
            .firstWhereOrNull((m) => m.dashedName == module),
      _ => null,
    };
    return Scaffold(
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (found != null) ModuleActionBar(blocks: found.blocks),
          const AppNavigationFooter(selected: AppDestination.learn),
        ],
      ),
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: FccDesignColors.of(context).accentText,
        toolbarHeight: 56 + MediaQuery.textScalerOf(context).scale(18) - 18,
        leadingWidth: 44,
        titleSpacing: 0,
        leading: IconButton(
          tooltip: 'Back to ${courseTitle ?? 'course'}',
          icon: const Icon(Icons.chevron_left),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              LearnSuperBlockRoute(superBlock: superBlock).go(context);
            }
          },
        ),
        title: Text(
          courseTitle ?? 'Course',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: FccDesignColors.of(context).accentText,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: curriculum.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => ErrorRetry(
          message: 'Something went wrong!',
          onRetry: () => ref.invalidate(provider),
        ),
        data: (curriculum) {
          final chapter = switch (curriculum) {
            ChapterSuperBlock(:final chapters) => chapters.firstWhereOrNull(
              (c) => c.modules.any((m) => m.dashedName == module),
            ),
            BlockSuperBlock() => null,
          };
          final found = chapter?.modules.firstWhereOrNull(
            (m) => m.dashedName == module,
          );
          if (found == null) {
            return const ErrorRetry(message: 'No blocks available right now.');
          }
          return BlockList(
            blocks: found.blocks,
            showActions: false,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
            header: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    found.name,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class ModuleActionBar extends ConsumerWidget {
  const ModuleActionBar({super.key, required this.blocks});
  final List<Block> blocks;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final completed = ref.watch(
      authProvider.select(
        (s) => {...?s.value?.completedChallenges.map((c) => c.id)},
      ),
    );
    final available = blocks.where(
      (b) => !b.isDisabledByOverride && b.challenges.isNotEmpty,
    );
    final current =
        available.firstWhereOrNull(
          (b) => b.challenges.any((c) => !completed.contains(c.id)),
        ) ??
        available.firstOrNull;
    if (current == null) return const SizedBox.shrink();
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(top: BorderSide(color: colors.outlineVariant)),
      ),
      child: BlockActionButton(
        block: current,
        completed: completed,
        height: 52,
        showArrow: true,
      ),
    );
  }
}
