import 'package:mobile_app_new/learn/ui/widgets/learning_website.dart';
import 'package:mobile_app_new/widgets/app_bottom_navigation.dart';
import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app_new/learn/constants/curriculum.dart';
import 'package:mobile_app_new/learn/controllers/curriculum_controller.dart';
import 'package:mobile_app_new/learn/models/curriculum_model.dart';
import 'package:mobile_app_new/learn/ui/widgets/block_card.dart';
import 'package:mobile_app_new/learn/ui/widgets/learn_presentation.dart';
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
      bottomNavigationBar: const AppNavigationFooter(
        selected: AppDestination.learn,
      ),
      appBar: AppBar(title: const Text('Courses')),
      body: superBlock.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => ErrorRetry(
          message: 'Something went wrong!',
          onRetry: () => ref.invalidate(provider),
        ),
        data: (superBlock) => RefreshIndicator(
          onRefresh: () =>
              ref.refresh(provider.future).then((_) {}, onError: (_) {}),
          child: switch (superBlock) {
            BlockSuperBlock(:final blocks) => BlockList(
              blocks: blocks,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
              header: _CourseHero(title: title ?? 'Course', blocks: blocks),
            ),
            ChapterSuperBlock(:final chapters) => _Chapters(
              title: title ?? 'Course',
              superBlock: widget.dashedName,
              chapters: chapters,
            ),
          },
        ),
      ),
    );
  }
}

bool _locked(Chapter chapter) =>
    chapter.comingSoon ||
    (devOnlyChapters.contains(chapter.dashedName) &&
        !(dotenv.isInitialized &&
            dotenv.getBool('DEVELOPMENT_MODE', fallback: false)));

