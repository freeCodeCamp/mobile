import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app_new/fcc_theme.dart';
import 'package:mobile_app_new/learn/constants/curriculum.dart';
import 'package:mobile_app_new/learn/controllers/curriculum_controller.dart';
import 'package:mobile_app_new/learn/models/curriculum_model.dart';
import 'package:mobile_app_new/learn/ui/widgets/block_card.dart';
import 'package:mobile_app_new/routing/learn.dart';
import 'package:mobile_app_new/services/auth_service.dart';
import 'package:mobile_app_new/widgets/error_retry.dart';

class SuperBlockView extends ConsumerStatefulWidget {
  const SuperBlockView({super.key, required this.dashedName});

  final String dashedName;

  @override
  ConsumerState<SuperBlockView> createState() => _SuperBlockViewState();
}

class _SuperBlockViewState extends ConsumerState<SuperBlockView> {
  @override
  void initState() {
    super.initState();
    unawaited(ref.read(authProvider.notifier).refresh());
  }

  @override
  Widget build(BuildContext context) {
    final provider = superBlockProvider(widget.dashedName);
    final superBlock = ref.watch(provider);
    final title = ref.watch(
      curriculumStagesProvider.select(
        (s) => s.value
            ?.expand((stage) => stage.superBlocks)
            .firstWhereOrNull((sb) => sb.dashedName == widget.dashedName)
            ?.title,
      ),
    );

    return Scaffold(
      backgroundColor: FccColors.gray90,
      appBar: AppBar(title: Text(title ?? '')),
      body: superBlock.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => ErrorRetry(
          message: 'Something went wrong!',
          onRetry: () => ref.invalidate(provider),
        ),
        data: (superBlock) => RefreshIndicator(
          onRefresh: () =>
              ref.refresh(provider.future).then((_) {}, onError: (_) {}),
          backgroundColor: FccColors.gray90,
          color: Colors.white,
          child: switch (superBlock) {
            BlockSuperBlock(:final blocks) => _Blocks(blocks: blocks),
            ChapterSuperBlock(:final chapters) => _Chapters(
              superBlock: widget.dashedName,
              chapters: chapters
                  .where((c) => !hiddenExamChapters.contains(c.dashedName))
                  .toList(),
            ),
          },
        ),
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty();

  @override
  Widget build(BuildContext context) {
    // NOTE: A ListView so pull-to-refresh still works.
    return ListView(
      children: const [
        Padding(
          padding: EdgeInsets.all(64),
          child: Center(child: Text('No blocks available right now.')),
        ),
      ],
    );
  }
}

class _Blocks extends StatelessWidget {
  const _Blocks({required this.blocks});

  final List<Block> blocks;

  @override
  Widget build(BuildContext context) {
    if (blocks.isEmpty) return const _Empty();

    return BlockList(
      blocks: blocks,
      padding: const EdgeInsets.fromLTRB(8, 16, 8, 32),
    );
  }
}

class _Chapters extends StatelessWidget {
  const _Chapters({required this.superBlock, required this.chapters});

  final String superBlock;
  final List<Chapter> chapters;

  @override
  Widget build(BuildContext context) {
    if (chapters.isEmpty) return const _Empty();

    final isDev = dotenv.getBool('DEVELOPMENT_MODE', fallback: false);

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        for (final chapter in chapters)
          _ChapterCard(
            superBlock: superBlock,
            chapter: chapter,
            isLocked: devOnlyChapters.contains(chapter.dashedName) && !isDev,
          ),
      ],
    );
  }
}

class _ChapterCard extends StatelessWidget {
  const _ChapterCard({
    required this.superBlock,
    required this.chapter,
    required this.isLocked,
  });

  final String superBlock;
  final Chapter chapter;
  final bool isLocked;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      decoration: const BoxDecoration(
        color: FccColors.gray85,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              chapter.name,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
          ),
          if (chapter.comingSoon || isLocked)
            Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(5),
              ),
              child: const Text('Coming Soon'),
            ),
          if (!isLocked)
            for (final module in chapter.modules)
              if (!module.comingSoon)
                _ModuleButton(superBlock: superBlock, module: module),
        ],
      ),
    );
  }
}

class _ModuleButton extends ConsumerWidget {
  const _ModuleButton({required this.superBlock, required this.module});

  final String superBlock;
  final Module module;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final challenges = [for (final block in module.blocks) ...block.challenges];
    final isSingleStep = challenges.length == 1;
    final isReview = module.blocks.first.label == BlockLabel.review;
    final isCertProject = module.moduleType == ModuleType.certProject;
    final color = isReview
        ? FccColors.orange30
        : isCertProject
        ? FccColors.green40
        : FccColors.blue30;
    final textColor = isSingleStep ? color : Colors.white;

    final completedCount = ref.watch(
      authProvider.select((s) {
        final completed = {...?s.value?.completedChallenges.map((c) => c.id)};
        return challenges.where((c) => completed.contains(c.id)).length;
      }),
    );

    final subtitle = isCertProject
        ? 'Certification Project'
        : isReview
        ? 'Review'
        : null;

    return Container(
      margin: const EdgeInsets.all(5),
      constraints: const BoxConstraints(minHeight: 100),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isSingleStep ? 0.3 : 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: color.withValues(alpha: isSingleStep ? 0.5 : 0.4),
          width: 2,
        ),
      ),
      child: TextButton(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.all(12),
          alignment: Alignment.centerLeft,
          minimumSize: const Size.fromHeight(100),
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          overlayColor: Colors.white,
        ),
        onPressed: () {
          final block = module.blocks.first;
          if (isSingleStep && block.challenges.isNotEmpty) {
            LearnChallengeRoute(
              superBlock: superBlock,
              block: block.dashedName,
              challengeId: block.challenges.first.id,
            ).push<void>(context);
          } else {
            LearnModuleRoute(
              superBlock: superBlock,
              module: module.dashedName,
            ).push<void>(context);
          }
        },
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    module.name,
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  if (subtitle != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        subtitle,
                        style: TextStyle(
                          color: color.withValues(alpha: 0.8),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  if (!isSingleStep && !isReview)
                    Text(
                      '$completedCount/${challenges.length} Steps Complete',
                      style: const TextStyle(
                        color: FccColors.gray15,
                        fontSize: 18,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              isSingleStep
                  ? Icons.play_arrow_rounded
                  : Icons.arrow_forward_ios_outlined,
              size: 25,
              color: textColor,
            ),
          ],
        ),
      ),
    );
  }
}