class _Chapters extends ConsumerWidget {
  const _Chapters({
    required this.title,
    required this.superBlock,
    required this.chapters,
  });
  final String title;
  final String superBlock;
  final List<Chapter> chapters;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exams = this.chapters
        .where((c) => hiddenExamChapters.contains(c.dashedName))
        .toList();
    final chapters = this.chapters
        .where((c) => !hiddenExamChapters.contains(c.dashedName))
        .toList();
    final completed = ref.watch(
      authProvider.select(
        (s) => {...?s.value?.completedChallenges.map((c) => c.id)},
      ),
    );
    final available = chapters.where((c) => !_locked(c));
    final blocks = available
        .expand((c) => c.modules.where((m) => !m.comingSoon))
        .expand((m) => m.blocks)
        .toList();
    final active = available.firstWhereOrNull(
      (c) => c.modules
          .where((m) => !m.comingSoon)
          .expand((m) => m.blocks)
          .expand((b) => b.challenges)
          .any((ch) => !completed.contains(ch.id)),
    );
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
      children: [
        _CourseHero(title: title, blocks: blocks),
        if (chapters.isEmpty)
          const Padding(
            padding: EdgeInsets.all(24),
            child: Text('No chapters available right now.'),
          ),
        for (final (index, chapter) in chapters.indexed)
          _ChapterCard(
            key: ValueKey(chapter.dashedName),
            superBlock: superBlock,
            chapter: chapter,
            number: index + 1,
            active: chapter == active,
            isLocked: _locked(chapter),
          ),
        for (final exam in exams)
          Card(
            margin: const EdgeInsets.only(top: 8, bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  LearnEyebrow('Chapter ${this.chapters.indexOf(exam) + 1}'),
                  const SizedBox(height: 8),
                  Text(
                    'Certification Exam',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _locked(exam)
                        ? 'This exam is coming soon.'
                        : 'Complete the exam on freeCodeCamp.org to earn your certification.',
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: _locked(exam)
                        ? null
                        : () => openLearningWebsite(
                            context,
                            superBlock,
                            chapter: exam.dashedName,
                          ),
                    icon: const Icon(Icons.open_in_new, size: 18),
                    label: const Text('Open exam on website'),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _CourseHero extends ConsumerWidget {
  const _CourseHero({required this.title, required this.blocks});
  final String title;
  final List<Block> blocks;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final completed = ref.watch(
      authProvider.select(
        (s) => {...?s.value?.completedChallenges.map((c) => c.id)},
      ),
    );
    final available = blocks.where((b) => !b.isDisabledByOverride);
    final challenges = available.expand((b) => b.challenges).toList();
    final done = challenges.where((c) => completed.contains(c.id)).length;
    final nextBlock = available.firstWhereOrNull(
      (b) => b.challenges.any((c) => !completed.contains(c.id)),
    );
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.primaryContainer,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 14),
          LearnProgress(
            done: done,
            total: challenges.length,
            backgroundColor: colors.surface,
          ),
          const SizedBox(height: 10),
          Text(
            '$done of ${challenges.length} steps complete',
            style: TextStyle(color: colors.onSurfaceVariant, fontSize: 12),
          ),
          if (nextBlock != null) ...[
            const SizedBox(height: 14),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.icon(
                onPressed: () => LearnChallengeRoute(
                  superBlock: nextBlock.superBlock,
                  block: nextBlock.dashedName,
                  challengeId: nextBlock.challenges
                      .firstWhere((c) => !completed.contains(c.id))
                      .id,
                ).push<void>(context),
                icon: const Icon(Icons.arrow_forward, size: 18),
                iconAlignment: IconAlignment.end,
                label: Text(done > 0 ? 'Continue' : 'Start learning'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ChapterCard extends ConsumerWidget {
  const _ChapterCard({
    super.key,
    required this.superBlock,
    required this.chapter,
    required this.number,
    required this.active,
    required this.isLocked,
  });
  final String superBlock;
  final Chapter chapter;
  final int number;
  final bool active;
  final bool isLocked;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final completed = ref.watch(
      authProvider.select(
        (s) => {...?s.value?.completedChallenges.map((c) => c.id)},
      ),
    );
    final modules = chapter.modules.where((m) => !m.comingSoon).toList();
    final current = modules.firstWhereOrNull(
      (m) => m.blocks
          .expand((b) => b.challenges)
          .any((c) => !completed.contains(c.id)),
    );
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: ExpansionTile(
          key: PageStorageKey(chapter.dashedName),
          initiallyExpanded: active && !isLocked,
          enabled: !isLocked,
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          childrenPadding: const EdgeInsets.fromLTRB(8, 0, 8, 12),
          shape: const Border(),
          collapsedShape: const Border(),
          leading: Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: active ? colors.primary : colors.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '$number',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: active ? colors.onPrimary : colors.primary,
              ),
            ),
          ),
          title: Text(
            chapter.name,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          subtitle: isLocked
              ? Text(
                  'Coming soon',
                  style: TextStyle(
                    fontSize: 12,
                    color: colors.onSurfaceVariant,
                  ),
                )
              : null,
          children: [
            Stack(
              children: [
                if (modules.length > 1)
                  Positioned(
                    left: 25,
                    top: 28,
                    bottom: 28,
                    child: Container(width: 2, color: colors.outlineVariant),
                  ),
                Column(
                  children: [
                    for (final module in modules)
                      _ModuleButton(
                        superBlock: superBlock,
                        module: module,
                        active: module == current,
                      ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ModuleButton extends ConsumerWidget {
  const _ModuleButton({
    required this.superBlock,
    required this.module,
    required this.active,
  });
  final String superBlock;
  final Module module;
  final bool active;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final blocks = module.blocks;
    final challenges = blocks.expand((b) => b.challenges).toList();
    final completed = ref.watch(
      authProvider.select(
        (s) => {...?s.value?.completedChallenges.map((c) => c.id)},
      ),
    );
    final done = challenges.where((c) => completed.contains(c.id)).length;
    final complete = challenges.isNotEmpty && done == challenges.length;
    final isReview = blocks.firstOrNull?.label == BlockLabel.review;
    final subtitle = module.moduleType == ModuleType.certProject
        ? 'Certification project'
        : isReview
        ? RegExp(r'\breview\b', caseSensitive: false).hasMatch(module.name)
              ? null
              : 'Review'
        : '$done/${challenges.length} steps';
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Material(
        color: active
            ? Color.alphaBlend(
                colors.primaryContainer.withValues(alpha: .4),
                colors.surface,
              )
            : Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: active
                ? colors.primary.withValues(alpha: .4)
                : Colors.transparent,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: challenges.isEmpty
              ? null
              : () {
                  if (challenges.length == 1) {
                    final block = blocks.firstWhere(
                      (b) => b.challenges.isNotEmpty,
                    );
                    LearnChallengeRoute(
                      superBlock: superBlock,
                      block: block.dashedName,
                      challengeId: challenges.first.id,
                    ).push<void>(context);
                  } else {
                    LearnModuleRoute(
                      superBlock: superBlock,
                      module: module.dashedName,
                    ).push<void>(context);
                  }
                },
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                LearnStatus(complete: complete, active: active),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        module.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 3),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 12,
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                      ],
                      if (active) ...[
                        const SizedBox(height: 6),
                        LearnProgress(done: done, total: challenges.length),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.chevron_right,
                  size: 20,
                  color: colors.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
